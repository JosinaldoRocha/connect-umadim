import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/style/app_decoration.dart';

class HomeAppBarWidget extends StatelessWidget {
  final UserModel user;
  const HomeAppBarWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Status bar clara/escura conforme tema
    SystemChrome.setSystemUIOverlayStyle(
      isDark
          ? SystemUiOverlayStyle.light
              .copyWith(statusBarColor: Colors.transparent)
          : SystemUiOverlayStyle.dark
              .copyWith(statusBarColor: Colors.transparent),
    );

    return Container(
      color: isDark ? AppColor.darkBackground : AppColor.lightBackground,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 10,
      ),
      child: Row(
        children: [
          // ── Logo + nome ─────────────────────────────────
          _buildLogo(context, isDark),

          const Spacer(),

          // ── Busca ────────────────────────────────────────
          _buildIconButton(
            context,
            isDark,
            icon: Icons.search_rounded,
            onTap: () => Navigator.pushNamed(context, '/search'),
          ),
          const SizedBox(width: 8),

          // ── Notificações ─────────────────────────────────
          _buildNotifButton(context, isDark),
        ],
      ),
    );
  }

  Widget _buildLogo(BuildContext context, bool isDark) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColor.wine800,
            borderRadius: AppDecoration.radiusMd,
            border: Border.all(
              color: AppColor.orange500.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: const Center(
            child: Text('🔥', style: TextStyle(fontSize: 18)),
          ),
        ),
        const SizedBox(width: 8),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Conecta ',
                style: AppText.headlineMedium(context),
              ),
              TextSpan(
                text: 'UMADIM',
                style: AppText.headlineMedium(context).copyWith(
                  color: AppColor.orange400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconButton(
    BuildContext context,
    bool isDark, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isDark
              ? AppColor.darkSurfaceVariant
              : AppColor.lightSurfaceVariant,
          borderRadius: AppDecoration.radiusMd,
          border: Border.all(
            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isDark ? AppColor.darkOnSurface : AppColor.lightOnSurface,
        ),
      ),
    );
  }

  Widget _buildNotifButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/notifications'),
      child: Stack(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColor.darkSurfaceVariant
                  : AppColor.lightSurfaceVariant,
              borderRadius: AppDecoration.radiusMd,
              border: Border.all(
                color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
              ),
            ),
            child: Icon(
              Icons.notifications_outlined,
              size: 18,
              color: isDark ? AppColor.darkOnSurface : AppColor.lightOnSurface,
            ),
          ),
          // Ponto de notificação
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColor.orange500,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? AppColor.darkBackground
                      : AppColor.lightBackground,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
