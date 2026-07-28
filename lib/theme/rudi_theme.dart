import 'package:flutter/material.dart';

class RudiTheme {
  RudiTheme._();

  // Общие акценты
  static const Color primary = Color(0xFF7C5CFF);

  // LIGHT
  static const Color lightBackground = Color(0xFFF5F6FA);
  static const Color lightSurface = Color(0xFFFFFFFF);

  // DARK — максимально нейтральная графитовая тема
  static const Color darkBackground = Color(0xFF0F1013);
  static const Color darkSurface = Color(0xFF191A1F);
  static const Color darkSurfaceStrong = Color(0xFF23252B);

  // RUDI — фирменная чёрно-синяя тема
  static const Color rudiBackground = Color(0xFF050711);
  static const Color rudiSurface = Color(0xFF101528);
  static const Color rudiSurfaceStrong = Color(0xFF171D38);
  static const Color rudiPurple = Color(0xFF8B6CFF);
  static const Color rudiBlue = Color(0xFF4388FF);

  // =========================================================
  // LIGHT
  // =========================================================

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ).copyWith(
      surface: lightSurface,
      outlineVariant: const Color(0xFFDADDE7),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: lightBackground,

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xFFE1E3EB),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: primary,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  // =========================================================
  // DARK
  // =========================================================

  static ThemeData get dark {
    const darkPrimary = Color(0xFFB7BAC6);

    const colorScheme = ColorScheme.dark(
      primary: darkPrimary,
      secondary: Color(0xFF9295A0),
      surface: darkSurface,
      primaryContainer: darkSurfaceStrong,
      onPrimary: Color(0xFF15161A),
      onPrimaryContainer: Colors.white,
      outline: Color(0xFF696C75),
      outlineVariant: Color(0xFF303238),
      shadow: Colors.black,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: darkBackground,

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFE1E2E8),
        foregroundColor: Color(0xFF191A1F),
        elevation: 4,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF17181D),
        selectedColor: const Color(0xFF34363D),
        side: const BorderSide(
          color: Color(0xFF393B42),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xFF303238),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: darkPrimary,
            width: 1.5,
          ),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: darkSurfaceStrong,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  // =========================================================
  // RUDI
  // =========================================================

  static ThemeData get rudi {
    const colorScheme = ColorScheme.dark(
      primary: rudiPurple,
      secondary: rudiBlue,
      surface: rudiSurface,
      primaryContainer: rudiSurfaceStrong,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onPrimaryContainer: Color(0xFFF3F0FF),
      outline: Color(0xFF66709A),
      outlineVariant: Color(0xFF29345F),
      shadow: Color(0xFF6C4DFF),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: rudiBackground,

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: rudiPurple,
        foregroundColor: Colors.white,
        elevation: 8,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF0D1223),
        selectedColor: const Color(0xFF493B78),
        side: const BorderSide(
          color: Color(0xFF34416E),
        ),
        checkmarkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: rudiSurface,
        labelStyle: const TextStyle(
          color: Color(0xFFB8BCE0),
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF737B9F),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xFF29345F),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: rudiPurple,
            width: 1.7,
          ),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: rudiSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(
            color: Color(0xFF29345F),
          ),
        ),
      ),

      popupMenuTheme: PopupMenuThemeData(
        color: rudiSurfaceStrong,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: Color(0xFF34416E),
          ),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: rudiSurfaceStrong,
        contentTextStyle: const TextStyle(
          color: Colors.white,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}