import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // Primary colors
      primarySwatch: Colors.green,
      primaryColor: AppColors.primaryDark,
      brightness: Brightness.light,

      // Scaffold and background
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.surface,

      // Text themes
      textTheme: _buildTextTheme(),

      // AppBar theme
      appBarTheme: _buildAppBarTheme(),

      // Button themes
      elevatedButtonTheme: _buildElevatedButtonTheme(),
      textButtonTheme: _buildTextButtonTheme(),

      // Input themes
      inputDecorationTheme: _buildInputDecorationTheme(),

      // // Card theme
      // cardTheme: _buildCardTheme(),

      // Bottom navigation theme
      bottomNavigationBarTheme: _buildBottomNavigationBarTheme(),

      // Divider theme
      dividerTheme: _buildDividerTheme(),
      //
      // // Dialog theme
      // dialogTheme: _buildDialogTheme(),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      // Primary colors
      primarySwatch: Colors.green,
      primaryColor: AppColors.primaryDark,
      brightness: Brightness.dark,

      // Scaffold and background
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.primaryDark,

      // Text themes
      textTheme: _buildTextTheme().apply(bodyColor: AppColors.white),

      // AppBar theme
      appBarTheme: _buildAppBarTheme(useDark: true),

      // Button themes
      elevatedButtonTheme: _buildElevatedButtonTheme(darkMode: true),
      textButtonTheme: _buildTextButtonTheme(darkMode: true),

      // Input themes
      inputDecorationTheme: _buildInputDecorationTheme(darkMode: true),

      // Card theme
      // cardTheme: _buildCardTheme(darkMode: true),

      // Bottom navigation theme
      bottomNavigationBarTheme: _buildBottomNavigationBarTheme(darkMode: true),

      // Divider theme
      dividerTheme: _buildDividerTheme(darkMode: true),

      // Dialog theme
      // dialogTheme: _buildDialogTheme(darkMode: true),
    );
  }

  static TextTheme _buildTextTheme() {
    return const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: AppColors.textDisabled,
      ),
    );
  }

  static AppBarTheme _buildAppBarTheme({bool useDark = false}) {
    return AppBarTheme(
      backgroundColor: useDark ? AppColors.primaryDark : AppColors.white,
      foregroundColor: useDark ? AppColors.white : AppColors.textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: useDark ? AppColors.white : AppColors.textPrimary,
      ),
    );
  }

  static ElevatedButtonThemeData _buildElevatedButtonTheme({bool darkMode = false}) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkMode ? AppColors.primary : AppColors.buttonPrimary,
        foregroundColor: darkMode ? AppColors.white : AppColors.onButton,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static TextButtonThemeData _buildTextButtonTheme({bool darkMode = false}) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: darkMode ? AppColors.secondary : AppColors.primary,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ).copyWith(
          color: darkMode ? AppColors.secondary : AppColors.primary,
        ),
      ),
    );
  }

  static InputDecorationTheme _buildInputDecorationTheme({bool darkMode = false}) {
    return InputDecorationTheme(
      filled: true,
      fillColor: darkMode ? AppColors.surfaceVariant : AppColors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: darkMode ? AppColors.divider : AppColors.divider,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: darkMode ? AppColors.divider : AppColors.divider,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: darkMode ? AppColors.secondary : AppColors.primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: AppColors.error,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: AppColors.error,
          width: 2,
        ),
      ),
      hintStyle: TextStyle(
        color: darkMode ? AppColors.textDisabled : AppColors.textHint,
      ),
    );
  }

  static CardTheme _buildCardTheme({bool darkMode = false}) {
    return CardTheme(
      color: darkMode ? AppColors.surfaceVariant : AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: darkMode ? AppColors.divider : AppColors.dividerVariant,
        ),
      ),
      clipBehavior: Clip.antiAlias,
    );
  }

  static BottomNavigationBarThemeData _buildBottomNavigationBarTheme({bool darkMode = false}) {
    return BottomNavigationBarThemeData(
      backgroundColor: darkMode ? AppColors.navigationBackground : AppColors.white,
      selectedItemColor: darkMode ? AppColors.navigationIndicator : AppColors.primary,
      unselectedItemColor: darkMode ? AppColors.navigationInactive : AppColors.textDisabled,
      selectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
      type: BottomNavigationBarType.fixed,
    );
  }

  static DividerThemeData _buildDividerTheme({bool darkMode = false}) {
    return const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
      indent: 0,
      endIndent: 0,
    );
  }

  static DialogTheme _buildDialogTheme({bool darkMode = false}) {
    return DialogTheme(
      backgroundColor: darkMode ? AppColors.surfaceVariant : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: darkMode ? AppColors.divider : AppColors.divider,
        ),
      ),
    );
  }
}