import 'package:flutter/material.dart';
import '../../../core/navigator/navigator.dart';
import '../../splash/views/pages/splash_page.dart';
import '../views/pages/sign_in_page.dart';

class AuthRoutes extends IModuleRoutes {
  @override
  String get routeName => '/auth';

  @override
  Map<String, Widget Function(BuildContext context)> get routes => {
        initialRoute: (_) => const SplashPage(),
        '/login': (context) => SignInPage(),
      };
}
