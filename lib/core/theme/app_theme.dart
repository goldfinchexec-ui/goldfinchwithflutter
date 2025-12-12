
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate900 = Color(0xFF0F172A);

  static const Color primary = slate900;
  static const Color background = slate50;
  static const Color cardColor = Colors.white;
  static const Color borderColor = slate200;

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: slate900,
        surface: background,
        onSurface: slate900,
      ),
      textTheme: GoogleFonts.interTextTheme().apply(
        bodyColor: slate900,
        displayColor: slate900,
      ),
      // cardTheme: CardTheme(
      //   color: cardColor,
      //   elevation: 0,
      //   shape: RoundedRectangleBorder(
      //     side: BorderSide(color: borderColor, width: 1),
      //     borderRadius: BorderRadius.circular(8.0),
      //   ),
      //   margin: EdgeInsets.zero,
      // ),
      dividerTheme: const DividerThemeData(
        color: borderColor,
        thickness: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(8.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: slate900, width: 1.5),
          borderRadius: BorderRadius.circular(8.0),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
           foregroundColor: slate500,
        )
      )
    );
  }

  static TextStyle get headingStyle => GoogleFonts.inter(
    fontWeight: FontWeight.bold,
    color: slate900,
  );

  static TextStyle get labelStyle => GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    color: slate500,
  );
}
