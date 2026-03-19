import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../../core/helpers/errors/common_errors.dart';
import '../models/comment_model.dart';

class CommentDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CommentDataSource({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> _commentsRef(String postId) =>
      _firestore.collection('posts').doc(postId).collection('comments');

  // ── Stream de comentários de um post ─────────────────────
  Stream<Either<CommonError, List<CommentModel>>> watchComments(String postId) {
    return _commentsRef(postId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snap) {
      try {
        final comments =
            snap.docs.map((d) => CommentModel.fromQuerySnapshot(d)).toList();
        return Right(comments);
      } catch (e) {
        return Left(const CommonError.undefined());
      }
    });
  }

  // ── Adicionar comentário ──────────────────────────────────
  Future<Either<CommonError, CommentModel>> addComment({
    required String postId,
    required String content,
    String? replyToId,
    String? replyToName,
  }) async {
    try {
      final id = const Uuid().v4();

      // Busca dados do autor
      final userDoc = await _firestore.collection('users').doc(_uid).get();
      final authorName = userDoc.data()?['name'] as String? ?? '';
      final authorPhotoUrl = userDoc.data()?['photoUrl'] as String?;

      final comment = CommentModel(
        id: id,
        postId: postId,
        authorId: _uid,
        authorName: authorName,
        authorPhotoUrl: authorPhotoUrl,
        content: content,
        likeIds: [],
        replyToId: replyToId,
        replyToName: replyToName,
        createdAt: DateTime.now(),
      );

      // Salva o comentário
      await _commentsRef(postId).doc(id).set(comment.toMap());

      // Incrementa contador no post
      await _firestore
          .collection('posts')
          .doc(postId)
          .update({'commentCount': FieldValue.increment(1)});

      return Right(comment);
    } catch (e) {
      return Left(const CommonError.undefined());
    }
  }

  // ── Curtir / descurtir comentário ─────────────────────────
  Future<Either<CommonError, Unit>> toggleLike({
    required String postId,
    required String commentId,
  }) async {
    try {
      final ref = _commentsRef(postId).doc(commentId);

      await _firestore.runTransaction((tx) async {
        final snap = await tx.get(ref);
        final likes = List<String>.from(snap['likeIds'] ?? []);
        if (likes.contains(_uid)) {
          likes.remove(_uid);
        } else {
          likes.add(_uid);
        }
        tx.update(ref, {'likeIds': likes});
      });

      return const Right(unit);
    } catch (e) {
      return Left(const CommonError.undefined());
    }
  }

  // ── Deletar comentário ────────────────────────────────────
  Future<Either<CommonError, Unit>> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    try {
      await _commentsRef(postId).doc(commentId).delete();

      // Decrementa contador no post
      await _firestore
          .collection('posts')
          .doc(postId)
          .update({'commentCount': FieldValue.increment(-1)});

      return const Right(unit);
    } catch (e) {
      return Left(const CommonError.undefined());
    }
  }
}
