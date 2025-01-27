import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/style/app_text.dart';
import '../../../../../widgets/button/button_widget.dart';
import '../../../../../widgets/input/input_validators.dart';
import '../../../../../widgets/input/input_widget.dart';
import '../../../../../widgets/spacing/spacing.dart';

class RecoverPasswordPage extends ConsumerWidget {
  const RecoverPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColor.tertiary),
      ),
      body: Column(
        children: [
          Form(
            key: formKey,
            child: Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16).copyWith(top: 40),
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: Image.asset('assets/images/umadim-logo.png'),
                  ),
                  const SizedBox(height: 60),
                  Text(
                    'Recuperar senha',
                    style: AppText.text().titleLarge!.copyWith(
                          color: AppColor.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SpaceVertical.x5(),
                  Text('Informe seu e-mail abaixo',
                      style: AppText.text().bodyMedium!),
                  const SpaceVertical.x5(),
                  InputWidget(
                    controller: emailController,
                    hintText: 'seuemail@email.com',
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.emailAddress,
                    validator: InputValidators.email,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ButtonWidget(
              onTap: () {
                if (formKey.currentState!.validate()) {
                  Navigator.pushNamed(context, '/auth/email-sent');
                }
              },
              // isLoading: state is CommonStateLoadInProgress,
              title: 'Recuperar',
            ),
          ),
        ],
      ),
    );
  }
}
