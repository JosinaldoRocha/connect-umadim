import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../data/data_source/user_data_source.dart';
import '../../../../data/models/user_model.dart';

typedef GetUserState = CommonState<CommonError, UserModel>;

class GetUserStateNotifier extends StateNotifier<GetUserState> {
  GetUserStateNotifier({required this.dataSource})
      : super(const GetUserState.initial());

  final UserDataSource dataSource;

  Future<void> load() async {
    state = const GetUserState.loadInProgress();

    final result = await dataSource.getLocalUser();
    result.fold(
      (l) => state = GetUserState.loadFailure(l),
      (r) => state = GetUserState.loadSuccess(r),
    );
  }
}
