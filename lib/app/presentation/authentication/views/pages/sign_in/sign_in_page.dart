import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/presentation/authentication/views/mixin/sign_in_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/helpers/helpers.dart';
import '../../../../../widgets/button/button_widget.dart';
import '../../../../../widgets/input/input_validators.dart';
import '../../../../../widgets/input/input_widget.dart';
import '../../../../../widgets/spacing/spacing.dart';
import '../../../provider/auth_provider.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> with SignInMixin {
  @override
  void initState() {
    super.initState();
    addListeners();
  }

  @override
  Widget build(BuildContext context) {
    listen();

    final isButtonEnabled = ref.watch(isButtonEnabledProvider);

    final state = ref.watch(signInProvider);

    return Scaffold(
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16).copyWith(top: 72),
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: Image.asset('assets/images/umadim-logo.png'),
            ),
            const SpaceVertical.x10(),
            Text(
              'Bem vindo ao Conecta Umadim! 👋',
              style: AppText.text().titleLarge!,
            ),
            const SpaceVertical.x10(),
            InputWidget(
              controller: emailController,
              hintText: 'seuemail@email.com',
              textCapitalization: TextCapitalization.none,
              keyboardType: TextInputType.emailAddress,
              validator: InputValidators.email,
              action: TextInputAction.next,
              onSubmitted: (p0) {
                FocusScope.of(context).nextFocus();
              },
            ),
            const SpaceVertical.x5(),
            InputWidget(
              controller: passwordController,
              hintText: 'sua senha aqui',
              validator: (p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Digite sua senha';
                }
                if (p0.length < 8) {
                  return 'Senha curta';
                }
                return null;
              },
              onSubmitted: (p0) => onTapButton(),
            ),
            _buildForgotPassword(),
            _buildCreateAccount(),
            const SpaceVertical.x5(),
            ButtonWidget(
              onTap: isButtonEnabled ? onTapButton : null,
              isLoading: state is CommonStateLoadInProgress,
              title: 'Continuar',
            ),
          ],
        ),
      ),
    );
  }

  Row _buildCreateAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Não tem uma conta? ',
          textAlign: TextAlign.center,
          style: AppText.text().bodyMedium!.copyWith(color: AppColor.tertiary),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/auth/register');
            clearFields();
          },
          child: Text(
            'Cadastre-se.',
            textAlign: TextAlign.center,
            style: AppText.text().bodyMedium!.copyWith(
                  color: AppColor.tertiary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }

  Padding _buildForgotPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/auth/recover-password');
          clearFields();
        },
        child: Text(
          'Esqueceu a senha?',
          textAlign: TextAlign.center,
          style: AppText.text().bodyMedium!.copyWith(
                color: AppColor.primary,
              ),
        ),
      ),
    );
  }
}
