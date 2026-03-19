import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../core/helpers/errors/common_errors.dart';
import '../models/story_model.dart';

class StoryDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final SupabaseClient _supabase;

  StoryDataSource({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required SupabaseClient supabase,
  })  : _firestore = firestore,
        _auth = auth,
        _supabase = supabase;

  CollectionReference<Map<String, dynamic>> get _storiesRef =>
      _firestore.collection('stories');

  String get _currentUid => _auth.currentUser!.uid;

  // ── Buscar stories ativos (não expirados, últimas 24h) ────────
  Stream<Either<CommonError, List<StoryGroup>>> watchActiveStories() {
    final cutoff = Timestamp.fromDate(
      DateTime.now().subtract(const Duration(hours: 24)),
    );

    return _storiesRef
        .where('createdAt', isGreaterThan: cutoff)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) {
      try {
        final stories = snap.docs
            .map((d) => StoryModel.fromQuerySnapshot(d))
            .where((s) => !s.isExpired)
            .toList();

        // Agrupa por autor
        final groups = _groupByAuthor(stories);
        return Right(groups);
      } catch (e) {
        return Left(CommonError.undefined());
      }
    });
  }

  // ── Criar story ───────────────────────────────────────────────
  Future<Either<CommonError, StoryModel>> createStory({
    required File mediaFile,
    required String mediaType, // 'image' | 'video'
    required String congregation,
    required String areaId,
    String? caption,
  }) async {
    try {
      final id = const Uuid().v4();

      // Upload no Supabase
      final ext = mediaFile.path.split('.').last;
      final path = 'stories/$id.$ext';
      await _supabase.storage.from('umadim-media').upload(path, mediaFile);
      final mediaUrl =
          _supabase.storage.from('umadim-media').getPublicUrl(path);

      // Dados do autor
      final userDoc =
          await _firestore.collection('users').doc(_currentUid).get();
      final authorName = userDoc.data()?['name'] as String? ?? '';
      final authorPhotoUrl = userDoc.data()?['photoUrl'] as String?;

      final now = DateTime.now();
      final story = StoryModel(
        id: id,
        authorId: _currentUid,
        authorName: authorName,
        authorPhotoUrl: authorPhotoUrl,
        congregation: congregation,
        areaId: areaId,
        mediaUrl: mediaUrl,
        mediaType: mediaType,
        caption: caption,
        viewerIds: [],
        expiresAt: now.add(const Duration(hours: 24)),
        createdAt: now,
      );

      await _storiesRef.doc(id).set(story.toMap());
      return Right(story);
    } catch (e, st) {
      debugPrint('StoryDataSource.createStory erro: $e');
      debugPrint('StackTrace: $st');
      return Left(CommonError.undefined());
    }
  }

  // ── Marcar story como visto ───────────────────────────────────
  Future<Either<CommonError, Unit>> markAsViewed(String storyId) async {
    try {
      final uid = _currentUid;
      await _storiesRef.doc(storyId).update({
        'viewerIds': FieldValue.arrayUnion([uid]),
      });
      return const Right(unit);
    } catch (e) {
      return Left(CommonError.undefined());
    }
  }

  // ── Deletar story ─────────────────────────────────────────────
  Future<Either<CommonError, Unit>> deleteStory(String storyId) async {
    try {
      await _storiesRef.doc(storyId).delete();
      return const Right(unit);
    } catch (e) {
      return Left(CommonError.undefined());
    }
  }

  // ── Helper: agrupar por autor ─────────────────────────────────
  List<StoryGroup> _groupByAuthor(List<StoryModel> stories) {
    final Map<String, List<StoryModel>> map = {};

    for (final s in stories) {
      map.putIfAbsent(s.authorId, () => []).add(s);
    }

    return map.entries.map((entry) {
      final list = entry.value;
      return StoryGroup(
        authorId: entry.key,
        authorName: list.first.authorName,
        authorPhotoUrl: list.first.authorPhotoUrl,
        congregation: list.first.congregation,
        stories: list,
      );
    }).toList()
      // Grupos com stories não vistos primeiro
      ..sort((a, b) {
        final aUnseen = !a.isAllSeenBy(_currentUid);
        final bUnseen = !b.isAllSeenBy(_currentUid);
        if (aUnseen && !bUnseen) return -1;
        if (!aUnseen && bUnseen) return 1;
        return b.latest.createdAt.compareTo(a.latest.createdAt);
      });
  }
}
