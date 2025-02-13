import 'dart:math';

import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:connect_umadim_app/app/data/models/verse_model.dart';
import 'package:connect_umadim_app/app/presentation/event/views/widgets/next_event_widget.dart';
import 'package:connect_umadim_app/app/presentation/home/provider/home_provider.dart';
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
  Widget build(BuildContext context) {
    final userState = ref.watch(getUserProvider);
    final verseState = ref.watch(getAllVersesProvider);

    return userState.maybeWhen(
      //TODO: create component for loading
      loadInProgress: () => _buildLoadingIndicator(),
      loadSuccess: (data) => Container(
        decoration: _buildBoxDecoration(data),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HomeAppBarWidget(user: data),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  UmadimBoardWidget(),
                  BirthdaysWeekWidget(),
                  NextEventWidget(),
                  verseState.maybeWhen(
                    loadSuccess: (data) {
                      return _buildVerseItem(data);
                    },
                    orElse: () => Container(),
                  ),
                ],
              ),
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

  Padding _buildVerseItem(List<VerseModel> data) {
    int index = Random().nextInt(data.length);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            data[index].text,
            textAlign: TextAlign.center,
            style: AppText.text().bodySmall!.copyWith(
                  fontSize: 14,
                  color: AppColor.primaryGrey,
                ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              data[index].reference,
              style: AppText.text().bodySmall!.copyWith(
                    color: AppColor.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
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
