import 'package:connect_umadim_app/app/core/auth/auth_permission_service.dart';
import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/models/comment_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../app/core/style/app_decoration.dart';
import '../providers/comment_provider.dart';
import 'comment_input_widget.dart';
import 'comment_item_widget.dart';

/// Abre os comentários de um post como bottom sheet
/// Uso:
/// ```dart
/// showModalBottomSheet(
///   context: context,
///   isScrollControlled: true,
///   backgroundColor: Colors.transparent,
///   builder: (_) => CommentsSheetWidget(postId: post.id, postAuthorId: post.authorId),
/// );
/// ```
class CommentsSheetWidget extends ConsumerStatefulWidget {
  final String postId;
  final String postAuthorId;

  const CommentsSheetWidget({
    super.key,
    required this.postId,
    required this.postAuthorId,
  });

  @override
  ConsumerState<CommentsSheetWidget> createState() =>
      _CommentsSheetWidgetState();
}

class _CommentsSheetWidgetState extends ConsumerState<CommentsSheetWidget> {
  CommentModel? _replyingTo;

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  void _setReply(CommentModel comment) {
    setState(() => _replyingTo = comment);
  }

  void _clearReply() {
    setState(() => _replyingTo = null);
  }

  Future<void> _sendComment(String content) async {
    if (content.trim().isEmpty) return;

    await ref.read(addCommentProvider(AddCommentArgs(
      postId: widget.postId,
      content: content.trim(),
      replyToId: _replyingTo?.id,
      replyToName: _replyingTo?.authorName,
    )).future);

    _clearReply();
  }

  Future<void> _deleteComment(String commentId) async {
    await ref.read(deleteCommentProvider(DeleteCommentArgs(
      postId: widget.postId,
      commentId: commentId,
    )).future);
  }

  Future<void> _toggleLike(String commentId) async {
    await ref.read(toggleCommentLikeProvider(ToggleCommentLikeArgs(
      postId: widget.postId,
      commentId: commentId,
    )).future);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isLeader = ref.watch(isLeaderProvider);
    final commentsAsync = ref.watch(commentsProvider(widget.postId));

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkBackground : AppColor.lightBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(
          top: BorderSide(
            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          ),
        ),
      ),
      child: Column(
        children: [
          // ── Handle ──────────────────────────────────────
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColor.darkBorderStrong
                    : AppColor.lightBorderStrong,
                borderRadius: AppDecoration.radiusFull,
              ),
            ),
          ),

          // ── Header ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Text('Comentários', style: AppText.headlineSmall(context)),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? AppColor.darkSurfaceVariant
                          : AppColor.lightSurfaceVariant,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: isDark
                          ? AppColor.darkOnSurfaceMuted
                          : AppColor.lightOnSurfaceMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(
            height: 1,
            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          ),

          // ── Lista de comentários ─────────────────────────
          Expanded(
            child: commentsAsync.when(
              loading: () => _buildShimmer(context, isDark),
              error: (_, __) => Center(
                child: Text(
                  'Erro ao carregar comentários.',
                  style: AppText.bodySmall(context),
                ),
              ),
              data: (comments) {
                if (comments.isEmpty) return _buildEmpty(context);

                // Separa comentários raiz dos replies
                final roots = comments.where((c) => !c.isReply).toList();
                final replies = comments.where((c) => c.isReply).toList();

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  itemCount: roots.length,
                  itemBuilder: (_, i) {
                    final comment = roots[i];
                    final commentReplies = replies
                        .where((r) => r.replyToId == comment.id)
                        .toList();

                    final canDelete = comment.authorId == _uid ||
                        widget.postAuthorId == _uid ||
                        isLeader;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Comentário raiz
                        CommentItemWidget(
                          comment: comment,
                          currentUid: _uid,
                          canDelete: canDelete,
                          onLike: () => _toggleLike(comment.id),
                          onReply: () => _setReply(comment),
                          onDelete: () => _deleteComment(comment.id),
                        ),

                        // Replies indentados
                        if (commentReplies.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 43),
                            child: Column(
                              children: commentReplies.map((reply) {
                                final canDeleteReply = reply.authorId == _uid ||
                                    widget.postAuthorId == _uid ||
                                    isLeader;
                                return CommentItemWidget(
                                  comment: reply,
                                  currentUid: _uid,
                                  canDelete: canDeleteReply,
                                  isReply: true,
                                  onLike: () => _toggleLike(reply.id),
                                  onReply: () => _setReply(comment),
                                  onDelete: () => _deleteComment(reply.id),
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          // ── Contexto de reply ────────────────────────────
          if (_replyingTo != null) _buildReplyContext(context, isDark),

          // ── Input ────────────────────────────────────────
          CommentInputWidget(
            onSend: _sendComment,
            replyingTo: _replyingTo,
            onClearReply: _clearReply,
          ),
        ],
      ),
    );
  }

  Widget _buildReplyContext(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: AppColor.orange500.withOpacity(0.08),
      child: Row(
        children: [
          const Icon(Icons.reply_rounded, size: 14, color: AppColor.orange400),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              'Respondendo a @${_replyingTo!.authorName}',
              style: AppText.labelSmall(context)
                  .copyWith(color: AppColor.orange300),
            ),
          ),
          GestureDetector(
            onTap: _clearReply,
            child: const Icon(Icons.close_rounded,
                size: 16, color: AppColor.darkOnSurfaceMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('💬', style: TextStyle(fontSize: 36)),
          const SizedBox(height: 12),
          Text(
            'Nenhum comentário ainda.\nSeja o primeiro a comentar!',
            style: AppText.bodySmall(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer(BuildContext context, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: isDark
            ? AppColor.darkSurfaceVariant
            : AppColor.lightSurfaceContainer,
        highlightColor: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: 60,
          decoration: BoxDecoration(
            color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
            borderRadius: AppDecoration.radiusMd,
          ),
        ),
      ),
    );
  }
}

/// Helper para abrir o sheet facilmente
void showCommentsSheet(
  BuildContext context, {
  required String postId,
  required String postAuthorId,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => CommentsSheetWidget(
      postId: postId,
      postAuthorId: postAuthorId,
    ),
  );
}
