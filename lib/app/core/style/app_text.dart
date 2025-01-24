import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText {
  static TextTheme text() {
    return TextTheme(
      titleLarge: GoogleFonts.poppins(fontSize: 28),
      titleMedium: GoogleFonts.poppins(fontSize: 24),
      titleSmall: GoogleFonts.poppins(fontSize: 16),
      bodyLarge: GoogleFonts.roboto(),
      bodyMedium: GoogleFonts.roboto(),
      bodySmall: GoogleFonts.roboto(fontSize: 12),
    );
  }
}
