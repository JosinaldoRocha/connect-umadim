import 'package:connect_umadim_app/app/data/data_source/user_data_source.dart';
import 'package:connect_umadim_app/app/data/models/verse_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/helpers/common_state/state.dart';
import '../../../core/helpers/errors/errors.dart';

typedef GetAllVersesState = CommonState<CommonError, List<VerseModel>>;

class GetAllVersesStateNotifier extends StateNotifier<GetAllVersesState> {
  GetAllVersesStateNotifier({required this.dataSource})
      : super(const GetAllVersesState.initial());

  final UserDataSource dataSource;

  Future<void> load() async {
    state = const GetAllVersesState.loadInProgress();

    final result = await dataSource.getAllverses();
    result.fold(
      (l) => state = GetAllVersesState.loadFailure(l),
      (r) => state = GetAllVersesState.loadSuccess(r),
    );
  }
}
