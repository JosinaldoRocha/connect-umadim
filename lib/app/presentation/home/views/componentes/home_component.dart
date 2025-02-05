import 'package:connect_umadim_app/app/presentation/home/views/widgets/birthdays_week_widget.dart';
import 'package:connect_umadim_app/app/presentation/home/views/widgets/home_app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';

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
    Future.microtask(() => ref.read(listUsersProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final userState = ref.watch(getUserProvider);

    return userState.maybeWhen(
      //TODO: create component for loading
      loadInProgress: () => Center(
        child: SizedBox(
          height: 8,
          width: 30,
          child: LoadingIndicator(indicatorType: Indicator.ballPulse),
        ),
      ),
      loadSuccess: (data) => Container(
        decoration: BoxDecoration(
          color: AppColor.lightBgColor,
          image: (data.birthDate!.day == now.day &&
                  data.birthDate!.month == now.month)
              ? DecorationImage(
                  opacity: 0.4,
                  fit: BoxFit.fitWidth,
                  alignment: Alignment(0, 0.8),
                  image: AssetImage('assets/images/birthday_cake.png'),
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeAppBarWidget(user: data),
            BirthdaysWeekWidget(),
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
}
