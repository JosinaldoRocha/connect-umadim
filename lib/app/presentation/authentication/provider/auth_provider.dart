import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers/data_provider.dart';
import '../state/authentication/check_authentication_state_notifier.dart';
import '../state/logout/logout_state_notifier.dart';
import '../state/sign_in/sign_in_state_notifier.dart';
import '../state/sign_up/sign_up_state_notifier.dart';

final authenticationState =
    StateNotifierProvider<CheckAutenticationStatenotifier, Autenticationstate>(
  (ref) => CheckAutenticationStatenotifier(
    dataSource: ref.read(authDataSourceProvider),
  ),
);

final signUpProvider = StateNotifierProvider<SignUpStateNotifier, SignUpState>(
  (ref) => SignUpStateNotifier(
    dataSource: ref.read(authDataSourceProvider),
  ),
);

final signInProvider = StateNotifierProvider<SignInStateNotifier, SignInState>(
  (ref) => SignInStateNotifier(
    dataSource: ref.read(authDataSourceProvider),
  ),
);

final logoutProvider = StateNotifierProvider<LogoutStateNotifier, LogoutState>(
  (ref) => LogoutStateNotifier(
    dataSource: ref.read(authDataSourceProvider),
  ),
);

final isButtonEnabledProvider = StateProvider<bool>((ref) => false);
