import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:connect_umadim_app/app/presentation/home/views/widgets/users_list_widget.dart';
import 'package:connect_umadim_app/app/presentation/user/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../core/style/app_decoration.dart';

class DirectoryComponent extends ConsumerWidget {
  const DirectoryComponent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(listUsersProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return state.maybeWhen(
      loadInProgress: () => _buildLoading(),
      loadFailure: (_) => _buildError(context),
      loadSuccess: (users) => _buildContent(context, users, isDark),
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<UserModel> users,
    bool isDark,
  ) {
    // Conta congregações e áreas únicas
    final congregations = users.map((u) => u.congregation).toSet().length;
    final areas = users.map((u) => u.areaId).toSet().length;

    return Container(
      color: isDark ? AppColor.darkBackground : AppColor.lightBackground,
      child: Column(
        children: [
          // ── Header ─────────────────────────────────────────────
          _DirectoryHeader(
            totalMembers: users.length,
            totalCongregations: congregations,
            totalAreas: areas,
            isDark: isDark,
          ),

          // ── Lista com busca e filtros ───────────────────────────
          Expanded(
            child: UsersListWidget(users: users),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() => Center(
        child: SizedBox(
          height: 8,
          width: 40,
          child: LoadingIndicator(
            indicatorType: Indicator.ballPulse,
            colors: const [AppColor.orange500],
          ),
        ),
      );

  Widget _buildError(BuildContext context) => Center(
        child: Text(
          'Erro ao carregar o diretório.\nTente novamente.',
          style: AppText.bodyMedium(context),
          textAlign: TextAlign.center,
        ),
      );
}

// ── Header do diretório ───────────────────────────────────────

class _DirectoryHeader extends StatelessWidget {
  final int totalMembers;
  final int totalCongregations;
  final int totalAreas;
  final bool isDark;

  const _DirectoryHeader({
    required this.totalMembers,
    required this.totalCongregations,
    required this.totalAreas,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [AppColor.wine900, AppColor.darkBackground]
              : [AppColor.wine600.withOpacity(0.08), AppColor.lightBackground],
        ),
      ),
      child: Column(
        children: [
          // Glow decorativo
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 120,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  gradient: RadialGradient(
                    colors: [
                      AppColor.orange500.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'UMADIM ',
                      style: AppText.displayMedium(context),
                    ),
                    TextSpan(
                      text: '${DateTime.now().year}',
                      style: AppText.displayMedium(context).copyWith(
                        color: AppColor.orange400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Text(
            'União de Mocidade da Assembleia de Deus',
            style: AppText.labelSmall(context),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 14),

          // Stats
          Row(
            children: [
              _StatCard(
                value: '$totalMembers',
                label: 'Membros',
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _StatCard(
                value: '$totalCongregations',
                label: 'Congregações',
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _StatCard(
                value: '$totalAreas',
                label: 'Áreas',
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final bool isDark;

  const _StatCard({
    required this.value,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isDark
              ? AppColor.darkSurfaceVariant
              : AppColor.lightSurfaceVariant,
          borderRadius: AppDecoration.radiusMd,
          border: Border.all(
            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          ),
        ),
        child: Column(
          children: [
            Text(value, style: AppText.counter(context)),
            const SizedBox(height: 2),
            Text(label, style: AppText.labelSmall(context)),
          ],
        ),
      ),
    );
  }
}
