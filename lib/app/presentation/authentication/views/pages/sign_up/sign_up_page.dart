import 'package:connect_umadim_app/app/core/constants/constants.dart';
import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/presentation/authentication/views/mixin/sign_up_mixin.dart';
import 'package:connect_umadim_app/app/widgets/button/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../widgets/dropdown/dropdown_widget.dart';
import '../../../../../widgets/input/input_validators.dart';
import '../../../../../widgets/input/input_widget.dart';
import '../../../../../widgets/spacing/spacing.dart';
import '../../../provider/auth_provider.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> with SignUpMixin {
  @override
  void initState() {
    super.initState();
    addListeners();
  }

  @override
  Widget build(BuildContext context) {
    final isButtonEnabled = ref.watch(isButtonEnabledProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadastro',
          style: AppText.text().titleLarge!.copyWith(
                color: AppColor.tertiary,
              ),
        ),
        iconTheme: IconThemeData(color: AppColor.tertiary),
      ),
      body: Column(
        children: [
          Form(
            key: formKey,
            child: Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  InputWidget(
                    controller: nameController,
                    hintText: 'Nome completo',
                    validator: InputValidators.fullName,
                  ),
                  const SpaceVertical.x5(),
                  InputWidget(
                    controller: emailController,
                    hintText: 'E-mail',
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.emailAddress,
                    validator: InputValidators.email,
                  ),
                  const SpaceVertical.x5(),
                  DropDownWidget(
                    controller: umadimFucntionController,
                    list: functionTypeList,
                    hintText: 'Sua função na umadim',
                    onChanged: (p0) {
                      setState(() {});
                    },
                  ),
                  const SpaceVertical.x5(),
                  DropDownWidget(
                    controller: localFunctionController,
                    list: functionTypeList,
                    hintText: 'Sua função na congregação',
                    onChanged: (p0) {
                      setState(() {});
                    },
                  ),
                  const SpaceVertical.x5(),
                  InputWidget(
                    controller: passwordController,
                    hintText: 'Crie uma senha para sua conta',
                    validator: InputValidators.password,
                  ),
                  const SpaceVertical.x5(),
                  InputWidget(
                    controller: confirmPasswordController,
                    hintText: 'Confirme a senha',
                    validator: InputValidators.password,
                  ),
                  const SpaceVertical.x5(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ButtonWidget(
              title: 'Finalizar',
              onTap: isButtonEnabled ? onTapButton : null,
            ),
          ),
        ],
      ),
    );
  }
}
