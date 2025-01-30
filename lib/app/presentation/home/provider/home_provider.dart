import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/tabs_state_notifier.dart';

final homeTabsProvider = StateNotifierProvider<TabsStateNotifier, int>(
  (ref) => TabsStateNotifier(),
);
