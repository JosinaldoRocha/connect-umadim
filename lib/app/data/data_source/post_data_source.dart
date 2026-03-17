import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../core/helpers/errors/common_errors.dart';
import '../enums/post_type_enum.dart';
import '../models/poll_option_model.dart';
import '../models/post_model.dart';

class PostDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final SupabaseClient _supabase;

  PostDataSource({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required SupabaseClient supabase,
  })  : _firestore = firestore,
        _auth = auth,
        _supabase = supabase;

  // ── Referências ──────────────────────────────────────────────
  CollectionReference<Map<String, dynamic>> get _postsRef =>
      _firestore.collection('posts');

  String get _currentUid => _auth.currentUser!.uid;

  // ── Buscar feed (todos da UMADIM, mais recentes primeiro) ─────
  /// Retorna stream paginado — [limit] posts por vez
  Stream<Either<CommonError, List<PostModel>>> watchFeed({int limit = 20}) {
    return _postsRef
        .orderBy('isPinned', descending: true)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) {
      try {
        final posts =
            snap.docs.map((doc) => PostModel.fromSnapshot(doc)).toList();
        return Right(posts);
      } catch (e) {
        return Left(CommonError.undefined());
      }
    });
  }

  // ── Criar post ───────────────────────────────────────────────
  Future<Either<CommonError, PostModel>> createPost({
    required PostType type,
    required String content,
    required String congregation,
    required String areaId,
    File? mediaFile,
    List<String>? pollOptionTexts,
    DateTime? pollEndsAt,
  }) async {
    try {
      final id = const Uuid().v4();
      String? mediaUrl;
      String? mediaType;

      // Upload de mídia no Supabase Storage
      if (mediaFile != null) {
        mediaType = type == PostType.video ? 'video' : 'image';
        final ext = mediaFile.path.split('.').last;
        final path = 'posts/$id.$ext';
        await _supabase.storage.from('umadim-media').upload(path, mediaFile);
        mediaUrl = _supabase.storage.from('umadim-media').getPublicUrl(path);
      }

      // Montar opções da enquete
      final options = pollOptionTexts
              ?.asMap()
              .entries
              .map((e) => PollOptionModel(
                    id: const Uuid().v4(),
                    text: e.value,
                    voterIds: [],
                  ))
              .toList() ??
          [];

      // Dados do autor
      final userDoc =
          await _firestore.collection('users').doc(_currentUid).get();
      final authorName = userDoc.data()?['name'] as String? ?? '';
      final authorPhotoUrl = userDoc.data()?['photoUrl'] as String?;

      final post = PostModel(
        id: id,
        authorId: _currentUid,
        authorName: authorName,
        authorPhotoUrl: authorPhotoUrl,
        congregation: congregation,
        areaId: areaId,
        type: type,
        content: content,
        mediaUrl: mediaUrl,
        mediaType: mediaType,
        likeIds: [],
        commentCount: 0,
        pollOptions: options,
        pollEndsAt: pollEndsAt,
        presenceIds: [],
        isPinned: false,
        createdAt: DateTime.now(),
      );

      await _postsRef.doc(id).set(post.toMap());
      return Right(post);
    } catch (e) {
      return Left(CommonError.undefined());
    }
  }

  // ── Deletar post ─────────────────────────────────────────────
  Future<Either<CommonError, Unit>> deletePost(String postId) async {
    try {
      await _postsRef.doc(postId).delete();
      // TODO: deletar mídia do Supabase Storage também
      return const Right(unit);
    } catch (e) {
      return Left(CommonError.undefined());
    }
  }

  // ── Curtir / descurtir ───────────────────────────────────────
  Future<Either<CommonError, Unit>> toggleLike(String postId) async {
    try {
      final uid = _currentUid;
      final ref = _postsRef.doc(postId);

      await _firestore.runTransaction((tx) async {
        final snap = await tx.get(ref);
        final likes = List<String>.from(snap['likeIds'] ?? []);
        if (likes.contains(uid)) {
          likes.remove(uid);
        } else {
          likes.add(uid);
        }
        tx.update(ref, {'likeIds': likes});
      });
      return const Right(unit);
    } catch (e) {
      return Left(CommonError.undefined());
    }
  }

  // ── Confirmar presença (eventos/avisos) ──────────────────────
  Future<Either<CommonError, Unit>> togglePresence(String postId) async {
    try {
      final uid = _currentUid;
      final ref = _postsRef.doc(postId);

      await _firestore.runTransaction((tx) async {
        final snap = await tx.get(ref);
        final presences = List<String>.from(snap['presenceIds'] ?? []);
        if (presences.contains(uid)) {
          presences.remove(uid);
        } else {
          presences.add(uid);
        }
        tx.update(ref, {'presenceIds': presences});
      });
      return const Right(unit);
    } catch (e) {
      return Left(CommonError.undefined());
    }
  }

  // ── Votar em enquete ─────────────────────────────────────────
  Future<Either<CommonError, Unit>> votePoll({
    required String postId,
    required String optionId,
  }) async {
    try {
      final uid = _currentUid;
      final ref = _postsRef.doc(postId);

      await _firestore.runTransaction((tx) async {
        final snap = await tx.get(ref);
        final rawOptions =
            List<Map<String, dynamic>>.from(snap['pollOptions'] ?? []);

        // Remove voto anterior em qualquer opção
        final updated = rawOptions.map((opt) {
          final voters = List<String>.from(opt['voterIds'] ?? []);
          voters.remove(uid);
          if (opt['id'] == optionId) voters.add(uid);
          return {...opt, 'voterIds': voters};
        }).toList();

        tx.update(ref, {'pollOptions': updated});
      });
      return const Right(unit);
    } catch (e) {
      return Left(CommonError.undefined());
    }
  }

  // ── Fixar / desafixar post (só líder) ───────────────────────
  Future<Either<CommonError, Unit>> togglePin(String postId) async {
    try {
      final ref = _postsRef.doc(postId);
      final snap = await ref.get();
      final current = (snap.data()?['isPinned'] as bool?) ?? false;
      await ref.update({'isPinned': !current});
      return const Right(unit);
    } catch (e) {
      return Left(CommonError.undefined());
    }
  }
}
