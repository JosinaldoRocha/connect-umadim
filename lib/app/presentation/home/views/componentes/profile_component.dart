import 'package:connect_umadim_app/app/core/auth/auth_permission_service.dart';
import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:connect_umadim_app/app/presentation/user/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../core/style/app_decoration.dart';

class ProfileComponent extends ConsumerWidget {
  const ProfileComponent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(getUserProvider);
    final role = ref.watch(currentRoleProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return userState.maybeWhen(
      loadInProgress: () => _buildLoading(),
      loadFailure: (_) => _buildError(context),
      loadSuccess: (user) => _buildProfile(context, user, role, isDark),
      orElse: () => const SizedBox.shrink(),
    );
  }

  // ── Loading ───────────────────────────────────────────────────
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
          'Erro ao carregar perfil.\nTente novamente.',
          style: AppText.bodyMedium(context),
          textAlign: TextAlign.center,
        ),
      );

  // ── Perfil completo ───────────────────────────────────────────
  Widget _buildProfile(
    BuildContext context,
    UserModel user,
    UserRole role,
    bool isDark,
  ) {
    return Stack(
      children: [
        Container(
          color: isDark ? AppColor.darkBackground : AppColor.lightBackground,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Header com avatar, nome e stats
              _ProfileHeader(user: user, role: role, isDark: isDark),

              const SizedBox(height: 12),

              // Badge de função
              _RoleBadge(role: role),

              const SizedBox(height: 14),

              // Cards de informação
              _InfoCard(
                title: 'Informações pessoais',
                isDark: isDark,
                rows: [
                  _InfoRow('E-mail', user.email),
                  if (user.birthDate != null)
                    _InfoRow(
                      'Nascimento',
                      DateFormat('dd/MM/yyyy').format(user.birthDate!),
                    ),
                  if (user.gender.isNotEmpty) _InfoRow('Sexo', user.gender),
                  if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty)
                    _InfoRow('Telefone', user.phoneNumber!),
                ],
              ),

              const SizedBox(height: 10),

              _InfoCard(
                title: 'Ministério',
                isDark: isDark,
                rows: [
                  _InfoRow('Congregação', user.congregation),
                  if (user.areaId.isNotEmpty) _InfoRow('Área', user.areaId),
                  _InfoRow(
                    'Função local',
                    user.localFunction.title.text,
                  ),
                  if (user.umadimFunction.title.text.isNotEmpty)
                    _InfoRow(
                      'Função UMADIM',
                      user.umadimFunction.title.text,
                    ),
                ],
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),

        // FAB de editar — fixo no canto inferior direito
        Positioned(
          bottom: 24,
          right: 20,
          child: _EditFab(user: user),
        ),
      ],
    );
  }
}

// ── Header do perfil ──────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  final UserModel user;
  final UserRole role;
  final bool isDark;

  const _ProfileHeader({
    required this.user,
    required this.role,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
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
          // Glow de fundo
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColor.orange500.withOpacity(0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              // Avatar
              Stack(
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColor.wine700, AppColor.orange600],
                      ),
                      border: Border.all(
                        color: AppColor.orange500.withOpacity(0.4),
                        width: 2.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.orange500.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: user.photoUrl != null && user.photoUrl!.isNotEmpty
                          ? Image.network(
                              user.photoUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  _avatarFallback(context, user),
                            )
                          : _avatarFallback(context, user),
                    ),
                  ),

                  // Botão de editar foto
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/profile/edit',
                        arguments: user,
                      ),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.orange500,
                          border: Border.all(
                            color: isDark
                                ? AppColor.darkBackground
                                : AppColor.lightBackground,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          size: 13,
                          color: AppColor.light50,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Nome
          Text(user.name, style: AppText.displaySmall(context)),
          const SizedBox(height: 4),

          // Função principal
          Text(
            user.umadimFunction.title.text,
            style: AppText.labelMedium(context).copyWith(
              color: AppColor.orange300,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.06,
            ),
          ),
          const SizedBox(height: 2),

          // Congregação
          Text(
            '${user.congregation} · ${user.areaId}',
            style: AppText.labelSmall(context),
          ),

          const SizedBox(height: 14),

          // Stats
          _StatsRow(isDark: isDark),
        ],
      ),
    );
  }

  Widget _avatarFallback(BuildContext context, UserModel user) {
    return Container(
      color: AppColor.wine800,
      child: Center(
        child: Text(
          user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
          style: AppText.displaySmall(context).copyWith(
            color: AppColor.light50,
          ),
        ),
      ),
    );
  }
}

// ── Stats row ─────────────────────────────────────────────────

class _StatsRow extends ConsumerWidget {
  final bool isDark;
  const _StatsRow({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: conectar aos providers de posts e eventos do usuário
    const stats = [
      (label: 'Posts', value: '—'),
      (label: 'Curtidas', value: '—'),
      (label: 'Eventos', value: '—'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: AppDecoration.radiusMd,
        border: Border.all(
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
        ),
      ),
      child: Row(
        children: stats.asMap().entries.map((entry) {
          final i = entry.key;
          final stat = entry.value;
          return Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: i < stats.length - 1
                    ? Border(
                        right: BorderSide(
                          color: isDark
                              ? AppColor.darkBorder
                              : AppColor.lightBorder,
                        ),
                      )
                    : null,
              ),
              child: Column(
                children: [
                  Text(
                    stat.value,
                    style: AppText.counter(context),
                  ),
                  const SizedBox(height: 2),
                  Text(stat.label, style: AppText.labelSmall(context)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Badge de role ─────────────────────────────────────────────

class _RoleBadge extends StatelessWidget {
  final UserRole role;
  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    if (role == UserRole.member) return const SizedBox.shrink();

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: AppColor.orange500.withOpacity(0.12),
          borderRadius: AppDecoration.radiusFull,
          border: Border.all(
            color: AppColor.orange500.withOpacity(0.25),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.verified_rounded,
                size: 14, color: AppColor.orange400),
            const SizedBox(width: 6),
            Text(
              role.label,
              style: AppText.labelSmall(context).copyWith(
                color: AppColor.orange300,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.06,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Card de informações ───────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final String title;
  final bool isDark;
  final List<_InfoRow> rows;

  const _InfoCard({
    required this.title,
    required this.isDark,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: AppDecoration.radiusLg,
        border: Border.all(
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título da seção
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
            child: Text(
              title.toUpperCase(),
              style: AppText.labelSmall(context).copyWith(
                letterSpacing: 0.1,
              ),
            ),
          ),

          // Linhas de informação
          ...rows.asMap().entries.map((entry) {
            final row = entry.value;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(row.key, style: AppText.labelMedium(context)),
                  Flexible(
                    child: Text(
                      row.value,
                      style: AppText.bodySmall(context).copyWith(
                        color: isDark
                            ? AppColor.darkOnBackground
                            : AppColor.lightOnBackground,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _InfoRow {
  final String key;
  final String value;
  const _InfoRow(this.key, this.value);
}

// ── FAB de editar ─────────────────────────────────────────────

class _EditFab extends StatelessWidget {
  final UserModel user;
  const _EditFab({required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/profile/edit',
        arguments: user,
      ),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColor.flamePrimary,
          boxShadow: AppDecoration.shadowOrange,
        ),
        child: const Icon(
          Icons.edit_rounded,
          color: AppColor.light50,
          size: 20,
        ),
      ),
    );
  }
}
