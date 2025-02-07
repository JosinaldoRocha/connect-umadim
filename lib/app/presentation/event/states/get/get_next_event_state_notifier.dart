import 'package:connect_umadim_app/app/data/data_source/event_data_source.dart';
import 'package:connect_umadim_app/app/data/models/event_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/helpers/helpers.dart';

typedef GetNextEventState = CommonState<CommonError, List<EventModel>>;

class GetNextEventStateNotifier extends StateNotifier<GetNextEventState> {
  GetNextEventStateNotifier({required this.dataSource})
      : super(const GetNextEventState.initial());

  final EventDataSource dataSource;

  Future<void> load() async {
    state = const GetNextEventState.loadInProgress();

    final result = await dataSource.getNextEvent();
    result.fold(
      (l) => state = GetNextEventState.loadFailure(l),
      (r) => state = GetNextEventState.loadSuccess(r),
    );
  }
}
