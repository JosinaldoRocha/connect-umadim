import 'package:connect_umadim_app/app/presentation/authentication/views/pages/sign_up/sign_up_page.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/auth_provider.dart';

mixin SignUpMixin<T extends SignUpPage> on ConsumerState<T> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final umadimFucntionController = SingleValueDropDownController();
  final localFunctionController = SingleValueDropDownController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void addListeners() {
    nameController.addListener(_validateFields);
    emailController.addListener(_validateFields);
    umadimFucntionController.addListener(_validateFields);
    localFunctionController.addListener(_validateFields);
    passwordController.addListener(_validateFields);
    confirmPasswordController.addListener(_validateFields);
  }

  void _validateFields() {
    final isValid = nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        umadimFucntionController.dropDownValue != null &&
        localFunctionController.dropDownValue != null &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;

    ref.read(isButtonEnabledProvider.notifier).state = isValid;
  }

  // void listen() {
  //   ref.listen<SignInState>(
  //     signInProvider,
  //     (previous, next) {
  //       next.maybeWhen(
  //         loadSuccess: (data) =>
  //             Navigator.of(context).pushReplacementNamed('/auth'),
  //         loadFailure: (message) {
  //           AppSnackBar.show(
  //             context,
  //             'Houve um erro ao tentar acessar o app.',
  //             AppColor.error,
  //           );
  //         },
  //         orElse: () {},
  //       );
  //     },
  //   );
  // }

  void onTapButton() {
    if (formKey.currentState!.validate()) {
      // ref.read(signInProvider.notifier).load(
      //       email: emailController.text,
      //       password: passwordController.text,
      //     );
    }
  }
}
