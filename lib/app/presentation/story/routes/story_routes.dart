import 'package:connect_umadim_app/app/presentation/story/views/pages/story_create_page.dart';
import 'package:connect_umadim_app/app/presentation/story/views/pages/story_viewer_page.dart';
import 'package:flutter/material.dart';

import '../../../core/navigator/navigator.dart';

class StoryRoutes extends IModuleRoutes {
  @override
  String get routeName => '/story';

  @override
  Map<String, Widget Function(BuildContext context)> get routes => {
        '/viewer': (context) => const StoryViewerPage(),
        '/create': (context) => CreateStoryPage(),
      };
}
