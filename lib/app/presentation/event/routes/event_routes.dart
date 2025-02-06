import 'package:connect_umadim_app/app/presentation/event/views/pages/add_event_page.dart';
import 'package:flutter/material.dart';
import '../../../core/navigator/navigator.dart';

class EventRoutes extends IModuleRoutes {
  @override
  String get routeName => '/event';

  @override
  Map<String, Widget Function(BuildContext context)> get routes => {
        '/add': (context) => AddEventPage(
              user: getArgs(context),
            ),
      };
}
