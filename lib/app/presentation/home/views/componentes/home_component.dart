import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:connect_umadim_app/app/presentation/event/views/widgets/next_event_widget.dart';
import 'package:connect_umadim_app/app/presentation/home/views/widgets/birthdays_week_widget.dart';
import 'package:connect_umadim_app/app/presentation/home/views/widgets/home_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../core/style/app_colors.dart';
import '../../../user/providers/user_provider.dart';
import '../widgets/umadim_board_widget.dart';

class HomeComponent extends ConsumerStatefulWidget {
  const HomeComponent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeComponentState();
}

class _HomeComponentState extends ConsumerState<HomeComponent> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(listUsersProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(getUserProvider);

    return userState.maybeWhen(
      //TODO: create component for loading
      loadInProgress: () => _buildLoadingIndicator(),
      loadSuccess: (data) => Container(
        decoration: _buildBoxDecoration(data),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HomeAppBarWidget(user: data),
            ListView(
              shrinkWrap: true,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UmadimBoardWidget(),
                BirthdaysWeekWidget(),
                NextEventWidget(),
              ],
            ),
          ],
        ),
      ),
      loadFailure: (failure) => Center(
        child: Text(
          'Houve um erro ao carregar os dados,\ntente novamente!',
          textAlign: TextAlign.center,
        ),
      ),
      orElse: () => Container(),
    );
  }

  Center _buildLoadingIndicator() {
    return Center(
      child: SizedBox(
        height: 8,
        width: 40,
        child: LoadingIndicator(
          indicatorType: Indicator.ballPulse,
          colors: [AppColor.primary],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration(UserModel data) {
    final now = DateTime.now();

    return BoxDecoration(
      color: AppColor.lightBgColor,
      image:
          (data.birthDate?.day == now.day && data.birthDate?.month == now.month)
              ? DecorationImage(
                  opacity: 0.1,
                  fit: BoxFit.fitWidth,
                  alignment: Alignment(0, 0.8),
                  image: AssetImage('assets/images/birthday_cake.png'),
                )
              : null,
    );
  }
}
