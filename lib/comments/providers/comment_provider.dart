import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/core/helpers/errors/common_errors.dart';
import '../../app/data/data_source/comment_data_source.dart';
import '../../app/data/models/comment_model.dart';

// ── Datasource ────────────────────────────────────────────

final commentDataSourceProvider = Provider<CommentDataSource>(
  (_) => CommentDataSource(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

// ── Stream de comentários por post ────────────────────────

final commentsProvider =
    StreamProvider.family<List<CommentModel>, String>((ref, postId) {
  final ds = ref.watch(commentDataSourceProvider);
  return ds.watchComments(postId).map(
        (result) => result.fold(
          (err) => throw Exception(err.message),
          (comments) => comments,
        ),
      );
});

// ── Adicionar comentário ──────────────────────────────────

class AddCommentArgs {
  final String postId;
  final String content;
  final String? replyToId;
  final String? replyToName;

  const AddCommentArgs({
    required this.postId,
    required this.content,
    this.replyToId,
    this.replyToName,
  });
}

final addCommentProvider =
    FutureProvider.family<void, AddCommentArgs>((ref, args) async {
  final ds = ref.read(commentDataSourceProvider);
  await ds.addComment(
    postId: args.postId,
    content: args.content,
    replyToId: args.replyToId,
    replyToName: args.replyToName,
  );
});

// ── Curtir comentário ─────────────────────────────────────

class ToggleCommentLikeArgs {
  final String postId;
  final String commentId;
  const ToggleCommentLikeArgs({required this.postId, required this.commentId});
}

final toggleCommentLikeProvider =
    FutureProvider.family<void, ToggleCommentLikeArgs>((ref, args) async {
  final ds = ref.read(commentDataSourceProvider);
  await ds.toggleLike(postId: args.postId, commentId: args.commentId);
});

// ── Deletar comentário ────────────────────────────────────

class DeleteCommentArgs {
  final String postId;
  final String commentId;
  const DeleteCommentArgs({required this.postId, required this.commentId});
}

final deleteCommentProvider =
    FutureProvider.family<void, DeleteCommentArgs>((ref, args) async {
  final ds = ref.read(commentDataSourceProvider);
  await ds.deleteComment(postId: args.postId, commentId: args.commentId);
});
