
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  // Private constructor to prevent instantiation
  AppSnackbar._();

  /// Show a custom snackbar
  static void show({
    required String title,
    required String message,
    Color backgroundColor = const Color(0xFF1D3826),
    Color textColor = Colors.white,
    IconData? icon,
    SnackPosition position = SnackPosition.TOP,
    Duration duration = const Duration(seconds: 2),
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: backgroundColor,
      colorText: textColor,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: duration,
      icon: icon != null ? Icon(icon, color: textColor) : null,
      animationDuration: const Duration(milliseconds: 400),
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      snackStyle: SnackStyle.FLOATING,
    );
  }

  /// Predefined success snackbar
  static void success(String message, {String title = "Success"}) {
    show(
      title: title,
      message: message,
      backgroundColor: const Color(0xFF1D3826), // brand color
      icon: Icons.check_circle_outline,
    );
  }

  /// Predefined error snackbar
  static void error(String message, {String title = "Error", SnackPosition snackPosition = SnackPosition.BOTTOM}) {
    show(
      title: title,
      message: message,
      backgroundColor: Colors.redAccent,
      icon: Icons.error_outline,
    );
  }

  /// Predefined info snackbar
  static void info(String message, {String title = "Info"}) {
    show(
      title: title,
      message: message,
      backgroundColor: const Color(0xFFB5B475),
      icon: Icons.info_outline,
    );
  }
}
