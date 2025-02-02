import 'package:connect_umadim_app/app/data/data_source/user_data_source.dart';
import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/helpers/helpers.dart';

typedef ListUsersState = CommonState<CommonError, List<UserModel>>;

class ListUsersStateNotifier extends StateNotifier<ListUsersState> {
  ListUsersStateNotifier({required this.dataSource})
      : super(const ListUsersState.initial());

  final UserDataSource dataSource;

  Future<void> load() async {
    state = const ListUsersState.loadInProgress();

    final result = await dataSource.getAllUsers();
    result.fold(
      (l) => state = ListUsersState.loadFailure(l),
      (r) => state = ListUsersState.loadSuccess(r),
    );
  }
}
