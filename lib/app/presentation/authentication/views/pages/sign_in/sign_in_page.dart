import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/presentation/authentication/views/mixin/sign_in_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/helpers/helpers.dart';
import '../../../../../widgets/button/button_widget.dart';
import '../../../../../widgets/input/input_validators.dart';
import '../../../../../widgets/input/input_widget.dart';
import '../../../provider/auth_provider.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage>
    with SignInMixin, SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    addListeners();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
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

    final isButtonEnabled = ref.watch(isButtonEnabledProvider);
    final state = ref.watch(signInProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // ── Background decorativo ──────────────────────────
          _BackgroundDecoration(isDark: isDark),

          // ── Conteúdo principal ────────────────────────────
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Form(
                  key: formKey,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24)
                        .copyWith(top: 20, bottom: 40),
                    children: [
                      // Logo
                      _buildLogo(),
                      const SizedBox(height: 36),

                      // Título de boas vindas
                      _buildHeader(context),
                      const SizedBox(height: 32),

                      // Campo e-mail
                      _buildFieldLabel(context, 'E-mail'),
                      const SizedBox(height: 6),
                      InputWidget(
                        controller: emailController,
                        hintText: 'seuemail@email.com',
                        textCapitalization: TextCapitalization.none,
                        keyboardType: TextInputType.emailAddress,
                        validator: InputValidators.email,
                        action: TextInputAction.next,
                        onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                      ),
                      const SizedBox(height: 16),

                      // Campo senha
                      _buildFieldLabel(context, 'Senha'),
                      const SizedBox(height: 6),
                      InputWidget(
                        controller: passwordController,
                        hintText: '••••••••',
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Digite sua senha';
                          if (v.length < 8) return 'Mínimo 8 caracteres';
                          return null;
                        },
                        onSubmitted: (_) => onTapButton(),
                      ),
                      const SizedBox(height: 4),

                      // Esqueceu a senha
                      _buildForgotPassword(context),
                      const SizedBox(height: 28),

                      // Botão entrar
                      ButtonWidget(
                        onTap: isButtonEnabled ? onTapButton : null,
                        isLoading: state is CommonStateLoadInProgress,
                        title: 'Entrar',
                      ),
                      const SizedBox(height: 20),

                      // Divisor
                      _buildDivider(context),
                      const SizedBox(height: 20),

                      // Criar conta
                      _buildCreateAccount(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Widgets auxiliares ──────────────────────────────────────

  Widget _buildLogo() {
    return Center(
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColor.wine800,
          border: Border.all(
            color: AppColor.orange500.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.orange500.withOpacity(0.15),
              blurRadius: 32,
              spreadRadius: 4,
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Image.asset(
          'assets/images/umadim-logo.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bem-vindo de volta! 👋',
          style: AppText.displaySmall(context),
        ),
        const SizedBox(height: 6),
        Text(
          'Entre com sua conta para acessar\no Conecta UMADIM.',
          style: AppText.bodyMedium(context),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(BuildContext context, String label) {
    return Text(
      label,
      style: AppText.labelMedium(context).copyWith(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColor.light200
            : AppColor.lightOnSurface,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildForgotPassword(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/auth/recover-password');
          clearFields();
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          'Esqueceu a senha?',
          style: AppText.labelMedium(context).copyWith(
            color: AppColor.orange400,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor =
        isDark ? AppColor.darkBorderStrong : AppColor.lightBorderStrong;
    final textColor =
        isDark ? AppColor.darkOnSurfaceMuted : AppColor.lightOnSurfaceMuted;

    return Row(
      children: [
        Expanded(child: Divider(color: dividerColor, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('ou',
              style: AppText.labelSmall(context).copyWith(color: textColor)),
        ),
        Expanded(child: Divider(color: dividerColor, thickness: 1)),
      ],
    );
  }

  Widget _buildCreateAccount(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Não tem uma conta? ',
          style: AppText.bodySmall(context),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/auth/register');
            clearFields();
          },
          child: Text(
            'Cadastre-se',
            style: AppText.bodySmall(context).copyWith(
              color: AppColor.orange500,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Background decorativo ────────────────────────────────────
class _BackgroundDecoration extends StatelessWidget {
  final bool isDark;
  const _BackgroundDecoration({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fundo base
        Container(
          color: isDark ? AppColor.darkBackground : AppColor.lightBackground,
        ),

        // Glow superior — chama laranja
        Positioned(
          top: -80,
          left: -60,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColor.orange500.withOpacity(isDark ? 0.12 : 0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Glow vinho — canto inferior direito
        Positioned(
          bottom: -60,
          right: -40,
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColor.wine600.withOpacity(isDark ? 0.18 : 0.07),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // Borda decorativa no topo
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 3,
            decoration: const BoxDecoration(
              gradient: AppColor.flamePrimary,
            ),
          ),
        ),
      ],
    );
  }
}
