import 'package:connect_umadim_app/app/data/data_source/event_data_source.dart';
import 'package:connect_umadim_app/app/data/models/event_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/helpers/helpers.dart';

typedef GetAllEventsState = CommonState<CommonError, List<EventModel>>;

class GetAllEventsStateNotifier extends StateNotifier<GetAllEventsState> {
  GetAllEventsStateNotifier({required this.dataSource})
      : super(const GetAllEventsState.initial());

  final EventDataSource dataSource;

  Future<void> load() async {
    state = const GetAllEventsState.loadInProgress();

    final result = await dataSource.getAllEvents();
    result.fold(
      (l) => state = GetAllEventsState.loadFailure(l),
      (r) => state = GetAllEventsState.loadSuccess(r),
    );
  }
}
