import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/presentation/authentication/views/mixin/sign_in_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../widgets/button/button_widget.dart';
import '../../../../widgets/input/input_validators.dart';
import '../../../../widgets/input/input_widget.dart';
import '../../../../widgets/spacing/spacing.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> with SignInMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.only(
            top: 72,
            left: 16,
            right: 16,
          ),
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: Image.asset('assets/images/umadim-logo.png'),
            ),
            const SpaceVertical.x10(),
            const SpaceVertical.x3(),
            Text(
              'Bem vindo ao Conecta Umadim! 👋',
              style: AppText.text().titleLarge!,
            ),
            const SpaceVertical.x10(),
            const SpaceVertical.x10(),
            const SpaceVertical.x2(),
            InputWidget(
              controller: emailController,
              hintText: 'seuemail@email.com',
              textCapitalization: TextCapitalization.none,
              keyboardType: TextInputType.emailAddress,
              validator: InputValidators.email,
              autoFocus: true,
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
            ),
            const SpaceVertical.x8(),
            ButtonWidget(
              onTap: onTapButton,
              // isLoading: state is CommonStateLoadInProgress,
              title: 'Continuar',
            ),
          ],
        ),
      ),
    );
  }
}
