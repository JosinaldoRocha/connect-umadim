import 'package:connect_umadim_app/app/data/data_source/event_data_source.dart';
import 'package:connect_umadim_app/app/data/models/event_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/helpers/helpers.dart';

typedef UpdateEventState = CommonState<CommonError, bool>;

class UpdateEventStateNotifier extends StateNotifier<UpdateEventState> {
  UpdateEventStateNotifier({required this.dataSource})
      : super(const UpdateEventState.initial());

  final EventDataSource dataSource;

  Future<void> load(EventModel event) async {
    state = const UpdateEventState.loadInProgress();

    final result = await dataSource.updateEvent(event);
    result.fold(
      (l) => state = UpdateEventState.loadFailure(l),
      (r) => state = UpdateEventState.loadSuccess(r),
    );
  }
}
