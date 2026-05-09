import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get light {
    final base = GoogleFonts.plusJakartaSansTextTheme();
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.coffee,
        secondary: AppColors.accent,
        surface: AppColors.card,
        onPrimary: AppColors.cream,
        onSecondary: Colors.white,
        onSurface: AppColors.coffee,
      ),
      scaffoldBackgroundColor: AppColors.bg,
      textTheme: base.copyWith(
        displayLarge: GoogleFonts.instrumentSerif(
          fontSize: 38,
          color: AppColors.coffee,
          height: 1.0,
          letterSpacing: -0.8,
        ),
        displayMedium: GoogleFonts.instrumentSerif(
          fontSize: 32,
          color: AppColors.coffee,
          height: 1.05,
          letterSpacing: -0.6,
        ),
        displaySmall: GoogleFonts.instrumentSerif(
          fontSize: 28,
          color: AppColors.coffee,
          height: 1.05,
          letterSpacing: -0.4,
        ),
        headlineMedium: GoogleFonts.instrumentSerif(
          fontSize: 22,
          color: AppColors.coffee,
          letterSpacing: -0.2,
        ),
        headlineSmall: GoogleFonts.instrumentSerif(
          fontSize: 18,
          color: AppColors.coffee,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.coffee,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.coffee,
        ),
        titleSmall: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.coffee,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 15,
          color: AppColors.coffee,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          color: AppColors.coffee,
        ),
        bodySmall: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          color: AppColors.muted,
        ),
        labelSmall: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: AppColors.muted,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        foregroundColor: AppColors.coffee,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.card,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.muted,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accent),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      dividerColor: AppColors.line,
      cardColor: AppColors.card,
    );
  }
}
