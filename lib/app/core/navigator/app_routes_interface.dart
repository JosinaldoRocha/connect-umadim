import 'package:flutter/material.dart';

import 'module_routes_interface.dart';

abstract class IAppRoutes {
  List<IModuleRoutes> get features;

  Map<String, Widget Function(BuildContext)> get routes;

  String get initialRoute;

  Map<String, Widget Function(BuildContext)> get allAppRoutes {
    var allRoutes = <String, WidgetBuilder>{};
    for (final feat in features) {
      allRoutes.addAll(feat.generatedRoutes);
    }
    allRoutes.addAll(routes);
    return allRoutes;
  }

  dynamic getArgs(BuildContext context) =>
      ModalRoute.of(context)?.settings.arguments;
}
