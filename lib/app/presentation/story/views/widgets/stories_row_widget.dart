import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/models/story_model.dart';
import 'package:connect_umadim_app/app/core/supabase/supabase_init.dart';
import 'package:connect_umadim_app/app/presentation/story/provider/story_provider.dart';
import 'package:connect_umadim_app/app/presentation/story/views/pages/story_viewer_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class StoriesRowWidget extends ConsumerWidget {
  const StoriesRowWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesAsync = ref.watch(storiesProvider);
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    return SizedBox(
      height: 90,
      child: storiesAsync.when(
        loading: () => _buildShimmer(context),
        error: (_, __) => const SizedBox.shrink(),
        data: (groups) => ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          children: [
            // Botão de criar story
            _AddStoryButton(uid: uid),
            const SizedBox(width: 12),

            // Stories dos outros usuários
            ...groups.asMap().entries.map((entry) {
              final i = entry.key;
              final group = entry.value;
              final allSeen = group.isAllSeenBy(uid);
              return Padding(
                padding: EdgeInsets.only(right: i < groups.length - 1 ? 12 : 0),
                child: _StoryGroupItem(
                  groups: groups,
                  initialGroupIndex: i,
                  group: group,
                  isSeen: allSeen,
                  currentUid: uid,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      children: List.generate(
        5,
        (i) => Padding(
          padding: EdgeInsets.only(right: i < 4 ? 12 : 0),
          child: Shimmer.fromColors(
            baseColor: isDark
                ? AppColor.darkSurfaceVariant
                : AppColor.lightSurfaceContainer,
            highlightColor:
                isDark ? AppColor.darkSurface : AppColor.lightSurface,
            child: Column(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Container(width: 44, height: 8, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Botão "Seu story" ─────────────────────────────────────────

class _AddStoryButton extends StatelessWidget {
  final String uid;
  const _AddStoryButton({required this.uid});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () =>
          Navigator.of(context, rootNavigator: true).pushNamed('/story/create'),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? AppColor.darkSurfaceVariant
                      : AppColor.lightSurfaceVariant,
                  border: Border.all(
                    color: isDark
                        ? AppColor.darkBorderStrong
                        : AppColor.lightBorderStrong,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.add_rounded,
                  size: 26,
                  color:
                      isDark ? AppColor.darkOnSurface : AppColor.lightOnSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            'Seu story',
            style: AppText.labelSmall(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ── Item de grupo de stories ──────────────────────────────────

class _StoryGroupItem extends ConsumerWidget {
  final List<StoryGroup> groups;
  final int initialGroupIndex;
  final StoryGroup group;
  final bool isSeen;
  final String currentUid;

  const _StoryGroupItem({
    required this.groups,
    required this.initialGroupIndex,
    required this.group,
    required this.isSeen,
    required this.currentUid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        // Marca o primeiro story não visto como visto
        final unseen =
            group.stories.where((s) => !s.isViewedBy(currentUid)).toList();
        if (unseen.isNotEmpty) {
          ref.read(markStoryViewedProvider(unseen.first.id));
        }
        Navigator.of(context, rootNavigator: true).pushNamed(
          '/story/viewer',
          arguments: StoryViewerArgs(
            groups: groups,
            initialGroupIndex: initialGroupIndex,
            currentUid: currentUid,
          ),
        );
      },
      child: Column(
        children: [
          // Anel gradiente ou cinza
          Container(
            width: 54,
            height: 54,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isSeen
                  ? null
                  : const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColor.orange500, AppColor.amber400],
                    ),
              color: isSeen
                  ? (isDark
                      ? AppColor.darkSurfaceVariant
                      : AppColor.lightSurfaceContainer)
                  : null,
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? AppColor.darkBackground
                      : AppColor.lightBackground,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: group.authorPhotoUrl != null &&
                        group.authorPhotoUrl!.isNotEmpty &&
                        isSupabaseImageUrlValid(group.authorPhotoUrl)
                    ? CachedNetworkImage(
                        imageUrl: group.authorPhotoUrl!,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                        errorWidget: (_, __, ___) =>
                            _avatarFallback(group.authorName),
                      )
                    : _avatarFallback(group.authorName),
              ),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: 56,
            child: Text(
              group.authorName.split(' ').first,
              style: AppText.labelSmall(context).copyWith(
                color: isSeen
                    ? (isDark
                        ? AppColor.darkOnSurfaceMuted
                        : AppColor.lightOnSurfaceMuted)
                    : (isDark
                        ? AppColor.darkOnBackground
                        : AppColor.lightOnBackground),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarFallback(String name) {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColor.wine700, AppColor.orange600],
        ),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(
            color: AppColor.light50,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
