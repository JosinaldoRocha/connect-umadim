import 'package:connect_umadim_app/app/data/data_source/event_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/add/add_event_state_notifier.dart';
import '../states/get/get_all_events_state_notifier.dart';
import '../states/get/get_next_event_state_notifier.dart';

final eventDataSourceProvider = Provider(
  (ref) => EventDataSource(),
);

final getAllEventProvider =
    StateNotifierProvider<GetAllEventsStateNotifier, GetAllEventsState>(
  (ref) => GetAllEventsStateNotifier(
    dataSource: ref.read(eventDataSourceProvider),
  ),
);

final addEventProvider =
    StateNotifierProvider<AddEventStateNotifier, AddEventState>(
  (ref) => AddEventStateNotifier(
    dataSource: ref.read(eventDataSourceProvider),
  ),
);

final getNextEventProvider =
    StateNotifierProvider<GetNextEventStateNotifier, GetNextEventState>(
  (ref) => GetNextEventStateNotifier(
    dataSource: ref.read(eventDataSourceProvider),
  ),
);
