import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/style/app_decoration.dart';
import '../../../../../widgets/button/button_widget.dart';
import '../../../../../widgets/input/input_validators.dart';
import '../../../../../widgets/input/input_widget.dart';

class RecoverPasswordPage extends ConsumerStatefulWidget {
  const RecoverPasswordPage({super.key});

  @override
  ConsumerState<RecoverPasswordPage> createState() =>
      _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends ConsumerState<RecoverPasswordPage>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  bool _isLoading = false;

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
    emailController.dispose();
    super.dispose();
  }

  void _onTapButton() {
    if (formKey.currentState!.validate()) {
      Navigator.pushNamed(context, '/auth/email-sent');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColor.darkBackground : AppColor.lightBackground,
      appBar: _buildAppBar(context, isDark),
      body: Stack(
        children: [
          _buildBackground(isDark),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Column(
                  children: [
                    Expanded(
                      child: Form(
                        key: formKey,
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                          children: [
                            // Ícone central
                            _buildIcon(isDark),
                            const SizedBox(height: 32),

                            // Título e instrução
                            _buildHeader(context),
                            const SizedBox(height: 28),

                            // Campo e-mail
                            _buildFieldLabel(context, isDark),
                            const SizedBox(height: 6),
                            InputWidget(
                              controller: emailController,
                              hintText: 'seuemail@email.com',
                              textCapitalization: TextCapitalization.none,
                              keyboardType: TextInputType.emailAddress,
                              validator: InputValidators.email,
                              action: TextInputAction.done,
                              onSubmitted: (_) => _onTapButton(),
                            ),
                            const SizedBox(height: 20),

                            // Dica informativa
                            _buildInfoCard(context, isDark),
                          ],
                        ),
                      ),
                    ),

                    // Botão fixo no fundo
                    _buildBottomButton(context, isDark),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Widgets auxiliares ──────────────────────────────────────

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

  Widget _buildIcon(bool isDark) {
    return Center(
      child: Container(
        width: 88,
        height: 88,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark
              ? AppColor.darkSurfaceVariant
              : AppColor.lightSurfaceVariant,
          border: Border.all(
            color: AppColor.orange500.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.orange500.withOpacity(0.12),
              blurRadius: 28,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Anel decorativo interno
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.orange500.withOpacity(0.1),
              ),
            ),
            const Icon(
              Icons.lock_reset_rounded,
              size: 36,
              color: AppColor.orange400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recuperar senha', style: AppText.displaySmall(context)),
        const SizedBox(height: 8),
        Text(
          'Informe o e-mail cadastrado na sua conta.\nVamos enviar um link para redefinir sua senha.',
          style: AppText.bodyMedium(context),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(BuildContext context, bool isDark) {
    return Text(
      'E-mail',
      style: AppText.labelMedium(context).copyWith(
        color: isDark ? AppColor.light200 : AppColor.lightOnSurface,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColor.orange500.withOpacity(0.07),
        borderRadius: AppDecoration.radiusMd,
        border: Border.all(
          color: AppColor.orange500.withOpacity(0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.mail_outline_rounded,
            size: 18,
            color: isDark ? AppColor.orange300 : AppColor.orange500,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Verifique também sua caixa de spam caso não encontre o e-mail na caixa de entrada.',
              style: AppText.bodySmall(context).copyWith(
                color: isDark ? AppColor.orange300 : AppColor.orange600,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context, bool isDark) {
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
            onTap: _onTapButton,
            isLoading: _isLoading,
            title: 'Enviar link de recuperação',
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Lembrou a senha? ', style: AppText.bodySmall(context)),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Text(
                  'Voltar ao login',
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
    return Stack(
      children: [
        Positioned(
          top: -80,
          right: -60,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                AppColor.orange500.withOpacity(isDark ? 0.1 : 0.06),
                Colors.transparent,
              ]),
            ),
          ),
        ),
        Positioned(
          bottom: -40,
          left: -40,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                AppColor.wine600.withOpacity(isDark ? 0.15 : 0.06),
                Colors.transparent,
              ]),
            ),
          ),
        ),
      ],
    );
  }
}
