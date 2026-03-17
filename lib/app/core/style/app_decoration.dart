import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Decorações, sombras e estilos reutilizáveis do Conecta UMADIM
abstract class AppDecoration {
  // ── Bordas padrão ─────────────────────────────────────────
  static BorderRadius get radiusSm => BorderRadius.circular(8);
  static BorderRadius get radiusMd => BorderRadius.circular(12);
  static BorderRadius get radiusLg => BorderRadius.circular(16);
  static BorderRadius get radiusXl => BorderRadius.circular(20);
  static BorderRadius get radiusFull => BorderRadius.circular(100);

  // ── Card escuro ───────────────────────────────────────────
  static BoxDecoration cardDark({double radius = 16}) => BoxDecoration(
        color: AppColor.darkSurface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColor.darkBorder, width: 1),
      );

  /// Card com leve toque vinho (destaque)
  static BoxDecoration cardDarkAccent({double radius = 16}) => BoxDecoration(
        color: AppColor.darkSurface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColor.wine600.withOpacity(0.4), width: 1),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColor.dark900, AppColor.dark800],
        ),
      );

  // ── Card claro ────────────────────────────────────────────
  static BoxDecoration cardLight({double radius = 16}) => BoxDecoration(
        color: AppColor.lightSurface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColor.lightBorder, width: 1),
        boxShadow: shadowLight,
      );

  // ── Superfície de input ───────────────────────────────────
  static BoxDecoration inputSurfaceDark = BoxDecoration(
    color: AppColor.darkOnBackground.withOpacity(0.05),
    borderRadius: radiusMd,
    border: Border.all(color: AppColor.darkBorder, width: 1.5),
  );

  static BoxDecoration inputSurfaceLight = BoxDecoration(
    color: AppColor.lightOnBackground.withOpacity(0.04),
    borderRadius: radiusMd,
    border: Border.all(color: AppColor.lightBorder, width: 1.5),
  );

  // ── Header / banner ───────────────────────────────────────
  static BoxDecoration headerDark = const BoxDecoration(
    gradient: AppColor.headerDark,
  );

  static BoxDecoration headerDarkRounded = BoxDecoration(
    gradient: AppColor.headerDark,
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(24),
      bottomRight: Radius.circular(24),
    ),
  );

  // ── Avatar ────────────────────────────────────────────────
  static BoxDecoration avatarDark = BoxDecoration(
    gradient: AppColor.wineDeep,
    borderRadius: radiusMd,
    border: Border.all(color: AppColor.darkBorderStrong, width: 1),
  );

  static BoxDecoration avatarFlame = BoxDecoration(
    gradient: AppColor.flamePrimary,
    borderRadius: radiusMd,
  );

  // ── Badge / tag ───────────────────────────────────────────
  static BoxDecoration badgeOrange = BoxDecoration(
    color: AppColor.orange500.withOpacity(0.18),
    borderRadius: radiusFull,
    border: Border.all(color: AppColor.orange500.withOpacity(0.3), width: 1),
  );

  static BoxDecoration badgeAmber = BoxDecoration(
    color: AppColor.amber500.withOpacity(0.15),
    borderRadius: radiusFull,
    border: Border.all(color: AppColor.amber500.withOpacity(0.25), width: 1),
  );

  static BoxDecoration badgeWine = BoxDecoration(
    color: AppColor.wine700.withOpacity(0.6),
    borderRadius: radiusFull,
    border: Border.all(color: AppColor.wine600.withOpacity(0.5), width: 1),
  );

  static BoxDecoration badgeSuccess = BoxDecoration(
    color: AppColor.success.withOpacity(0.15),
    borderRadius: radiusFull,
    border: Border.all(color: AppColor.success.withOpacity(0.3), width: 1),
  );

  // ── Bottom nav ────────────────────────────────────────────
  static BoxDecoration bottomNavDark = BoxDecoration(
    color: AppColor.darkSurface,
    border: Border(
      top: BorderSide(color: AppColor.darkBorder, width: 1),
    ),
  );

  static BoxDecoration bottomNavLight = BoxDecoration(
    color: AppColor.lightSurface,
    border: Border(
      top: BorderSide(color: AppColor.lightBorder, width: 1),
    ),
  );

  // ── Overlay de post ───────────────────────────────────────
  static BoxDecoration postOverlay = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.transparent,
        AppColor.wine950.withOpacity(0.85),
      ],
    ),
  );

  // ── Divisor com gradiente ─────────────────────────────────
  static BoxDecoration dividerFade = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Colors.transparent,
        AppColor.darkBorderStrong,
        Colors.transparent,
      ],
    ),
  );

  // ── Sombras ───────────────────────────────────────────────
  static List<BoxShadow> get shadowLight => [
        BoxShadow(
          color: AppColor.wine800.withOpacity(0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get shadowOrange => [
        BoxShadow(
          color: AppColor.orange500.withOpacity(0.35),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get shadowOrangeSm => [
        BoxShadow(
          color: AppColor.orange500.withOpacity(0.25),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get shadowCard => [
        BoxShadow(
          color: AppColor.wine950.withOpacity(0.2),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ];
}

/// Espaçamentos e padding padrão
abstract class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double x3l = 32;
  static const double x4l = 40;
  static const double x5l = 48;

  static const EdgeInsets pagePadding = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets cardPadding = EdgeInsets.all(16);
  static const EdgeInsets listItemPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 12);
  static const EdgeInsets inputPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 14);
}
