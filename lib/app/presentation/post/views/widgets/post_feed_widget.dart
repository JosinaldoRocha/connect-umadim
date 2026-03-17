import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_umadim_app/app/core/supabase/supabase_init.dart';
import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/enums/post_type_enum.dart';
import 'package:connect_umadim_app/app/data/models/post_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/style/app_decoration.dart';
import '../../provider/post_provider.dart';

// ── Feed principal ────────────────────────────────────────────

class PostFeedWidget extends ConsumerWidget {
  const PostFeedWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(feedProvider);

    return feedAsync.when(
      loading: () => _buildShimmer(context),
      error: (e, _) => _buildError(context),
      data: (posts) {
        if (posts.isEmpty) return _buildEmpty(context);
        return Column(
          children: posts.map((p) => PostCardWidget(post: p)).toList(),
        );
      },
    );
  }

  Widget _buildShimmer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: List.generate(
        3,
        (_) => Shimmer.fromColors(
          baseColor: isDark
              ? AppColor.darkSurfaceVariant
              : AppColor.lightSurfaceContainer,
          highlightColor: isDark ? AppColor.darkSurface : AppColor.lightSurface,
          child: Container(
            margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            height: 200,
            decoration: BoxDecoration(
              color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
              borderRadius: AppDecoration.radiusLg,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Erro ao carregar o feed.\nTente novamente.',
          style: AppText.bodySmall(context),
          textAlign: TextAlign.center,
        ),
      );

  Widget _buildEmpty(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Text('🌟', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text(
              'Nenhuma publicação ainda.\nSeja o primeiro a postar!',
              style: AppText.bodySmall(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
}

// ── Card de post ──────────────────────────────────────────────

class PostCardWidget extends ConsumerStatefulWidget {
  final PostModel post;
  const PostCardWidget({super.key, required this.post});

  @override
  ConsumerState<PostCardWidget> createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends ConsumerState<PostCardWidget> {
  late bool _liked;
  late int _likeCount;
  late bool _confirmed;
  bool _isExpanded = false;

  String get _uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    _liked = widget.post.isLikedBy(_uid);
    _likeCount = widget.post.likeIds.length;
    _confirmed = widget.post.hasConfirmedPresence(_uid);
  }

  void _toggleLike() {
    setState(() {
      _liked = !_liked;
      _likeCount += _liked ? 1 : -1;
    });
    ref.read(toggleLikeProvider(widget.post.id));
  }

  void _togglePresence() {
    setState(() => _confirmed = !_confirmed);
    ref.read(togglePresenceProvider(widget.post.id));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final post = widget.post;

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: AppDecoration.radiusLg,
        border: Border.all(
          color: post.isPinned
              ? AppColor.amber500.withOpacity(0.35)
              : (isDark ? AppColor.darkBorder : AppColor.lightBorder),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (post.isPinned) _buildPinnedBanner(context),
          _buildHeader(context, isDark),
          if (post.hasMedia &&
              post.isImage &&
              post.mediaUrl != null &&
              isSupabaseImageUrlValid(post.mediaUrl))
            _buildImage(post.mediaUrl!),
          if (post.hasMedia &&
              post.isVideo &&
              post.mediaUrl != null &&
              isSupabaseImageUrlValid(post.mediaUrl))
            _buildVideoThumb(context),
          _buildContent(context, isDark),
          if (post.type == PostType.poll) _PollWidget(post: post, uid: _uid),
          _buildActions(context, isDark),
        ],
      ),
    );
  }

  Widget _buildPinnedBanner(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: AppColor.amber500.withOpacity(0.1),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Row(
          children: [
            const Icon(Icons.push_pin_rounded,
                size: 13, color: AppColor.amber400),
            const SizedBox(width: 5),
            Text(
              'Publicação fixada',
              style: AppText.labelSmall(context).copyWith(
                  color: AppColor.amber400, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );

  Widget _buildHeader(BuildContext context, bool isDark) {
    final post = widget.post;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: AppDecoration.radiusMd,
              gradient: const LinearGradient(
                  colors: [AppColor.wine700, AppColor.orange600]),
            ),
            child: post.authorPhotoUrl != null &&
                    post.authorPhotoUrl!.isNotEmpty &&
                    isSupabaseImageUrlValid(post.authorPhotoUrl)
                ? ClipRRect(
                    borderRadius: AppDecoration.radiusMd,
                    child: CachedNetworkImage(
                        imageUrl: post.authorPhotoUrl!, fit: BoxFit.cover),
                  )
                : Center(
                    child: Text(
                      post.authorName.isNotEmpty
                          ? post.authorName[0].toUpperCase()
                          : '?',
                      style: AppText.labelLarge(context)
                          .copyWith(color: AppColor.light50),
                    ),
                  ),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.authorName, style: AppText.username(context)),
                Text(
                  '${post.congregation} · ${_timeAgo(post.createdAt)}',
                  style: AppText.labelSmall(context),
                ),
              ],
            ),
          ),

          _TypeBadge(type: post.type),
          const SizedBox(width: 6),

          if (post.authorId == _uid)
            GestureDetector(
              onTap: () => _showOptions(context),
              child: Icon(Icons.more_vert_rounded,
                  size: 18,
                  color: isDark
                      ? AppColor.darkOnSurfaceMuted
                      : AppColor.lightOnSurfaceMuted),
            ),
        ],
      ),
    );
  }

  Widget _buildImage(String url) => CachedNetworkImage(
        imageUrl: url,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        placeholder: (_, __) => Container(
          height: 200,
          color: AppColor.darkSurfaceVariant,
          child: const Center(
            child: SizedBox(
              height: 8,
              width: 40,
              child: LoadingIndicator(
                  indicatorType: Indicator.ballPulse,
                  colors: [AppColor.orange500]),
            ),
          ),
        ),
        errorWidget: (_, __, ___) => Container(
          height: 200,
          color: AppColor.darkSurfaceVariant,
          child: const Center(child: Icon(Icons.broken_image_outlined)),
        ),
      );

  Widget _buildVideoThumb(BuildContext context) => Stack(
        alignment: Alignment.center,
        children: [
          CachedNetworkImage(
            imageUrl: widget.post.mediaUrl!,
            errorWidget: (_, __, ___) => Container(
              height: 200,
              color: AppColor.darkSurfaceVariant,
              child: const Center(child: Icon(Icons.broken_image_outlined)),
            ),
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.dark900.withOpacity(0.7),
            ),
            child: const Icon(Icons.play_arrow_rounded,
                color: AppColor.lightSurface, size: 30),
          ),
        ],
      );

  Widget _buildContent(BuildContext context, bool isDark) {
    final text = widget.post.content;
    final isLong = text.length > 120;
    final display =
        isLong && !_isExpanded ? '${text.substring(0, 120)}...' : text;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(display,
              style: AppText.bodySmall(context).copyWith(
                color: isDark ? AppColor.light200 : AppColor.lightOnSurface,
                height: 1.55,
                fontSize: 13,
              )),
          if (isLong)
            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Text(
                _isExpanded ? 'Ver menos' : 'Ver mais',
                style: AppText.labelSmall(context)
                    .copyWith(color: AppColor.orange400),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context, bool isDark) {
    final isEvent = widget.post.type == PostType.event ||
        widget.post.type == PostType.notice;

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
      child: Row(
        children: [
          _ActionBtn(
            icon:
                _liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            label: _likeCount > 0 ? '$_likeCount' : '',
            active: _liked,
            activeColor: AppColor.orange400,
            onTap: _toggleLike,
          ),
          _ActionBtn(
            icon: Icons.chat_bubble_outline_rounded,
            label: widget.post.commentCount > 0
                ? '${widget.post.commentCount}'
                : '',
            onTap: () => Navigator.pushNamed(context, '/post/comments',
                arguments: widget.post.id),
          ),
          if (isEvent)
            _ActionBtn(
              icon: _confirmed
                  ? Icons.check_circle_rounded
                  : Icons.check_circle_outline_rounded,
              label: _confirmed ? 'Confirmado' : 'Confirmar',
              active: _confirmed,
              activeColor: AppColor.success,
              onTap: _togglePresence,
            )
          else
            _ActionBtn(
              icon: Icons.share_outlined,
              label: 'Compartilhar',
              onTap: () {},
            ),
        ],
      ),
    );
  }

  void _showOptions(BuildContext context) {
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
              title: Text('Excluir publicação',
                  style: AppText.bodyMedium(context)
                      .copyWith(color: AppColor.error)),
              onTap: () {
                Navigator.pop(context);
                ref.read(deletePostProvider(widget.post.id));
              },
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'agora';
    if (diff.inMinutes < 60) return 'há ${diff.inMinutes}min';
    if (diff.inHours < 24) return 'há ${diff.inHours}h';
    if (diff.inDays == 1) return 'ontem';
    if (diff.inDays < 7) return 'há ${diff.inDays} dias';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

// ── Widget de enquete ─────────────────────────────────────────

class _PollWidget extends ConsumerWidget {
  final PostModel post;
  final String uid;
  const _PollWidget({required this.post, required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final total = post.totalVotes;
    final hasVoted = post.pollOptions.any((o) => o.voterIds.contains(uid));
    final ended = post.hasPollEnded;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...post.pollOptions.map((opt) {
            final pct = opt.votePercentage(total);
            final isMyVote = opt.voterIds.contains(uid);

            return GestureDetector(
              onTap: (hasVoted || ended)
                  ? null
                  : () => ref.read(votePollProvider(
                      VotePollArgs(postId: post.id, optionId: opt.id))),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: AppDecoration.radiusMd,
                  border: Border.all(
                    color: isMyVote
                        ? AppColor.orange500
                        : (isDark ? AppColor.darkBorder : AppColor.lightBorder),
                  ),
                ),
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  children: [
                    if (hasVoted || ended)
                      FractionallySizedBox(
                        widthFactor: pct / 100,
                        child: Container(
                          height: 44,
                          color: isMyVote
                              ? AppColor.orange500.withOpacity(0.18)
                              : (isDark
                                  ? AppColor.darkSurfaceVariant
                                  : AppColor.lightSurfaceVariant),
                        ),
                      ),
                    SizedBox(
                      height: 44,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            if (isMyVote)
                              const Padding(
                                padding: EdgeInsets.only(right: 6),
                                child: Icon(Icons.check_rounded,
                                    size: 14, color: AppColor.orange500),
                              ),
                            Expanded(
                              child: Text(opt.text,
                                  style: AppText.bodySmall(context).copyWith(
                                    fontWeight: isMyVote
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    fontSize: 13,
                                  )),
                            ),
                            if (hasVoted || ended)
                              Text(
                                '${pct.toStringAsFixed(0)}%',
                                style: AppText.labelSmall(context).copyWith(
                                  color: isMyVote ? AppColor.orange500 : null,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          Text(
            ended
                ? 'Enquete encerrada · $total votos'
                : '$total voto${total != 1 ? 's' : ''}',
            style: AppText.labelSmall(context),
          ),
        ],
      ),
    );
  }
}

// ── Badge de tipo ─────────────────────────────────────────────

class _TypeBadge extends StatelessWidget {
  final PostType type;
  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    if (type == PostType.message) return const SizedBox.shrink();

    final cfg = switch (type) {
      PostType.event => (
          bg: AppColor.amber500.withOpacity(0.15),
          fg: AppColor.amber300,
          border: AppColor.amber500.withOpacity(0.25)
        ),
      PostType.notice => (
          bg: AppColor.wine700.withOpacity(0.5),
          fg: const Color(0xFFF5A0A8),
          border: AppColor.wine600.withOpacity(0.4)
        ),
      PostType.poll => (
          bg: AppColor.info.withOpacity(0.12),
          fg: AppColor.info,
          border: AppColor.info.withOpacity(0.2)
        ),
      PostType.video => (
          bg: AppColor.orange500.withOpacity(0.12),
          fg: AppColor.orange300,
          border: AppColor.orange500.withOpacity(0.2)
        ),
      _ => (
          bg: AppColor.orange500.withOpacity(0.10),
          fg: AppColor.orange300,
          border: AppColor.orange500.withOpacity(0.15)
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: cfg.bg,
        borderRadius: AppDecoration.radiusFull,
        border: Border.all(color: cfg.border),
      ),
      child: Text(
        type.label,
        style:
            TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: cfg.fg),
      ),
    );
  }
}

// ── Botão de ação ─────────────────────────────────────────────

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final Color? activeColor;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = active && activeColor != null
        ? activeColor!
        : (isDark ? AppColor.darkOnSurfaceMuted : AppColor.lightOnSurfaceMuted);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 17, color: color),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(label,
                  style: AppText.labelSmall(context)
                      .copyWith(color: color, fontWeight: FontWeight.w500)),
            ],
          ],
        ),
      ),
    );
  }
}
