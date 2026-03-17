import 'package:connect_umadim_app/app/core/constants/constants.dart';
import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/presentation/authentication/views/mixin/sign_up_mixin.dart';
import 'package:connect_umadim_app/app/widgets/button/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/helpers/common_state/state.dart';
import '../../../../../core/style/app_decoration.dart';
import '../../../../../widgets/dropdown/dropdown_widget.dart';
import '../../../../../widgets/input/input_validators.dart';
import '../../../../../widgets/input/input_widget.dart';
import '../../../provider/auth_provider.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage>
    with SignUpMixin, SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  // Controla qual "passo" está expandido visualmente (UX de progresso)
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    ));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    listen();
    final state = ref.watch(signUpProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColor.darkBackground : AppColor.lightBackground,
      appBar: _buildAppBar(context, isDark),
      body: Stack(
        children: [
          // Glow decorativo
          _buildBackground(isDark),

          // Conteúdo
          FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: Column(
                children: [
                  // Indicador de progresso
                  _buildStepIndicator(context),

                  // Formulário
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                        children: [
                          // ── Passo 1: Dados pessoais ──────
                          _SectionHeader(
                            step: 1,
                            label: 'Dados pessoais',
                            isDone: _currentStep > 0,
                            isCurrent: _currentStep == 0,
                          ),
                          const SizedBox(height: 14),
                          _buildFieldLabel(context, 'Nome completo'),
                          const SizedBox(height: 6),
                          InputWidget(
                            controller: nameController,
                            hintText: 'Seu nome completo',
                            validator: InputValidators.fullName,
                            action: TextInputAction.next,
                            onSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            onChanged: (_) => _updateStep(),
                          ),
                          const SizedBox(height: 14),
                          _buildFieldLabel(context, 'E-mail'),
                          const SizedBox(height: 6),
                          InputWidget(
                            controller: emailController,
                            hintText: 'seuemail@email.com',
                            textCapitalization: TextCapitalization.none,
                            keyboardType: TextInputType.emailAddress,
                            validator: InputValidators.email,
                            action: TextInputAction.next,
                            onSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            onChanged: (_) => _updateStep(),
                          ),

                          const SizedBox(height: 24),

                          // ── Passo 2: Função na UMADIM ────
                          _SectionHeader(
                            step: 2,
                            label: 'Sua função na UMADIM',
                            isDone: _currentStep > 1,
                            isCurrent: _currentStep == 1,
                          ),
                          const SizedBox(height: 14),
                          _buildFieldLabel(context, 'Função'),
                          const SizedBox(height: 6),
                          DropDownWidget(
                            controller: umadimFunctionController,
                            list: functionTypeList,
                            hintText: 'Selecione sua função',
                            onChanged: (_) => _updateStep(),
                          ),

                          const SizedBox(height: 24),

                          // ── Passo 3: Senha ───────────────
                          _SectionHeader(
                            step: 3,
                            label: 'Crie sua senha',
                            isDone: _currentStep > 2,
                            isCurrent: _currentStep == 2,
                          ),
                          const SizedBox(height: 14),
                          _buildFieldLabel(context, 'Senha'),
                          const SizedBox(height: 6),
                          InputWidget(
                            controller: passwordController,
                            hintText: 'Mínimo 8 caracteres',
                            validator: InputValidators.password,
                            action: TextInputAction.next,
                            onSubmitted: (_) =>
                                FocusScope.of(context).nextFocus(),
                            onChanged: (_) => _updateStep(),
                          ),
                          const SizedBox(height: 14),
                          _buildFieldLabel(context, 'Confirmar senha'),
                          const SizedBox(height: 6),
                          InputWidget(
                            controller: confirmPasswordController,
                            hintText: 'Repita sua senha',
                            action: TextInputAction.done,
                            onSubmitted: (_) => onTapButton(),
                            onChanged: (_) => _updateStep(),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Por favor, confirme a senha.';
                              }
                              if (v.length < 8) return 'Senha muito curta';
                              if (v != passwordController.text) {
                                return 'As senhas não coincidem';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),

                          // Aviso de acesso controlado
                          _buildAccessNote(context, isDark),
                        ],
                      ),
                    ),
                  ),

                  // Botão fixo no fundo
                  _buildBottomButton(context, state, isDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────

  void _updateStep() {
    final nameOk = nameController.text.isNotEmpty;
    final emailOk = emailController.text.isNotEmpty;
    final funcOk = umadimFunctionController.dropDownValue != null;
    final passOk = passwordController.text.length >= 8;

    int step = 0;
    if (nameOk && emailOk) step = 1;
    if (step == 1 && funcOk) step = 2;
    if (step == 2 && passOk) step = 3;

    if (step != _currentStep) setState(() => _currentStep = step);
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      backgroundColor:
          isDark ? AppColor.darkBackground : AppColor.lightBackground,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isDark
                ? AppColor.darkSurfaceVariant
                : AppColor.lightSurfaceVariant,
            borderRadius: AppDecoration.radiusMd,
            border: Border.all(
              color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
            ),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 16,
            color:
                isDark ? AppColor.darkOnBackground : AppColor.lightOnBackground,
          ),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text('Criar conta', style: AppText.headlineMedium(context)),
      centerTitle: false,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              AppColor.orange600,
              AppColor.orange400,
              AppColor.amber400,
            ]),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
      child: Row(
        children: List.generate(3, (i) {
          final done = i < _currentStep;
          final active = i == _currentStep;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: AppDecoration.radiusFull,
                      color: done
                          ? AppColor.orange500
                          : active
                              ? AppColor.orange500.withOpacity(0.5)
                              : (Theme.of(context).brightness == Brightness.dark
                                  ? AppColor.darkBorderStrong
                                  : AppColor.lightBorderStrong),
                    ),
                  ),
                ),
                if (i < 2) const SizedBox(width: 6),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFieldLabel(BuildContext context, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      label,
      style: AppText.labelMedium(context).copyWith(
        color: isDark ? AppColor.light200 : AppColor.lightOnSurface,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildAccessNote(BuildContext context, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColor.amber500.withOpacity(0.07),
        borderRadius: AppDecoration.radiusMd,
        border: Border.all(
          color: AppColor.amber500.withOpacity(0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ℹ️', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Após o cadastro, um líder da sua congregação precisará aprovar seu acesso ao app.',
              style: AppText.bodySmall(context).copyWith(
                color: isDark ? AppColor.amber300 : AppColor.amber600,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context, dynamic state, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      decoration: BoxDecoration(
        color: isDark ? AppColor.darkBackground : AppColor.lightBackground,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ButtonWidget(
            isLoading: state is CommonStateLoadInProgress,
            title: 'Criar conta',
            onTap: onTapButton,
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Já tem uma conta? ', style: AppText.bodySmall(context)),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Text(
                  'Entrar',
                  style: AppText.bodySmall(context).copyWith(
                    color: AppColor.orange500,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(bool isDark) {
    return Stack(children: [
      Positioned(
        top: -60,
        right: -60,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [
              AppColor.orange500.withOpacity(isDark ? 0.09 : 0.06),
              Colors.transparent,
            ]),
          ),
        ),
      ),
    ]);
  }
}

// ── Widget auxiliar: cabeçalho de seção numerado ─────────────
class _SectionHeader extends StatelessWidget {
  final int step;
  final String label;
  final bool isDone;
  final bool isCurrent;

  const _SectionHeader({
    required this.step,
    required this.label,
    required this.isDone,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color dotColor = isDone
        ? AppColor.orange500
        : isCurrent
            ? AppColor.orange500
            : (isDark ? AppColor.darkBorderStrong : AppColor.lightBorderStrong);
    final Color labelColor = isCurrent || isDone
        ? (isDark ? AppColor.darkOnBackground : AppColor.lightOnBackground)
        : (isDark ? AppColor.darkOnSurfaceMuted : AppColor.lightOnSurfaceMuted);

    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone
                ? AppColor.orange500
                : isCurrent
                    ? AppColor.orange500.withOpacity(0.15)
                    : (isDark
                        ? AppColor.darkSurfaceVariant
                        : AppColor.lightSurfaceVariant),
            border: Border.all(color: dotColor, width: 1.5),
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check_rounded,
                    size: 14, color: AppColor.light50)
                : Text(
                    '$step',
                    style: AppText.labelSmall(context).copyWith(
                      color: isCurrent ? AppColor.orange500 : labelColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: AppText.headlineSmall(context).copyWith(color: labelColor),
        ),
      ],
    );
  }
}
