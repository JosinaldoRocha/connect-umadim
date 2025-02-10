import 'package:connect_umadim_app/app/core/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText {
  static TextTheme text() {
    return TextTheme(
      titleLarge: GoogleFonts.poppins(
        fontSize: 28,
        color: AppColor.tertiary,
      ),
      titleMedium: GoogleFonts.poppins(
        fontSize: 24,
        color: AppColor.tertiary,
      ),
      titleSmall: GoogleFonts.poppins(
        fontSize: 16,
        color: AppColor.tertiary,
      ),
      bodyLarge: GoogleFonts.roboto(
        fontSize: 18,
        color: AppColor.tertiary,
      ),
      bodyMedium: GoogleFonts.roboto(
        fontSize: 16,
        color: AppColor.tertiary,
      ),
      bodySmall: GoogleFonts.roboto(
        fontSize: 12,
        color: AppColor.tertiary,
      ),
    );
  }
}
