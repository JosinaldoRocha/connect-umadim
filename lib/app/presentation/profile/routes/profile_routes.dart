import 'package:connect_umadim_app/app/presentation/profile/views/pages/edit_profile_page.dart';
import 'package:flutter/material.dart';
import '../../../core/navigator/navigator.dart';

class ProfileRoutes extends IModuleRoutes {
  @override
  String get routeName => '/profile';

  @override
  Map<String, Widget Function(BuildContext context)> get routes => {
        '/edit': (context) => EditProfilePage(
              user: getArgs(context),
            ),
      };
}
