import 'package:connect_umadim_app/app/presentation/user/views/pages/user_details_page.dart';
import 'package:flutter/material.dart';
import '../../../core/navigator/navigator.dart';

class UserRoutes extends IModuleRoutes {
  @override
  String get routeName => '/user';

  @override
  Map<String, Widget Function(BuildContext context)> get routes => {
        '/details': (context) => UserDetailsPage(
              user: getArgs(context),
            ),
      };
}
