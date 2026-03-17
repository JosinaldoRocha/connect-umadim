import 'package:connect_umadim_app/app/core/supabase/supabase_init.dart';
import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/style/app_decoration.dart';
import '../../../user/providers/user_provider.dart';

/// Faixa compacta de aniversariantes — ocupa apenas uma linha
/// Clicável: abre o bottom sheet com a lista completa
class BirthdaysCompactWidget extends ConsumerWidget {
  const BirthdaysCompactWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersState = ref.watch(listUsersProvider);

    return usersState.maybeWhen(
      loadSuccess: (users) {
        final birthdays = _getBirthdaysThisWeek(users);
        if (birthdays.isEmpty) return const SizedBox.shrink();
        return _buildBar(context, birthdays);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildBar(BuildContext context, List<UserModel> birthdays) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final today = _getTodayBirthday(birthdays);

    return GestureDetector(
      onTap: () => _showBirthdaySheet(context, birthdays),
      child: Container(
        margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: isDark
              ? AppColor.darkSurfaceVariant
              : AppColor.lightSurfaceVariant,
          borderRadius: AppDecoration.radiusMd,
          border: Border.all(
            color:
                isDark ? AppColor.darkBorderStrong : AppColor.lightBorderStrong,
          ),
        ),
        child: Row(
          children: [
            // Ícone
            const Text('🎂', style: TextStyle(fontSize: 16)),
            const SizedBox(width: 10),

            // Mini avatares empilhados
            _buildAvatarStack(context, birthdays, isDark),
            const SizedBox(width: 10),

            // Texto informativo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    today != null
                        ? '${today.name.split(' ').first} faz aniversário hoje 🎉'
                        : '${birthdays.length} aniversariantes esta semana',
                    style: AppText.labelMedium(context).copyWith(
                      color: today != null
                          ? AppColor.success
                          : (isDark
                              ? AppColor.darkOnBackground
                              : AppColor.lightOnBackground),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (today != null && birthdays.length > 1)
                    Text(
                      '+${birthdays.length - 1} aniversariante${birthdays.length - 1 > 1 ? 's' : ''} esta semana',
                      style: AppText.labelSmall(context),
                    ),
                ],
              ),
            ),

            // Chevron
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: isDark
                  ? AppColor.darkOnSurfaceMuted
                  : AppColor.lightOnSurfaceMuted,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarStack(
    BuildContext context,
    List<UserModel> birthdays,
    bool isDark,
  ) {
    final visible = birthdays.take(4).toList();
    final bgColor = isDark ? AppColor.darkBackground : AppColor.lightBackground;

    return SizedBox(
      width: visible.length * 18.0 + 8,
      height: 28,
      child: Stack(
        children: visible.asMap().entries.map((entry) {
          final i = entry.key;
          final user = entry.value;
          final isToday = _isBirthdayToday(user);

          return Positioned(
            left: i * 18.0,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColor.wine700, AppColor.orange600],
                ),
                border: Border.all(
                  color: isToday ? AppColor.success : bgColor,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: user.photoUrl != null &&
                        user.photoUrl!.isNotEmpty &&
                        isSupabaseImageUrlValid(user.photoUrl)
                    ? Image.network(
                        user.photoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _avatarFallback(user),
                      )
                    : _avatarFallback(user),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _avatarFallback(UserModel user) {
    return Center(
      child: Text(
        user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
        style: const TextStyle(
          color: AppColor.light50,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  void _showBirthdaySheet(BuildContext context, List<UserModel> birthdays) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(
            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColor.darkBorderStrong
                      : AppColor.lightBorderStrong,
                  borderRadius: AppDecoration.radiusFull,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                const Text('🎂', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                Text(
                  'Aniversariantes da semana',
                  style: AppText.headlineSmall(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            ...birthdays
                .map((user) => _buildBirthdayItem(context, user, isDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildBirthdayItem(BuildContext context, UserModel user, bool isDark) {
    final isToday = _isBirthdayToday(user);
    final dateLabel = _formatDate(user.birthDate!);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColor.wine700, AppColor.orange600],
              ),
              border: Border.all(
                color: isToday ? AppColor.success : Colors.transparent,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: user.photoUrl != null &&
                      user.photoUrl!.isNotEmpty &&
                      isSupabaseImageUrlValid(user.photoUrl)
                  ? Image.network(user.photoUrl!, fit: BoxFit.cover)
                  : Center(
                      child: Text(
                        user.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: AppColor.light50,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),

          // Nome e congregação
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: AppText.username(context)),
                Text(
                  user.congregation,
                  style: AppText.labelSmall(context),
                ),
              ],
            ),
          ),

          // Data
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isToday
                  ? AppColor.success.withOpacity(0.15)
                  : (isDark
                      ? AppColor.darkSurfaceVariant
                      : AppColor.lightSurfaceVariant),
              borderRadius: AppDecoration.radiusFull,
              border: Border.all(
                color: isToday
                    ? AppColor.success.withOpacity(0.3)
                    : (isDark ? AppColor.darkBorder : AppColor.lightBorder),
              ),
            ),
            child: Text(
              dateLabel,
              style: AppText.labelSmall(context).copyWith(
                color: isToday
                    ? AppColor.success
                    : (isDark
                        ? AppColor.darkOnSurface
                        : AppColor.lightOnSurface),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────

  List<UserModel> _getBirthdaysThisWeek(List<UserModel> users) {
    final now = DateTime.now();
    return users.where((u) {
      if (u.birthDate == null) return false;
      final bd = u.birthDate!;
      for (int i = -1; i <= 5; i++) {
        final day = now.add(Duration(days: i));
        if (bd.day == day.day && bd.month == day.month) return true;
      }
      return false;
    }).toList()
      ..sort((a, b) {
        final now = DateTime.now();
        int diffA = _dayDiff(a.birthDate!, now);
        int diffB = _dayDiff(b.birthDate!, now);
        return diffA.compareTo(diffB);
      });
  }

  int _dayDiff(DateTime bd, DateTime now) {
    for (int i = -1; i <= 5; i++) {
      final day = now.add(Duration(days: i));
      if (bd.day == day.day && bd.month == day.month) return i;
    }
    return 99;
  }

  UserModel? _getTodayBirthday(List<UserModel> birthdays) {
    return birthdays.cast<UserModel?>().firstWhere(
          (u) => _isBirthdayToday(u!),
          orElse: () => null,
        );
  }

  bool _isBirthdayToday(UserModel user) {
    if (user.birthDate == null) return false;
    final now = DateTime.now();
    return user.birthDate!.day == now.day && user.birthDate!.month == now.month;
  }

  String _formatDate(DateTime bd) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    final tomorrow = now.add(const Duration(days: 1));

    if (bd.day == now.day && bd.month == now.month) return 'Hoje 🎉';
    if (bd.day == yesterday.day && bd.month == yesterday.month) return 'Ontem';
    if (bd.day == tomorrow.day && bd.month == tomorrow.month) return 'Amanhã';

    const days = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    for (int i = 2; i <= 5; i++) {
      final day = now.add(Duration(days: i));
      if (bd.day == day.day && bd.month == day.month) {
        return days[day.weekday % 7];
      }
    }
    return '${bd.day}/${bd.month}';
  }
}
