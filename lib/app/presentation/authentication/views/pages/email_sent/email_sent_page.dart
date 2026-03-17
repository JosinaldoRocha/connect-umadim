import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../../core/style/app_decoration.dart';

class EmailSentPage extends StatefulWidget {
  const EmailSentPage({super.key});

  @override
  State<EmailSentPage> createState() => _EmailSentPageState();
}

class _EmailSentPageState extends State<EmailSentPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColor.darkBackground : AppColor.lightBackground,
      appBar: _buildAppBar(context, isDark),
      body: Stack(
        children: [
          _buildBackground(isDark),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Animação Lottie
                  SizedBox(
                    height: 210,
                    width: 210,
                    child: Lottie.asset(
                      'assets/animations/email-successfully-sent.json',
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Conteúdo textual com fade+slide
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _slideAnim,
                      child: Column(
                        children: [
                          // Badge de sucesso
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColor.success.withOpacity(0.12),
                              borderRadius: AppDecoration.radiusFull,
                              border: Border.all(
                                color: AppColor.success.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle_rounded,
                                    size: 14, color: AppColor.success),
                                const SizedBox(width: 6),
                                Text(
                                  'E-mail enviado com sucesso',
                                  style: AppText.labelSmall(context).copyWith(
                                    color: AppColor.success,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Título
                          Text(
                            'Verifique sua\ncaixa de entrada',
                            textAlign: TextAlign.center,
                            style: AppText.displaySmall(context),
                          ),

                          const SizedBox(height: 12),

                          // Descrição
                          Text(
                            'Enviamos um link de recuperação para o seu e-mail. Clique no link para redefinir sua senha.',
                            textAlign: TextAlign.center,
                            style: AppText.bodyMedium(context),
                          ),

                          const SizedBox(height: 24),

                          // Card dica de spam
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColor.amber500.withOpacity(0.07),
                              borderRadius: AppDecoration.radiusMd,
                              border: Border.all(
                                color: AppColor.amber500.withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline_rounded,
                                    size: 18,
                                    color: isDark
                                        ? AppColor.amber300
                                        : AppColor.amber600),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Não encontrou? Confira a pasta de spam ou lixo eletrônico.',
                                    style: AppText.bodySmall(context).copyWith(
                                      color: isDark
                                          ? AppColor.amber300
                                          : AppColor.amber600,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(flex: 3),

                  // Botão voltar ao login
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: _buildBottomButton(context, isDark),
                  ),

                  const SizedBox(height: 32),
                ],
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
      automaticallyImplyLeading: false,
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
        // Dois pops: sai do email-sent e da recover-password, voltando ao login
        onPressed: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
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

  Widget _buildBottomButton(BuildContext context, bool isDark) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Voltar ao login'),
          ),
        ),
        const SizedBox(height: 14),
        // Reenviar e-mail
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text(
            'Não recebeu? Reenviar e-mail',
            style: AppText.bodySmall(context).copyWith(
              color: AppColor.orange500,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackground(bool isDark) {
    return Stack(
      children: [
        Positioned(
          top: -60,
          left: -60,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                AppColor.success.withOpacity(isDark ? 0.08 : 0.05),
                Colors.transparent,
              ]),
            ),
          ),
        ),
        Positioned(
          bottom: -40,
          right: -40,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                AppColor.orange500.withOpacity(isDark ? 0.1 : 0.06),
                Colors.transparent,
              ]),
            ),
          ),
        ),
      ],
    );
  }
}
