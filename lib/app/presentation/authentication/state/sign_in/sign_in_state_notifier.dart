import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../data/data_source/auth_data_source.dart';

typedef SignInState = CommonState<CommonError, bool>;

class SignInStateNotifier extends StateNotifier<SignInState> {
  SignInStateNotifier({required this.dataSource})
      : super(const SignInState.initial());

  final AuthDataSource dataSource;

  Future<void> load({
    required String email,
    required String password,
  }) async {
    state = const SignInState.loadInProgress();

    final result = await dataSource.signIn(
      email: email,
      password: password,
    );
    result.fold(
      (l) => state = SignInState.loadFailure(l),
      (r) => state = SignInState.loadSuccess(r),
    );
  }
}
