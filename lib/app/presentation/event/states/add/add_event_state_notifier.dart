import 'dart:typed_data';

import 'package:connect_umadim_app/app/data/data_source/event_data_source.dart';
import 'package:connect_umadim_app/app/data/models/event_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/helpers/helpers.dart';

typedef AddEventState = CommonState<CommonError, bool>;

class AddEventStateNotifier extends StateNotifier<AddEventState> {
  AddEventStateNotifier({required this.dataSource})
      : super(const AddEventState.initial());

  final EventDataSource dataSource;

  Future<void> add(
    EventModel event,
    Uint8List? imageBytes,
  ) async {
    state = const AddEventState.loadInProgress();

    final result = await dataSource.addEvent(event, imageBytes);
    result.fold(
      (l) => state = AddEventState.loadFailure(l),
      (r) => state = AddEventState.loadSuccess(r),
    );
  }
}
