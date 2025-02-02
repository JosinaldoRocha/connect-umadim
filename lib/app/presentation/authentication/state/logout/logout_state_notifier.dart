import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../data/data_source/auth_data_source.dart';

typedef LogoutState = CommonState<CommonError, bool>;

class LogoutStateNotifier extends StateNotifier<LogoutState> {
  LogoutStateNotifier({required this.dataSource})
      : super(const LogoutState.initial());

  final AuthDataSource dataSource;

  Future<void> load() async {
    state = const LogoutState.loadInProgress();

    final result = await dataSource.logout();
    result.fold(
      (l) => state = LogoutState.loadFailure(l),
      (r) => state = LogoutState.loadSuccess(r),
    );
  }
}
