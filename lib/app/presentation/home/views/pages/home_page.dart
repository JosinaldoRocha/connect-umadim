import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/presentation/home/views/componentes/agenda_component.dart';
import 'package:connect_umadim_app/app/presentation/home/views/componentes/home_component.dart';
import 'package:connect_umadim_app/app/presentation/home/views/componentes/profile_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../../user/providers/user_provider.dart';
import '../../provider/home_provider.dart';
import '../componentes/directory_component.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  PersistentTabController controller = PersistentTabController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(listUsersProvider.notifier).load();
      ref.read(getUserProvider.notifier).load();
      ref.read(getAllVersesProvider.notifier).load();
      ref.read(homeTabsProvider.notifier).updateState = 0;
    });
  }

  void _listenTab() {
    ref.listen<int>(homeTabsProvider, (previous, next) {
      controller.jumpToTab(next);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(getUserProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    _listenTab();

    return Scaffold(
      body: PersistentTabView(
        context,
        controller: controller,
        screens: [
          const HomeComponent(),
          const AgendaComponent(),
          // Índice 2 é o FAB — tela vazia (nunca chega aqui normalmente)
          const SizedBox.shrink(),
          const DirectoryComponent(),
          const ProfileComponent(),
        ],
        items: _navItems(context, isDark),
        popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
        padding: const EdgeInsets.only(top: 8),
        backgroundColor: isDark ? AppColor.darkSurface : AppColor.lightSurface,
        animationSettings: const NavBarAnimationSettings(
          screenTransitionAnimation: ScreenTransitionAnimationSettings(
            animateTabTransition: true,
            duration: Duration(milliseconds: 200),
            screenTransitionAnimationType: ScreenTransitionAnimationType.slide,
          ),
        ),
        confineToSafeArea: true,
        navBarHeight: 64,
        navBarStyle: NavBarStyle.style15,
        onItemSelected: (index) {
          // Índice 2 = botão Postar (FAB central)
          if (index == 2) {
            userState.maybeWhen(
              loadSuccess: (data) => Navigator.pushNamed(
                context,
                '/post/create',
                arguments: data,
              ),
              orElse: () {},
            );
          }
        },
      ),
    );
  }

  List<PersistentBottomNavBarItem> _navItems(
      BuildContext context, bool isDark) {
    final inactiveColor =
        isDark ? AppColor.darkOnSurfaceMuted : AppColor.lightOnSurfaceMuted;

    return [
      // ── Início ──────────────────────────────────────────
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home_rounded),
        inactiveIcon: const Icon(Icons.home_outlined),
        title: 'Início',
        activeColorPrimary: AppColor.orange500,
        inactiveColorPrimary: inactiveColor,
        textStyle: AppText.labelSmall(context),
      ),
      // ── Eventos ─────────────────────────────────────────
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.calendar_month_rounded),
        inactiveIcon: const Icon(Icons.calendar_month_outlined),
        title: 'Eventos',
        activeColorPrimary: AppColor.orange500,
        inactiveColorPrimary: inactiveColor,
        textStyle: AppText.labelSmall(context),
      ),
      // ── Postar (FAB central) ─────────────────────────────
      PersistentBottomNavBarItem(
        icon: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: AppColor.flamePrimary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColor.orange500.withOpacity(0.45),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.add_rounded,
            color: AppColor.light50,
            size: 28,
          ),
        ),
        inactiveIcon: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: AppColor.flamePrimary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColor.orange500.withOpacity(0.35),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.add_rounded,
            color: AppColor.light50,
            size: 28,
          ),
        ),
        title: 'Postar',
        activeColorPrimary: AppColor.orange500,
        inactiveColorPrimary: inactiveColor,
        textStyle: AppText.labelSmall(context),
      ),
      // ── Membros ──────────────────────────────────────────
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.group_rounded),
        inactiveIcon: const Icon(Icons.group_outlined),
        title: 'Membros',
        activeColorPrimary: AppColor.orange500,
        inactiveColorPrimary: inactiveColor,
        textStyle: AppText.labelSmall(context),
      ),
      // ── Perfil ───────────────────────────────────────────
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person_rounded),
        inactiveIcon: const Icon(Icons.person_outline_rounded),
        title: 'Perfil',
        activeColorPrimary: AppColor.orange500,
        inactiveColorPrimary: inactiveColor,
        textStyle: AppText.labelSmall(context),
      ),
    ];
  }
}
