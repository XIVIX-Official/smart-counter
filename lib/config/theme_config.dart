import 'package:flutter/material.dart';

class ThemeConfig {
  // Singleton instance
  static final ThemeConfig _instance = ThemeConfig._internal();
  factory ThemeConfig() => _instance;
  ThemeConfig._internal();

  // Colors
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color secondaryColor = Color(0xFF03A9F4);
  static const Color accentColor = Color(0xFF00BCD4);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFE53935);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color textColor = Color(0xFF212121);
  static const Color secondaryTextColor = Color(0xFF757575);

  // Text Styles
  static const String fontFamily = 'Poppins';

  static const TextStyle headingLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: textColor,
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textColor,
  );

  static const TextStyle headingSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textColor,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textColor,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textColor,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: secondaryTextColor,
  );

  // Theme Data
  ThemeData get lightTheme => ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        fontFamily: fontFamily,
        textTheme: const TextTheme(
          displayLarge: headingLarge,
          displayMedium: headingMedium,
          displaySmall: headingSmall,
          bodyLarge: bodyLarge,
          bodyMedium: bodyMedium,
          bodySmall: bodySmall,
        ),
        colorScheme: const ColorScheme(
          primary: primaryColor,
          secondary: secondaryColor,
          surface: surfaceColor,
          background: backgroundColor,
          error: errorColor,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: textColor,
          onBackground: textColor,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            textStyle: bodyMedium,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surfaceColor,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: secondaryTextColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: secondaryTextColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: errorColor),
          ),
        ),
        cardTheme: CardTheme(
          color: surfaceColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

  // Dark Theme (if needed)
  ThemeData get darkTheme => ThemeData.dark().copyWith(
        // Add dark theme customizations here
      );
}