import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pages/sign_in_page.dart';

mixin SignInMixin<T extends SignInPage> on ConsumerState<T> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
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
