import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../widgets/snack_bar/app_snack_bar_widget.dart';
import '../../provider/auth_provider.dart';
import '../../state/sign_in/sign_in_state_notifier.dart';
import '../pages/sign_in/sign_in_page.dart';

mixin SignInMixin<T extends SignInPage> on ConsumerState<T> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void addListeners() {
    emailController.addListener(_validateFields);
    passwordController.addListener(_validateFields);
  }

  void _validateFields() {
    final isValid =
        emailController.text.isNotEmpty && passwordController.text.isNotEmpty;

    ref.read(isButtonEnabledProvider.notifier).state = isValid;
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
  }

  void listen() {
    ref.listen<SignInState>(
      signInProvider,
      (previous, next) {
        next.maybeWhen(
          loadSuccess: (data) =>
              Navigator.of(context).pushReplacementNamed('/auth'),
          loadFailure: (message) {
            AppSnackBar.show(
              context,
              'Houve um erro ao tentar acessar o app.',
              AppColor.error,
            );
          },
          orElse: () {},
        );
      },
    );
  }

  void onTapButton() {
    if (formKey.currentState!.validate()) {
      ref.read(signInProvider.notifier).load(
            email: emailController.text,
            password: passwordController.text,
          );
    }
  }
}
