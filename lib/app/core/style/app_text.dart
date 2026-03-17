import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Sistema tipográfico do Conecta UMADIM
/// Display/Títulos: Syne (geométrica, bold, moderna)
/// Corpo/Interface: Inter (legível, neutra, profissional)
abstract class AppText {
  // ── Famílias ──────────────────────────────────────────────
  static TextStyle get _syne => GoogleFonts.syne();
  static TextStyle get _inter => GoogleFonts.inter();

  // ── Display (Syne) ─────────────────────────────────────────
  /// 32px · w800 · display hero, telas de boas vindas
  static TextStyle displayLarge(BuildContext context) => _syne.copyWith(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        height: 1.1,
        letterSpacing: -0.5,
        color: _onBg(context),
      );

  /// 26px · w700 · títulos de seção principais
  static TextStyle displayMedium(BuildContext context) => _syne.copyWith(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.3,
        color: _onBg(context),
      );

  /// 22px · w700 · títulos de tela
  static TextStyle displaySmall(BuildContext context) => _syne.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: -0.2,
        color: _onBg(context),
      );

  // ── Headlines (Syne) ──────────────────────────────────────
  /// 20px · w700 · títulos de card, dialogs
  static TextStyle headlineLarge(BuildContext context) => _syne.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: _onBg(context),
      );

  /// 18px · w600 · subtítulos de seção
  static TextStyle headlineMedium(BuildContext context) => _syne.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: _onBg(context),
      );

  /// 16px · w600 · títulos de item, cabeçalhos de lista
  static TextStyle headlineSmall(BuildContext context) => _syne.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: _onBg(context),
      );

  // ── Body (Inter) ──────────────────────────────────────────
  /// 16px · w400 · texto de post, descrições longas
  static TextStyle bodyLarge(BuildContext context) => _inter.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: _onSurface(context),
      );

  /// 14px · w400 · texto padrão de interface
  static TextStyle bodyMedium(BuildContext context) => _inter.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.55,
        color: _onSurface(context),
      );

  /// 13px · w400 · texto secundário, comentários
  static TextStyle bodySmall(BuildContext context) => _inter.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: _onSurfaceMuted(context),
      );

  // ── Labels (Inter) ────────────────────────────────────────
  /// 14px · w600 · botões, ações primárias
  static TextStyle labelLarge(BuildContext context) => _inter.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.1,
        color: _onBg(context),
      );

  /// 12px · w500 · metadados, data/hora, área
  static TextStyle labelMedium(BuildContext context) => _inter.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.3,
        color: _onSurfaceMuted(context),
      );

  /// 11px · w600 · badges, tags, labels em maiúscula
  static TextStyle labelSmall(BuildContext context) => _inter.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.08,
        color: _onSurfaceMuted(context),
      );

  // ── Especiais ─────────────────────────────────────────────
  /// Nome de usuário em posts
  static TextStyle username(BuildContext context) => _syne.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: _onBg(context),
      );

  /// Versículo / citação bíblica
  static TextStyle verse(BuildContext context) => _inter.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w300,
        height: 1.7,
        fontStyle: FontStyle.italic,
        color: _onSurfaceMuted(context),
      );

  /// Contador (curtidas, membros)
  static TextStyle counter(BuildContext context) => _syne.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        height: 1.0,
        color: AppColor.orange400,
      );

  /// Input — texto digitado
  static TextStyle inputText(BuildContext context) => _inter.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: _onBg(context),
      );

  /// Input — hint/placeholder
  static TextStyle inputHint(BuildContext context) => _inter.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: _onSurfaceMuted(context),
      );

  // ── Helpers internos ──────────────────────────────────────
  static Color _onBg(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColor.darkOnBackground : AppColor.lightOnBackground;
  }

  static Color _onSurface(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColor.darkOnSurface : AppColor.lightOnSurface;
  }

  static Color _onSurfaceMuted(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? AppColor.darkOnSurfaceMuted : AppColor.lightOnSurfaceMuted;
  }
}
