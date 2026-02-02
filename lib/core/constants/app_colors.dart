import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary palette based on your UI image
  static const Color primary = Color(0xFFCADA9F);      // The pale yellow/cream in the cards
  // static const Color primary = Color(0xFFF1F0B2);      // The pale yellow/cream in the cards
  static const Color primaryDark = Color(0xFF3B502B);  // The deep olive green background
  static const Color primaryLight = Color(0xFF98B66E); // The lighter wavy lines in the header

  // Extended primary colors
  static const Color primaryVariant = Color(0xFFD9D89C); // Slightly darker cream
  static const Color primaryContainer = Color(0xFFEAE9C8); // Lighter cream container
  static const Color onPrimary = Color(0xFF2D3E2F); // Dark text on primary

  // Secondary colors
  static const Color secondary = Color(0xFFB5B378); // Muted green for subtitles
  static const Color secondaryVariant = Color(0xFFC4C99A); // Lighter muted green
  static const Color onSecondary = Color(0xFF1A1A1A); // Dark text on secondary

  // Background colors
  static const Color background = Color(0xFF3B502B);   // Deep green background
  static const Color surface = Color(0xFFFFFFFF);      // White bottom section
  static const Color surfaceVariant = Color(0xFFFAFAFA); // Light grey surface
  static const Color backgroundLight = Color(0xFFEDEDE0); // Light background alternative
  static const Color white = Colors.white;
  static const Color whiteVariant = Color(0xFFFEFEFE); // Almost white

  // Text colors
  static const Color textPrimary = Color(0xFF1A1A1A);  // Near black for readability on white
  static const Color textOnDark = Color(0xFFF1F0B2);   // Cream text for the dark green header
  static const Color textSecondary = Color(0xFFB5B475); // Muted green for subtitles
  static const Color textDisabled = Color(0xFFA0A0A0); // Greyed out text
  static const Color textHint = Color(0xFFB0B0B0); // Hint text color
  static const Color textOnPrimary = Color(0xFF2D3E2F); // Dark text on primary surfaces

  // Selection Card Colors
  static const Color cardSelected = Color(0xFFF1F0B2); // The cream color for "Vendors/Beauticians"
  static const Color cardUnselected = Color(0xFFEAE9C8); // Lighter cream for unselected cards
  static const Color cardShadow = Color(0x1A000000);   // Subtle shadow for the cards
  static const Color cardBorder = Color(0xFFDAD9B2); // Border color for cards
  static const Color geryColor = Colors.grey;   // Subtle shadow for the cards

  // Status colors
  static const Color success = Color(0xFF4CAF50); // Success state
  static const Color warning = Color(0xFFFFC107); // Warning state
  static const Color info = Color(0xFF2196F3); // Info state
  static const Color error = Color(0xFFBA1A1A); // Error state
  static const Color errorContainer = Color(0xFFFFDAD6); // Light red container
  static const Color onError = Color(0xFFFFFFFF); // White text on error

  // Navigation and UI elements
  static const Color navigationBackground = Color(0xFFF8F8F0); // Background for bottom nav
  static const Color navigationIndicator = Color(0xFF3B502B); // Selected indicator
  static const Color navigationInactive = Color(0xFFA0A0A0); // Inactive nav items
  static const Color divider = Color(0xFFEEEEEE); // Divider lines
  static const Color dividerVariant = Color(0xFFDDDDDD); // Alternative divider
  static const Color chipActive = Color(0xFFC4C99A); // Active filter chips
  static const Color chipInactive = Color(0xFFEAE9C8); // Inactive filter chips

  // Button colors
  static const Color buttonPrimary = Color(0xFF3B502B); // Primary button
  static const Color buttonSecondary = Color(0xFFF1F0B2); // Secondary button
  static const Color buttonDisabled = Color(0xFFCCCCCC); // Disabled button
  static const Color onButton = Color(0xFFFFFFFF); // Text on buttons

  // Icon colors
  static const Color iconPrimary = Color(0xFF3B502B); // Primary icons
  static const Color iconSecondary = Color(0xFFB5B475); // Secondary icons
  static const Color iconOnSurface = Color(0xFF666666); // Icons on surface

  // Shimmer colors
  static Color shimmerBase = Colors.grey[300]!;
  static Color shimmerHighlight = Colors.grey[100]!;

  // Functional colors
  static const Color transparent = Colors.transparent;
}