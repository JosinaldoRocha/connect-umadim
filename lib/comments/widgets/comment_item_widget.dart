import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/models/comment_model.dart';
import 'package:flutter/material.dart';

import '../../app/core/style/app_decoration.dart';

class CommentItemWidget extends StatefulWidget {
  final CommentModel comment;
  final String currentUid;
  final bool canDelete;
  final bool isReply;
  final VoidCallback onLike;
  final VoidCallback onReply;
  final VoidCallback onDelete;

  const CommentItemWidget({
    super.key,
    required this.comment,
    required this.currentUid,
    required this.canDelete,
    required this.onLike,
    required this.onReply,
    required this.onDelete,
    this.isReply = false,
  });

  @override
  State<CommentItemWidget> createState() => _CommentItemWidgetState();
}

class _CommentItemWidgetState extends State<CommentItemWidget> {
  late bool _liked;
  late int _likeCount;

  @override
  void initState() {
    super.initState();
    _liked = widget.comment.isLikedBy(widget.currentUid);
    _likeCount = widget.comment.likeIds.length;
  }

  void _handleLike() {
    setState(() {
      _liked = !_liked;
      _likeCount += _liked ? 1 : -1;
    });
    widget.onLike();
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'agora';
    if (diff.inMinutes < 60) return 'há ${diff.inMinutes}min';
    if (diff.inHours < 24) return 'há ${diff.inHours}h';
    if (diff.inDays == 1) return 'ontem';
    return 'há ${diff.inDays} dias';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final avatarSize = widget.isReply ? 28.0 : 36.0;
    final avatarRadius =
        widget.isReply ? AppDecoration.radiusSm : AppDecoration.radiusMd;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Avatar ──────────────────────────────────────
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              borderRadius: avatarRadius,
              gradient: const LinearGradient(
                colors: [AppColor.wine700, AppColor.orange600],
              ),
            ),
            child: widget.comment.authorPhotoUrl != null
                ? ClipRRect(
                    borderRadius: avatarRadius,
                    child: CachedNetworkImage(
                      imageUrl: widget.comment.authorPhotoUrl!,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) =>
                          _avatarFallback(widget.comment.authorName),
                    ),
                  )
                : _avatarFallback(widget.comment.authorName),
          ),
          const SizedBox(width: 9),

          // ── Conteúdo ─────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nome + tempo
                Row(
                  children: [
                    Text(
                      widget.comment.authorName,
                      style: AppText.username(context).copyWith(
                        fontSize: widget.isReply ? 11 : 12,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _timeAgo(widget.comment.createdAt),
                      style: AppText.labelSmall(context).copyWith(fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 3),

                // Mention (se for reply)
                if (widget.comment.isReply &&
                    widget.comment.replyToName != null) ...[
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '@${widget.comment.replyToName} ',
                          style: AppText.bodySmall(context).copyWith(
                            color: AppColor.orange400,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        TextSpan(
                          text: widget.comment.content,
                          style: AppText.bodySmall(context).copyWith(
                            color: isDark
                                ? AppColor.light200
                                : AppColor.lightOnSurface,
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else
                  Text(
                    widget.comment.content,
                    style: AppText.bodySmall(context).copyWith(
                      color:
                          isDark ? AppColor.light200 : AppColor.lightOnSurface,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),

                const SizedBox(height: 6),

                // Ações
                Row(
                  children: [
                    // Curtir
                    GestureDetector(
                      onTap: _handleLike,
                      child: Row(
                        children: [
                          Text(
                            _liked ? '❤️' : '🤍',
                            style: const TextStyle(fontSize: 13),
                          ),
                          if (_likeCount > 0) ...[
                            const SizedBox(width: 3),
                            Text(
                              '$_likeCount',
                              style: AppText.labelSmall(context).copyWith(
                                color: _liked
                                    ? AppColor.orange400
                                    : (isDark
                                        ? AppColor.darkOnSurfaceMuted
                                        : AppColor.lightOnSurfaceMuted),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Responder
                    GestureDetector(
                      onTap: widget.onReply,
                      child: Text(
                        'Responder',
                        style: AppText.labelSmall(context).copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // Deletar (condicional)
                    if (widget.canDelete) ...[
                      const Spacer(),
                      GestureDetector(
                        onTap: () => _confirmDelete(context),
                        child: Text(
                          'Excluir',
                          style: AppText.labelSmall(context).copyWith(
                            color: AppColor.error.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        decoration: BoxDecoration(
          color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColor.darkBorderStrong
                    : AppColor.lightBorderStrong,
                borderRadius: AppDecoration.radiusFull,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.delete_outline_rounded,
                  color: AppColor.error),
              title: Text(
                'Excluir comentário',
                style:
                    AppText.bodyMedium(context).copyWith(color: AppColor.error),
              ),
              onTap: () {
                Navigator.pop(context);
                widget.onDelete();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.cancel_outlined,
                color:
                    isDark ? AppColor.darkOnSurface : AppColor.lightOnSurface,
              ),
              title: Text('Cancelar', style: AppText.bodyMedium(context)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatarFallback(String name) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(
          color: AppColor.light50,
          fontSize: widget.isReply ? 10 : 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
