import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:connect_umadim_app/app/core/style/app_text.dart';
import 'package:connect_umadim_app/app/data/models/verse_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/style/app_decoration.dart';

/// Botão pill flutuante "Versículo do dia"
/// Ao tocar abre um overlay com o versículo completo
class VerseFabWidget extends StatefulWidget {
  final VerseModel verse;
  const VerseFabWidget({super.key, required this.verse});

  @override
  State<VerseFabWidget> createState() => _VerseFabWidgetState();
}

class _VerseFabWidgetState extends State<VerseFabWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _scaleAnim = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _show() {
    setState(() => _visible = true);
    _controller.forward();
  }

  void _hide() {
    _controller.reverse().then((_) {
      if (mounted) setState(() => _visible = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Overlay ──────────────────────────────────────────
        if (_visible)
          Positioned.fill(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: GestureDetector(
                onTap: _hide,
                child: Container(
                  color: AppColor.dark950.withOpacity(0.88),
                  child: Center(
                    child: ScaleTransition(
                      scale: _scaleAnim,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: _VerseCard(
                          verse: widget.verse,
                          onClose: _hide,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

        // ── FAB pill ──────────────────────────────────────────
        Positioned(
          bottom: 16,
          right: 14,
          child: _VersePill(onTap: _show),
        ),
      ],
    );
  }
}

// ── Pill button ───────────────────────────────────────────────

class _VersePill extends StatelessWidget {
  final VoidCallback onTap;
  const _VersePill({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [AppColor.wine800, AppColor.dark800]
                : [AppColor.wine600.withOpacity(0.9), AppColor.wine800],
          ),
          borderRadius: AppDecoration.radiusFull,
          border: Border.all(
            color: AppColor.wine600.withOpacity(0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.dark950.withOpacity(0.5),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: AppColor.orange500.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ponto laranja pulsante
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.orange500,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.orange500.withOpacity(0.5),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Text('✦',
                style: TextStyle(fontSize: 11, color: AppColor.orange300)),
            const SizedBox(width: 6),
            Text(
              'Versículo do dia',
              style: AppText.labelMedium(context).copyWith(
                color: AppColor.orange300,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Card do versículo (exibido no overlay) ────────────────────

class _VerseCard extends StatelessWidget {
  final VerseModel verse;
  final VoidCallback onClose;

  const _VerseCard({required this.verse, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColor.wine800, AppColor.dark800],
        ),
        borderRadius: AppDecoration.radiusXl,
        border: Border.all(
          color: AppColor.wine600.withOpacity(0.4),
        ),
      ),
      child: Stack(
        children: [
          // Aspa decorativa
          Positioned(
            top: -12,
            left: -4,
            child: Text(
              '"',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 80,
                height: 1,
                color: AppColor.orange500.withOpacity(0.1),
              ),
            ),
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColor.orange500.withOpacity(0.15),
                  borderRadius: AppDecoration.radiusFull,
                  border: Border.all(
                    color: AppColor.orange500.withOpacity(0.25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('✦',
                        style:
                            TextStyle(fontSize: 9, color: AppColor.orange300)),
                    const SizedBox(width: 5),
                    Text(
                      'VERSÍCULO DO DIA',
                      style: AppText.labelSmall(context).copyWith(
                        color: AppColor.orange300,
                        letterSpacing: 0.08,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Texto
              Text(
                verse.text,
                style: AppText.verse(context).copyWith(
                  color: AppColor.light200,
                  fontSize: 16,
                  height: 1.75,
                ),
              ),

              const SizedBox(height: 12),

              // Referência
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  verse.reference,
                  style: AppText.labelMedium(context).copyWith(
                    color: AppColor.orange400,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Botão fechar
              GestureDetector(
                onTap: onClose,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColor.orange500.withOpacity(0.12),
                    borderRadius: AppDecoration.radiusMd,
                    border: Border.all(
                      color: AppColor.orange500.withOpacity(0.25),
                    ),
                  ),
                  child: Text(
                    'Fechar',
                    textAlign: TextAlign.center,
                    style: AppText.labelLarge(context).copyWith(
                      color: AppColor.orange400,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
