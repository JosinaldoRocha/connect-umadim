import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabsStateNotifier extends StateNotifier<int> {
  TabsStateNotifier() : super(0);

  set updateState(int i) => state = i;
}
