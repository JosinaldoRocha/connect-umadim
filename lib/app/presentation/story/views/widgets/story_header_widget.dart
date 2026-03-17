import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_umadim_app/app/core/supabase/supabase_init.dart';
import 'package:connect_umadim_app/app/data/models/story_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StoryHeaderWidget extends StatelessWidget {
  final StoryGroup group;
  final StoryModel story;
  final int groupsCount;
  final int currentGroupIndex;
  final VoidCallback onClose;

  const StoryHeaderWidget({
    super.key,
    required this.group,
    required this.story,
    required this.groupsCount,
    required this.currentGroupIndex,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 24, 14, 0),
        child: Row(
          children: [
            // Avatar
            _buildAvatar(),
            const SizedBox(width: 10),

            // Nome e info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.authorName,
                    style: const TextStyle(
                      fontFamily: 'Syne',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${group.congregation} · ${_timeAgo(story.createdAt)}',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            // Indicador de grupos
            if (groupsCount > 1) ...[
              ...List.generate(
                  groupsCount,
                  (i) => Container(
                        width: i == currentGroupIndex ? 14 : 5,
                        height: 5,
                        margin: const EdgeInsets.only(right: 3),
                        decoration: BoxDecoration(
                          color: i == currentGroupIndex
                              ? Colors.white
                              : Colors.white.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      )),
              const SizedBox(width: 8),
            ],

            // Fechar
            GestureDetector(
              onTap: onClose,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.35),
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 2),
      ),
      child: ClipOval(
        child: group.authorPhotoUrl != null &&
                group.authorPhotoUrl!.isNotEmpty &&
                isSupabaseImageUrlValid(group.authorPhotoUrl)
            ? CachedNetworkImage(
                imageUrl: group.authorPhotoUrl!,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => _avatarFallback(),
              )
            : _avatarFallback(),
      ),
    );
  }

  Widget _avatarFallback() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6B1219), Color(0xFFE8621A)],
        ),
      ),
      child: Center(
        child: Text(
          group.authorName.isNotEmpty ? group.authorName[0].toUpperCase() : '?',
          style: const TextStyle(
            fontFamily: 'Syne',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'agora';
    if (diff.inMinutes < 60) return 'há ${diff.inMinutes}min';
    if (diff.inHours < 24) return 'há ${diff.inHours}h';
    return DateFormat('dd/MM').format(dt);
  }
}
