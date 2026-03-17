import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:flutter/material.dart';

class UmadimBoardItemWidget extends StatelessWidget {
  const UmadimBoardItemWidget({
    super.key,
    required this.user,
    this.isPresident = false,
  });

  final UserModel user;

  /// Primeiro da lista (Presidente) recebe anel laranja dourado
  final bool isPresident;

  // Preservado do original
  String getFirstAndInitial(String fullName) {
    final names = fullName.split(' ');
    if (names.length >= 2) return '${names[0]} ${names[1][0]}.';
    return names[0];
  }

  String getInitials(String fullName) {
    final names = fullName.split(' ');
    String initials = names.isNotEmpty ? names.first[0] : '';
    if (names.length > 1) initials += names[1][0];
    return initials.toUpperCase();
  }

  bool _isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    return url.startsWith('http://') || url.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 72,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ── Anel + Avatar ─────────────────────────────────
          Container(
            width: 54,
            height: 54,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isPresident
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColor.orange500, AppColor.amber400],
                    )
                  : const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColor.wine700, AppColor.wine600],
                    ),
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
                child: _isValidUrl(user.photoUrl)
                    ? CachedNetworkImage(
                        imageUrl: user.photoUrl!,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) =>
                            _avatarFallback(context, isDark),
                      )
                    : _avatarFallback(context, isDark),
              ),
            ),
          ),

          const SizedBox(height: 5),

          // ── Função ────────────────────────────────────────
          Text(
            user.umadimFunction.title.text,
            style: AppText.labelSmall(context).copyWith(
              color: isPresident
                  ? AppColor.orange300
                  : (isDark
                      ? AppColor.darkOnSurfaceMuted
                      : AppColor.lightOnSurfaceMuted),
              fontSize: 9,
              letterSpacing: 0.04,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 2),

          // ── Nome abreviado ────────────────────────────────
          Text(
            getFirstAndInitial(user.name),
            style: AppText.labelSmall(context).copyWith(
              color: isDark
                  ? AppColor.darkOnBackground
                  : AppColor.lightOnBackground,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _avatarFallback(BuildContext context, bool isDark) {
    return Container(
      color:
          isDark ? AppColor.darkSurfaceVariant : AppColor.lightSurfaceContainer,
      child: Center(
        child: Text(
          getInitials(user.name),
          style: TextStyle(
            fontFamily: 'Syne',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColor.light50 : AppColor.wine800,
          ),
        ),
      ),
    );
  }
}
