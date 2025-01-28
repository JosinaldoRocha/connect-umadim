import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../data/data_source/auth_data_source.dart';
import '../../../../data/models/user_model.dart';

typedef SignUpState = CommonState<CommonError, bool>;

class SignUpStateNotifier extends StateNotifier<SignUpState> {
  SignUpStateNotifier({required this.dataSource})
      : super(const SignUpState.initial());

  final AuthDataSource dataSource;

  Future<void> load({
    required UserModel user,
  }) async {
    state = const SignUpState.loadInProgress();

    final result = await dataSource.signUp(user: user);
    result.fold(
      (l) => state = SignUpState.loadFailure(l),
      (r) => state = SignUpState.loadSuccess(r),
    );
  }
}
