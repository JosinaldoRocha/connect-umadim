import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/enums/funciton_type_enum.dart';
import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:connect_umadim_app/app/presentation/home/views/widgets/umadim_board_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/style/app_decoration.dart';
import '../../../user/providers/user_provider.dart';

class UmadimBoardWidget extends ConsumerStatefulWidget {
  const UmadimBoardWidget({super.key});

  @override
  ConsumerState<UmadimBoardWidget> createState() => _UmadimBoardWidgetState();
}

class _UmadimBoardWidgetState extends ConsumerState<UmadimBoardWidget> {
  bool _expanded = false;

  static const Map<FunctionType, int> _orderMap = {
    FunctionType.leader: 0,
    FunctionType.viceLeader: 1,
    FunctionType.regent: 2,
    FunctionType.secretary: 3,
    FunctionType.doorman: 4,
    FunctionType.receptionist: 5,
    FunctionType.media: 6,
    FunctionType.evangelist: 7,
    FunctionType.events: 8,
  };

  List<UserModel> _getLeaders(List<UserModel> users) {
    return users
        .where((u) => u.umadimFunction.title != FunctionType.member)
        .toList()
      ..sort((a, b) {
        final iA = _orderMap[a.umadimFunction.title] ?? 99;
        final iB = _orderMap[b.umadimFunction.title] ?? 99;
        return iA.compareTo(iB);
      });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(listUsersProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return state.maybeWhen(
      loadSuccess: (users) {
        final leaders = _getLeaders(users);
        if (leaders.isEmpty) return const SizedBox.shrink();
        return _buildCard(context, leaders, isDark);
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildCard(
      BuildContext context, List<UserModel> leaders, bool isDark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        borderRadius: AppDecoration.radiusLg,
        border: Border.all(
          color: _expanded
              ? AppColor.orange500.withOpacity(0.2)
              : (isDark ? AppColor.darkBorder : AppColor.lightBorder),
        ),
      ),
      child: Column(
        children: [
          // ── Header sempre visível ──────────────────────────
          _buildHeader(context, leaders, isDark),

          // ── Divisor ────────────────────────────────────────
          Divider(
            height: 1,
            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          ),

          // ── Scroll horizontal (colapsado ou expandido) ─────
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild:
                _buildScrollRow(context, leaders, isDark, showAvatar: false),
            secondChild:
                _buildScrollRow(context, leaders, isDark, showAvatar: true),
          ),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────

  Widget _buildHeader(
      BuildContext context, List<UserModel> leaders, bool isDark) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // Ícone
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [AppColor.wine700, AppColor.wine600]),
                borderRadius: AppDecoration.radiusMd,
              ),
              child: const Center(
                child: Text('⛪', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(width: 10),

            // Título e subtítulo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Diretoria UMADIM',
                      style: AppText.headlineSmall(context)),
                  Text(
                    '${leaders.length} membros · ${DateTime.now().year}',
                    style: AppText.labelSmall(context),
                  ),
                ],
              ),
            ),

            // Chevron animado
            AnimatedRotation(
              turns: _expanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 250),
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20,
                color: AppColor.amber400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Scroll horizontal ─────────────────────────────────────
  // showAvatar: false → só função + nome (colapsado)
  // showAvatar: true  → avatar + função + nome (expandido)

  Widget _buildScrollRow(
    BuildContext context,
    List<UserModel> leaders,
    bool isDark, {
    required bool showAvatar,
  }) {
    return SizedBox(
      height: showAvatar ? 100 : 68,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: leaders.length,
        separatorBuilder: (_, i) => i == 0
            ? Row(
                children: [
                  const SizedBox(width: 4),
                  Container(
                    width: 1,
                    height: showAvatar ? 60 : 40,
                    color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
                  ),
                  const SizedBox(width: 4),
                ],
              )
            : const SizedBox(width: 4),
        itemBuilder: (_, i) => showAvatar
            // Expandido: widget completo com avatar
            ? UmadimBoardItemWidget(
                user: leaders[i],
                isPresident: i == 0,
              )
            // Colapsado: só função + nome, sem avatar
            : _BoardItemCompact(
                user: leaders[i],
                isPresident: i == 0,
                isDark: isDark,
              ),
      ),
    );
  }
}

// ── Item compacto (sem avatar) ────────────────────────────────

class _BoardItemCompact extends StatelessWidget {
  final UserModel user;
  final bool isPresident;
  final bool isDark;

  const _BoardItemCompact({
    required this.user,
    required this.isPresident,
    required this.isDark,
  });

  String _firstName(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) return '${parts[0]} ${parts[1][0]}.';
    return parts[0];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Função
          Text(
            user.umadimFunction.title.text,
            style: AppText.labelSmall(context).copyWith(
              fontSize: 9,
              color: isPresident
                  ? AppColor.orange300
                  : (isDark
                      ? AppColor.darkOnSurfaceMuted
                      : AppColor.lightOnSurfaceMuted),
              fontWeight: isPresident ? FontWeight.w600 : FontWeight.w400,
              letterSpacing: 0.04,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          // Nome abreviado
          Text(
            _firstName(user.name),
            style: AppText.labelSmall(context).copyWith(
              fontSize: 11,
              color: isDark
                  ? AppColor.darkOnBackground
                  : AppColor.lightOnBackground,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
