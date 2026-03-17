import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Temas Material 3 do Conecta UMADIM
/// Dois temas: dark (padrão) e light
abstract class AppTheme {
  // ── Tema escuro ───────────────────────────────────────────
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: _darkColorScheme,
        scaffoldBackgroundColor: AppColor.darkBackground,
        textTheme: _textTheme(Brightness.dark),
        appBarTheme: _appBarTheme(Brightness.dark),
        cardTheme: _cardTheme(Brightness.dark),
        inputDecorationTheme: _inputTheme(Brightness.dark),
        elevatedButtonTheme: _elevatedButtonTheme(Brightness.dark),
        outlinedButtonTheme: _outlinedButtonTheme(Brightness.dark),
        textButtonTheme: _textButtonTheme(Brightness.dark),
        bottomNavigationBarTheme: _bottomNavTheme(Brightness.dark),
        navigationBarTheme: _navigationBarTheme(Brightness.dark),
        dividerTheme: _dividerTheme(Brightness.dark),
        chipTheme: _chipTheme(Brightness.dark),
        iconTheme: const IconThemeData(color: AppColor.darkOnSurface),
        dialogTheme: _dialogTheme(Brightness.dark),
        snackBarTheme: _snackBarTheme(Brightness.dark),
        tabBarTheme: _tabBarTheme(Brightness.dark),
        floatingActionButtonTheme: _fabTheme(),
        pageTransitionsTheme: _pageTransitions(),
      );

  // ── Tema claro ────────────────────────────────────────────
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: _lightColorScheme,
        scaffoldBackgroundColor: AppColor.lightBackground,
        textTheme: _textTheme(Brightness.light),
        appBarTheme: _appBarTheme(Brightness.light),
        cardTheme: _cardTheme(Brightness.light),
        inputDecorationTheme: _inputTheme(Brightness.light),
        elevatedButtonTheme: _elevatedButtonTheme(Brightness.light),
        outlinedButtonTheme: _outlinedButtonTheme(Brightness.light),
        textButtonTheme: _textButtonTheme(Brightness.light),
        bottomNavigationBarTheme: _bottomNavTheme(Brightness.light),
        navigationBarTheme: _navigationBarTheme(Brightness.light),
        dividerTheme: _dividerTheme(Brightness.light),
        chipTheme: _chipTheme(Brightness.light),
        iconTheme: const IconThemeData(color: AppColor.lightOnSurface),
        dialogTheme: _dialogTheme(Brightness.light),
        snackBarTheme: _snackBarTheme(Brightness.light),
        tabBarTheme: _tabBarTheme(Brightness.light),
        floatingActionButtonTheme: _fabTheme(),
        pageTransitionsTheme: _pageTransitions(),
      );

  // ── ColorSchemes ──────────────────────────────────────────
  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColor.orange500,
    onPrimary: AppColor.light50,
    primaryContainer: AppColor.wine700,
    onPrimaryContainer: AppColor.orange200,
    secondary: AppColor.wine600,
    onSecondary: AppColor.light50,
    secondaryContainer: AppColor.wine800,
    onSecondaryContainer: AppColor.light200,
    tertiary: AppColor.amber500,
    onTertiary: AppColor.wine900,
    tertiaryContainer: AppColor.wine800,
    onTertiaryContainer: AppColor.amber300,
    error: AppColor.error,
    onError: AppColor.light50,
    errorContainer: AppColor.errorSurface,
    onErrorContainer: AppColor.error,
    surface: AppColor.darkSurface,
    onSurface: AppColor.darkOnSurface,
    surfaceContainerHighest: AppColor.darkSurfaceContainer,
    onSurfaceVariant: AppColor.darkOnSurfaceMuted,
    outline: AppColor.darkBorder,
    outlineVariant: AppColor.darkBorderStrong,
    shadow: AppColor.wine950,
    scrim: AppColor.scrimWine,
    inverseSurface: AppColor.light100,
    onInverseSurface: AppColor.wine900,
    inversePrimary: AppColor.orange600,
  );

  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColor.orange500,
    onPrimary: AppColor.light50,
    primaryContainer: AppColor.orange100,
    onPrimaryContainer: AppColor.orange600,
    secondary: AppColor.wine600,
    onSecondary: AppColor.light50,
    secondaryContainer: AppColor.light200,
    onSecondaryContainer: AppColor.wine700,
    tertiary: AppColor.amber600,
    onTertiary: AppColor.light50,
    tertiaryContainer: AppColor.amber100,
    onTertiaryContainer: AppColor.amber600,
    error: AppColor.error,
    onError: AppColor.light50,
    errorContainer: Color(0xFFFFEDED),
    onErrorContainer: AppColor.error,
    surface: AppColor.lightSurface,
    onSurface: AppColor.lightOnSurface,
    surfaceContainerHighest: AppColor.lightSurfaceContainer,
    onSurfaceVariant: AppColor.lightOnSurfaceMuted,
    outline: AppColor.lightBorder,
    outlineVariant: AppColor.lightBorderStrong,
    shadow: Color(0x1A3D0C12),
    scrim: AppColor.scrimLight,
    inverseSurface: AppColor.wine800,
    onInverseSurface: AppColor.light50,
    inversePrimary: AppColor.orange300,
  );

  // ── TextTheme ─────────────────────────────────────────────
  static TextTheme _textTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final onBg =
        isDark ? AppColor.darkOnBackground : AppColor.lightOnBackground;
    final onSurface = isDark ? AppColor.darkOnSurface : AppColor.lightOnSurface;
    final muted =
        isDark ? AppColor.darkOnSurfaceMuted : AppColor.lightOnSurfaceMuted;

    final syne = GoogleFonts.syne();
    final inter = GoogleFonts.inter();

    return TextTheme(
      displayLarge: syne.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          color: onBg),
      displayMedium: syne.copyWith(
          fontSize: 26,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          color: onBg),
      displaySmall: syne.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
          color: onBg),
      headlineLarge:
          syne.copyWith(fontSize: 20, fontWeight: FontWeight.w700, color: onBg),
      headlineMedium:
          syne.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: onBg),
      headlineSmall:
          syne.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: onBg),
      titleLarge: inter.copyWith(
          fontSize: 16, fontWeight: FontWeight.w600, color: onBg),
      titleMedium: inter.copyWith(
          fontSize: 14, fontWeight: FontWeight.w500, color: onSurface),
      titleSmall: inter.copyWith(
          fontSize: 13, fontWeight: FontWeight.w500, color: onSurface),
      bodyLarge: inter.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.6,
          color: onSurface),
      bodyMedium: inter.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.55,
          color: onSurface),
      bodySmall: inter.copyWith(
          fontSize: 13, fontWeight: FontWeight.w400, height: 1.5, color: muted),
      labelLarge: inter.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          color: onBg),
      labelMedium: inter.copyWith(
          fontSize: 12, fontWeight: FontWeight.w500, color: muted),
      labelSmall: inter.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.08,
          color: muted),
    );
  }

  // ── AppBar ────────────────────────────────────────────────
  static AppBarTheme _appBarTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor:
          isDark ? AppColor.darkBackground : AppColor.lightBackground,
      foregroundColor:
          isDark ? AppColor.darkOnBackground : AppColor.lightOnBackground,
      titleTextStyle: GoogleFonts.syne(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: isDark ? AppColor.darkOnBackground : AppColor.lightOnBackground,
      ),
      iconTheme: IconThemeData(
        color: isDark ? AppColor.darkOnBackground : AppColor.lightOnBackground,
        size: 24,
      ),
      systemOverlayStyle: isDark
          ? SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: AppColor.darkBackground,
            )
          : SystemUiOverlayStyle.dark.copyWith(
              statusBarColor: Colors.transparent,
              systemNavigationBarColor: AppColor.lightBackground,
            ),
    );
  }

  // ── Card ──────────────────────────────────────────────────
  static CardThemeData _cardTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return CardThemeData(
      elevation: 0,
      color: isDark ? AppColor.darkSurface : AppColor.lightSurface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          width: 1,
        ),
      ),
      margin: EdgeInsets.zero,
    );
  }

  // ── Input ─────────────────────────────────────────────────
  static InputDecorationTheme _inputTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final fill = isDark
        ? AppColor.darkOnBackground.withOpacity(0.05)
        : AppColor.lightOnBackground.withOpacity(0.04);
    final border = isDark ? AppColor.darkBorder : AppColor.lightBorder;
    final borderFocus = AppColor.orange500;
    final borderError = AppColor.error;
    final hintColor =
        isDark ? AppColor.darkOnSurfaceMuted : AppColor.lightOnSurfaceMuted;

    final borderShape = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: border, width: 1.5),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: borderFocus, width: 1.5),
    );
    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: borderError, width: 1.5),
    );

    return InputDecorationTheme(
      filled: true,
      fillColor: fill,
      hintStyle: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: hintColor,
      ),
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: hintColor,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: borderShape,
      enabledBorder: borderShape,
      focusedBorder: focusedBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: errorBorder,
      errorStyle: GoogleFonts.inter(fontSize: 12, color: borderError),
    );
  }

  // ── Elevated Button ───────────────────────────────────────
  static ElevatedButtonThemeData _elevatedButtonTheme(Brightness brightness) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.orange500,
        foregroundColor: AppColor.light50,
        disabledBackgroundColor: AppColor.orange500.withOpacity(0.38),
        disabledForegroundColor: AppColor.light50.withOpacity(0.5),
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    );
  }

  // ── Outlined Button ───────────────────────────────────────
  static OutlinedButtonThemeData _outlinedButtonTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColor.orange500,
        side: const BorderSide(color: AppColor.orange500, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.syne(fontSize: 15, fontWeight: FontWeight.w600),
        backgroundColor: isDark
            ? AppColor.orange500.withOpacity(0.0)
            : AppColor.orange500.withOpacity(0.0),
      ),
    );
  }

  // ── Text Button ───────────────────────────────────────────
  static TextButtonThemeData _textButtonTheme(Brightness brightness) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColor.orange500,
        textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  // ── Bottom Navigation Bar ─────────────────────────────────
  static BottomNavigationBarThemeData _bottomNavTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return BottomNavigationBarThemeData(
      backgroundColor: isDark ? AppColor.darkSurface : AppColor.lightSurface,
      selectedItemColor: AppColor.orange500,
      unselectedItemColor:
          isDark ? AppColor.darkOnSurfaceMuted : AppColor.lightOnSurfaceMuted,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle:
          GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
      unselectedLabelStyle:
          GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w400),
    );
  }

  // ── Navigation Bar (M3) ───────────────────────────────────
  static NavigationBarThemeData _navigationBarTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return NavigationBarThemeData(
      backgroundColor: isDark ? AppColor.darkSurface : AppColor.lightSurface,
      indicatorColor: AppColor.orange500.withOpacity(0.15),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: AppColor.orange500, size: 24);
        }
        return IconThemeData(
          color: isDark
              ? AppColor.darkOnSurfaceMuted
              : AppColor.lightOnSurfaceMuted,
          size: 24,
        );
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final active = states.contains(WidgetState.selected);
        return GoogleFonts.inter(
          fontSize: 11,
          fontWeight: active ? FontWeight.w600 : FontWeight.w400,
          color: active
              ? AppColor.orange500
              : (isDark
                  ? AppColor.darkOnSurfaceMuted
                  : AppColor.lightOnSurfaceMuted),
        );
      }),
      elevation: 0,
      height: 68,
    );
  }

  // ── Divider ───────────────────────────────────────────────
  static DividerThemeData _dividerTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return DividerThemeData(
      color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
      thickness: 1,
      space: 1,
    );
  }

  // ── Chip ──────────────────────────────────────────────────
  static ChipThemeData _chipTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return ChipThemeData(
      backgroundColor:
          isDark ? AppColor.darkSurfaceVariant : AppColor.lightSurfaceVariant,
      selectedColor: AppColor.orange500.withOpacity(0.18),
      labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isDark ? AppColor.darkBorder : AppColor.lightBorder,
          width: 1,
        ),
      ),
      elevation: 0,
    );
  }

  // ── Dialog ────────────────────────────────────────────────
  static DialogThemeData _dialogTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return DialogThemeData(
      backgroundColor: isDark ? AppColor.darkSurface : AppColor.lightSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titleTextStyle: GoogleFonts.syne(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: isDark ? AppColor.darkOnBackground : AppColor.lightOnBackground,
      ),
      contentTextStyle: GoogleFonts.inter(
        fontSize: 14,
        height: 1.55,
        color: isDark ? AppColor.darkOnSurface : AppColor.lightOnSurface,
      ),
    );
  }

  // ── SnackBar ──────────────────────────────────────────────
  static SnackBarThemeData _snackBarTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return SnackBarThemeData(
      backgroundColor:
          isDark ? AppColor.darkSurfaceContainer : AppColor.wine800,
      contentTextStyle: GoogleFonts.inter(
        fontSize: 14,
        color: AppColor.light50,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
    );
  }

  // ── TabBar ────────────────────────────────────────────────
  static TabBarThemeData _tabBarTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return TabBarThemeData(
      labelColor: AppColor.orange500,
      unselectedLabelColor:
          isDark ? AppColor.darkOnSurfaceMuted : AppColor.lightOnSurfaceMuted,
      indicatorColor: AppColor.orange500,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w600),
      unselectedLabelStyle:
          GoogleFonts.syne(fontSize: 14, fontWeight: FontWeight.w400),
      dividerColor: isDark ? AppColor.darkBorder : AppColor.lightBorder,
    );
  }

  // ── FAB ───────────────────────────────────────────────────
  static FloatingActionButtonThemeData _fabTheme() {
    return const FloatingActionButtonThemeData(
      backgroundColor: AppColor.orange500,
      foregroundColor: AppColor.light50,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    );
  }

  // ── Page Transitions ──────────────────────────────────────
  static PageTransitionsTheme _pageTransitions() {
    return const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    );
  }
}
