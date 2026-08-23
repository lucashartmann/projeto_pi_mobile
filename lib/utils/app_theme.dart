import 'package:flutter/material.dart';

class AppColors {
  // Cores principais
  static const Color textColor = Color(0xFFFFFFFF);
  static const Color precoColor = Color(0xFF0B5507);
  static const Color backgroundCustom = Color(0xFF414141);
  static const Color backgroundClaro = Color(0xFFF8F8F8);
  static const Color backgroundEscuro = Color.fromRGBO(65, 65, 65, 0.7);
  static const Color backgroundNav = Color.fromRGBO(65, 65, 65, 0.7);
  static const Color hoverColor = Color(0xFFD4AF37);
  static const Color hoverSoftColor = Color.fromRGBO(212, 175, 55, 0.12);
  static const Color textAlternative = Color(0xFF000000);
  static const Color shadowColor = Color(0xFF2B2121);

  // Modo noturno
  static const Color darkPrecoColor = Color(0xFF1EB316);
  static const Color darkBackgroundClaro = Color.fromRGBO(65, 65, 65, 0.7);
  static const Color darkBackgroundEscuro = Color(0xFFF8F8F8);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkTextColor = Color(0xFFFFFFFF);
  static const Color darkBackgroundNav = Color.fromRGBO(36, 30, 30, 0.92);
  static const Color darkTextAlternative = Color(0xFFFFFFFF);
}

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AppColors.backgroundCustom,
        secondary: AppColors.hoverColor,
        surface: AppColors.backgroundClaro,
        error: Colors.red,
      ),
      scaffoldBackgroundColor: AppColors.backgroundClaro,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundNav,
        foregroundColor: AppColors.textColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.textColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.textAlternative,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: AppColors.textAlternative,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: AppColors.textAlternative,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textAlternative,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: AppColors.textAlternative,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: AppColors.textAlternative,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(color: AppColors.textAlternative, fontSize: 16),
        bodyMedium: TextStyle(color: AppColors.textAlternative, fontSize: 14),
        bodySmall: TextStyle(color: AppColors.textAlternative, fontSize: 12),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.backgroundEscuro,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.backgroundEscuro,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.hoverColor, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.textAlternative),
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.backgroundCustom,
          foregroundColor: AppColors.textColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 4,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.backgroundCustom,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(8),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        titleTextStyle: TextStyle(
          color: AppColors.textAlternative,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        subtitleTextStyle: TextStyle(color: Colors.grey, fontSize: 14),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.backgroundNav,
        selectedItemColor: AppColors.hoverColor,
        unselectedItemColor: Colors.grey,
        elevation: 8,
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.darkBackground,
        secondary: AppColors.hoverColor,
        surface: AppColors.darkBackgroundClaro,
        error: Colors.red,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackgroundNav,
        foregroundColor: AppColors.darkTextColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.darkTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.darkTextAlternative,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: AppColors.darkTextAlternative,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: AppColors.darkTextAlternative,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: AppColors.darkTextAlternative,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: AppColors.darkTextAlternative,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: AppColors.darkTextAlternative,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: AppColors.darkTextAlternative,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: AppColors.darkTextAlternative,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          color: AppColors.darkTextAlternative,
          fontSize: 12,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkBackgroundEscuro,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.darkBackgroundNav,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.darkBackgroundNav,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.hoverColor, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.darkTextAlternative),
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.backgroundCustom,
          foregroundColor: AppColors.darkTextColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 4,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.hoverColor,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkBackgroundClaro,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(8),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        titleTextStyle: TextStyle(
          color: AppColors.darkTextAlternative,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        subtitleTextStyle: TextStyle(color: Colors.grey, fontSize: 14),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkBackgroundNav,
        selectedItemColor: AppColors.hoverColor,
        unselectedItemColor: Colors.grey,
        elevation: 8,
      ),
    );
  }
}
