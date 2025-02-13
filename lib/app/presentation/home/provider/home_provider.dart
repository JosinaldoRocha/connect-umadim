import 'package:connect_umadim_app/app/data/providers/data_provider.dart';
import 'package:connect_umadim_app/app/presentation/home/states/verses_list_state_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/tabs_state_notifier.dart';

final homeTabsProvider = StateNotifierProvider<TabsStateNotifier, int>(
  (ref) => TabsStateNotifier(),
);

final getAllVersesProvider =
    StateNotifierProvider<GetAllVersesStateNotifier, GetAllVersesState>(
  (ref) => GetAllVersesStateNotifier(
    dataSource: ref.read(userDataSourceProvider),
  ),
);
