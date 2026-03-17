import 'package:flutter/material.dart';

/// Paleta de cores oficial do Conecta UMADIM
/// Baseada na identidade visual da UMADIM — Itinga do Maranhão
abstract class AppColor {
  // ── Vinho / Bordô ──────────────────────────────────────────
  static const wine950 = Color(0xFF0D0305);
  static const wine900 = Color(0xFF1A0508);
  static const wine800 = Color(0xFF3D0C12);
  static const wine700 = Color(0xFF6B1219);
  static const wine600 = Color(0xFF8B1A22);
  static const wine500 = Color(0xFFA82028);
  static const wine400 = Color(0xFFC42E37);

  // ── Laranja (chama) ────────────────────────────────────────
  static const orange600 = Color(0xFFC94E0A);
  static const orange500 = Color(0xFFE8621A);
  static const orange400 = Color(0xFFFF7A2F);
  static const orange300 = Color(0xFFFF9A5C);
  static const orange200 = Color(0xFFFFBD97);
  static const orange100 = Color(0xFFFFDDC8);

  // ── Âmbar / Dourado ────────────────────────────────────────
  static const amber600 = Color(0xFFD4880A);
  static const amber500 = Color(0xFFF5A623);
  static const amber400 = Color(0xFFFFB830);
  static const amber300 = Color(0xFFFFCC60);
  static const amber100 = Color(0xFFFFF0C2);

  // ── Neutros escuros (dark theme) ──────────────────────────
  static const dark950 = Color(0xFF0F0407);
  static const dark900 = Color(0xFF160608);
  static const dark800 = Color(0xFF1E0A0C);
  static const dark700 = Color(0xFF2A0F12);
  static const dark600 = Color(0xFF3A1518);

  // ── Neutros claros (light theme) ──────────────────────────
  static const light50 = Color(0xFFFFF9F5);
  static const light100 = Color(0xFFF8EDE8);
  static const light200 = Color(0xFFEDD8D0);
  static const light300 = Color(0xFFD9B8AE);
  static const light400 = Color(0xFFB8928A);
  static const light500 = Color(0xFF8F6860);

  // ── Semânticas ────────────────────────────────────────────
  static const success = Color(0xFF22C55E);
  static const successSurface = Color(0xFF052E16);
  static const warning = Color(0xFFF5A623); // usa amber500
  static const warningSurface = Color(0xFF1C1004);
  static const error = Color(0xFFEF4444);
  static const errorSurface = Color(0xFF1C0404);
  static const info = Color(0xFF3B82F6);
  static const infoSurface = Color(0xFF040C1C);

  // ── Aliases por papel (dark) ──────────────────────────────
  static const darkBackground = dark950;
  static const darkSurface = dark900;
  static const darkSurfaceVariant = dark800;
  static const darkSurfaceContainer = dark700;
  static const darkBorder = Color(0x1AFFF9F5); // white 10%
  static const darkBorderStrong = Color(0x33FFF9F5); // white 20%
  static const darkOnBackground = light50;
  static const darkOnSurface = light100;
  static const darkOnSurfaceMuted = light400;
  static const darkPrimary = orange500;
  static const darkOnPrimary = light50;
  static const darkSecondary = wine700;
  static const darkOnSecondary = light50;
  static const darkAccent = amber500;

  // ── Aliases por papel (light) ─────────────────────────────
  static const lightBackground = light50;
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceVariant = light100;
  static const lightSurfaceContainer = light200;
  static const lightBorder = Color(0x1A3D0C12); // wine800 10%
  static const lightBorderStrong = Color(0x333D0C12); // wine800 20%
  static const lightOnBackground = wine900;
  static const lightOnSurface = wine800;
  static const lightOnSurfaceMuted = light500;
  static const lightPrimary = orange500;
  static const lightOnPrimary = light50;
  static const lightSecondary = wine700;
  static const lightOnSecondary = light50;
  static const lightAccent = amber600;

  // ── Gradientes ────────────────────────────────────────────
  static const LinearGradient flamePrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [orange500, orange600],
  );

  static const LinearGradient flameAmber = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [amber400, orange500],
  );

  static const LinearGradient wineDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [wine800, wine900],
  );

  static const LinearGradient wineDeep = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [wine700, dark900],
  );

  static const LinearGradient headerDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [wine900, wine800, dark800],
    stops: [0.0, 0.55, 1.0],
  );

  // ── Overlay / scrim ───────────────────────────────────────
  static const Color scrimLight = Color(0x80000000);
  static const Color scrimWine = Color(0xCC1A0508);
}
