import 'package:connect_umadim_app/app/presentation/authentication/views/pages/sign_up/sign_up_page.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin SignUpMixin<T extends SignUpPage> on ConsumerState<T> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final umadimFucntionController = SingleValueDropDownController();
  final localFunctionController = SingleValueDropDownController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

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
