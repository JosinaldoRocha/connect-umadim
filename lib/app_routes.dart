import 'package:connect_umadim_app/app/presentation/authentication/routes/atuh_routes.dart';
import 'package:connect_umadim_app/app/presentation/splash/views/pages/splash_page.dart';
import 'package:flutter/material.dart';

import 'app/core/navigator/navigator.dart';

class AppRoutes extends IAppRoutes {
  @override
  List<IModuleRoutes> get features => [
        AuthRoutes(),
      ];

  @override
  String get initialRoute => '/auth/login';

  @override
  Map<String, Widget Function(BuildContext p1)> get routes => {
        '/': (_) => const SplashPage(),
      };
}
