import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/presentation/home/views/componentes/agenda_component.dart';
import 'package:connect_umadim_app/app/presentation/home/views/componentes/home_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../../../core/style/app_colors.dart';
import '../../../user/providers/user_provider.dart';
import '../../provider/home_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int selectedIcon = 0;
  PersistentTabController controller = PersistentTabController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(listUsersProvider.notifier).load();
      ref.read(getUserProvider.notifier).load();
      return ref.read(homeTabsProvider.notifier).updateState = 0;
    });
  }

  void listenTab() {
    ref.listen<int>(
      homeTabsProvider,
      (previous, next) {
        setState(() {
          controller.jumpToTab(next);
          selectedIcon = next;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    listenTab();

    return Scaffold(
      bottomNavigationBar: PersistentTabView(
        context,
        controller: controller,
        screens: [
          HomeComponent(),
          AgendaComponent(),
          Center(child: Text('Diretório')),
          Center(child: Text('Perfil')),
          Center(child: Text('Mais')),
        ],
        items: _navBarsItems(),
        popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
        padding: const EdgeInsets.all(8).copyWith(top: 10),
        backgroundColor: AppColor.bgColor,
        animationSettings: const NavBarAnimationSettings(
          screenTransitionAnimation: ScreenTransitionAnimationSettings(
            animateTabTransition: true,
            duration: Duration(milliseconds: 200),
            screenTransitionAnimationType: ScreenTransitionAnimationType.slide,
          ),
        ),
        confineToSafeArea: true,
        navBarHeight: 64,
        navBarStyle: NavBarStyle.style6,
      ),
    );
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        iconSize: 24,
        icon: Icon(Icons.home),
        inactiveIcon: Icon(Icons.home_outlined),
        title: ("Início"),
        activeColorPrimary: AppColor.primary,
        inactiveColorPrimary: AppColor.mediumGrey,
        textStyle: AppText.text().bodyMedium!.copyWith(fontSize: 14),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.calendar_month),
        inactiveIcon: Icon(Icons.calendar_month_outlined),
        title: ("Agenda"),
        activeColorPrimary: AppColor.primary,
        inactiveColorPrimary: AppColor.mediumGrey,
        textStyle: AppText.text().bodyMedium!.copyWith(fontSize: 14),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.folder),
        inactiveIcon: Icon(Icons.folder_open),
        title: ("Diretório"),
        activeColorPrimary: AppColor.primary,
        inactiveColorPrimary: AppColor.mediumGrey,
        textStyle: AppText.text().bodyMedium!.copyWith(fontSize: 14),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person_2),
        inactiveIcon: Icon(Icons.person_2_outlined),
        title: ("Perfil"),
        activeColorPrimary: AppColor.primary,
        inactiveColorPrimary: AppColor.mediumGrey,
        textStyle: AppText.text().bodyMedium!.copyWith(fontSize: 14),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.menu_rounded),
        title: ("Mais"),
        activeColorPrimary: AppColor.primary,
        inactiveColorPrimary: AppColor.mediumGrey,
        textStyle: AppText.text().bodyMedium!.copyWith(fontSize: 14),
      ),
    ];
  }
}
