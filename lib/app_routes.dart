import 'package:connect_umadim_app/app/presentation/authentication/routes/atuh_routes.dart';
import 'package:connect_umadim_app/app/presentation/event/routes/event_routes.dart';
import 'package:connect_umadim_app/app/presentation/home/views/pages/home_page.dart';
import 'package:flutter/material.dart';

import 'app/core/navigator/navigator.dart';

class AppRoutes extends IAppRoutes {
  @override
  List<IModuleRoutes> get features => [
        AuthRoutes(),
        EventRoutes(),
      ];

  @override
  String get initialRoute => '/auth';

  @override
  Map<String, Widget Function(BuildContext p1)> get routes => {
        '/home': (context) => const HomePage(),
      };
}
