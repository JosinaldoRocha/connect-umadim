import 'package:connect_umadim_app/app/presentation/authentication/views/pages/sign_up/sign_up_page.dart';
import 'package:flutter/material.dart';
import '../../../core/navigator/navigator.dart';
import '../../splash/views/pages/splash_page.dart';
import '../views/pages/sign_in/sign_in_page.dart';

class AuthRoutes extends IModuleRoutes {
  @override
  String get routeName => '/auth';

  @override
  Map<String, Widget Function(BuildContext context)> get routes => {
        initialRoute: (_) => const SplashPage(),
        '/login': (context) => SignInPage(),
        '/register': (context) => SignUpPage(),
      };
}
