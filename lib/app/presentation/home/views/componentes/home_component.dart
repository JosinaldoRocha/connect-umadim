import 'package:connect_umadim_app/app/presentation/home/views/widgets/birthdays_week_widget.dart';
import 'package:connect_umadim_app/app/presentation/home/views/widgets/home_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/style/app_colors.dart';
import '../../../user/providers/user_provider.dart';

class HomeComponent extends ConsumerStatefulWidget {
  const HomeComponent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeComponentState();
}

class _HomeComponentState extends ConsumerState<HomeComponent> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(getUserProvider.notifier).load();
      ref.read(listUsersProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.lightBgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeAppBarWidget(),
          BirthdaysWeekWidget(),
        ],
      ),
    );
  }
}
