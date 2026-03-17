import 'package:flutter/material.dart';

import '../../../core/navigator/navigator.dart';
import '../views/pages/create_post_page.dart';

class PostRoutes extends IModuleRoutes {
  @override
  String get routeName => '/post';

  @override
  Map<String, Widget Function(BuildContext context)> get routes => {
        '/create': (context) => const CreatePostPage(),
      };
}
