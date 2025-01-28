import 'package:connect_umadim_app/app/data/models/user_model.dart';
import 'package:connect_umadim_app/app/presentation/authentication/views/pages/sign_up/sign_up_page.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/style/app_colors.dart';
import '../../../../widgets/snack_bar/app_snack_bar_widget.dart';
import '../../provider/auth_provider.dart';
import '../../state/sign_up/sign_up_state_notifier.dart';

mixin SignUpMixin<T extends SignUpPage> on ConsumerState<T> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final umadimFucntionController = SingleValueDropDownController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void addListeners() {
    nameController.addListener(_validateFields);
    emailController.addListener(_validateFields);
    umadimFucntionController.addListener(_validateFields);
    passwordController.addListener(_validateFields);
    confirmPasswordController.addListener(_validateFields);
  }

  void _validateFields() {
    final isValid = nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        umadimFucntionController.dropDownValue != null &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;

    ref.read(isButtonEnabledProvider.notifier).state = isValid;
  }

  void listen() {
    ref.listen<SignUpState>(
      signUpProvider,
      (previous, next) {
        next.maybeWhen(
          loadSuccess: (data) =>
              Navigator.of(context).pushReplacementNamed('/auth'),
          loadFailure: (message) {
            AppSnackBar.show(
              context,
              message,
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
      final user = UserModel(
        id: '',
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        umadimFunction: umadimFucntionController.dropDownValue?.name,
        localFunction: '',
        birthDate: null,
        gender: '',
        congregation: '',
        photoUrl: '',
        phoneNumber: '',
        createdAt: DateTime.now(),
      );

      ref.read(signUpProvider.notifier).load(user: user);
    }
  }
}
