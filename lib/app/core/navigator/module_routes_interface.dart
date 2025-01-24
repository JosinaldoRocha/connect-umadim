import 'package:flutter/material.dart';

abstract class IModuleRoutes {
  String get initialRoute => '';
  String get routeName;
  Map<String, Widget Function(BuildContext context)> get routes;

  Map<String, Widget Function(BuildContext context)> get generatedRoutes {
    var generatedRoutes = <String, WidgetBuilder>{};
    routes.forEach((key, value) {
      String path = '$routeName$key';
      generatedRoutes.addAll({path: value});
    });
    return generatedRoutes;
  }

  dynamic getArgs(BuildContext context) =>
      ModalRoute.of(context)?.settings.arguments;
}
