import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../core/style/app_colors.dart';
import '../../../../widgets/spacing/spacing.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/images/man_praying.png'),
          ),
          const SpaceVertical.x10(),
          const SizedBox(
            height: 10,
            width: 60,
            child: LoadingIndicator(
              indicatorType: Indicator.ballPulse,
              colors: [AppColor.primary],
            ),
          ),
        ],
      ),
    );
  }
}
