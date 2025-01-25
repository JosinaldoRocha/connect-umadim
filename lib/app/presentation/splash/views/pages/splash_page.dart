import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../../core/style/app_colors.dart';
import '../../../../widgets/spacing/spacing.dart';
import '../../../authentication/provider/auth_provider.dart';
import '../../../authentication/state/authentication/check_authentication_state_notifier.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(authenticationState.notifier).loadUser();
    });
  }

  void authListen() {
    ref.listen<Autenticationstate>(
      authenticationState,
      (previous, next) {
        if (next is IsLogged) {
          // if (next.user!.displayName != null) {
          //   Navigator.of(context).pushReplacementNamed('/home');
          // } else {
          //   Navigator.of(context).pushReplacementNamed(
          //     '/profile/update',
          //   );
          // }
          Scaffold(
            body: Center(
              child: Text('data'),
            ),
          );
        } else if (next is IsNotLogged) {
          Navigator.of(context).pushReplacementNamed('/auth/login');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    authListen();

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
