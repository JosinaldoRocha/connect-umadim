import 'package:connect_umadim_app/app/core/helpers/errors/sign_up_errors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/helpers/helpers.dart';
import '../../../../data/data_source/auth_data_source.dart';
import '../../../../data/models/user_model.dart';

typedef SignUpState = CommonState<String, bool>;

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
      (l) => state = SignUpState.loadFailure(errorMessage(l)),
      (r) => state = SignUpState.loadSuccess(r),
    );
  }

  String errorMessage(SignUpError error) {
    if (error == SignUpError.emailAlreadyExists) {
      return 'Este e-mail já está cadastrado. Tente outro ou recupere sua conta!';
    } else if (error == SignUpError.noPermission) {
      return 'Você não tem permissão para se cadastrar nesta função. Verifique com o administrador!';
    } else {
      return 'Ocorreu um erro inesperado. Por favor, tente novamente mais tarde!';
    }
  }
}
