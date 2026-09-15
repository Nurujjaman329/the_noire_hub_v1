import 'package:the_noire_hub_v1/core/constants/app_constants.dart';

/// Pure helpers for booking tip UX — unit-testable without widgets.
class BookingTipHelper {
  BookingTipHelper._();

  static double tipPercent(double subtotal, double percent) =>
      AppConstants.roundMoney(subtotal * percent);

  /// Parse custom tip field. Empty => 0 (no tip). Invalid => null.
  static double? parseCustomTip(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return 0.0;
    final value = double.tryParse(text);
    if (value == null) return null;
    if (value < 0) return null;
    return AppConstants.roundMoney(value);
  }

  static bool isNoTip(double tip) => tip <= 0;

  static bool matchesAmount(double tip, double target) =>
      (tip - target).abs() < 0.01;

  static bool isCustomTip({
    required double tip,
    required double tip5,
    required double tip10,
    required double tip15,
  }) {
    if (tip <= 0) return false;
    return !matchesAmount(tip, tip5) &&
        !matchesAmount(tip, tip10) &&
        !matchesAmount(tip, tip15);
  }

  static String statusMessage(double tip) {
    if (tip > 0) {
      return 'Selected \$${tip.toStringAsFixed(2)} — included in total. Change anytime.';
    }
    return 'Skip if you want — just tap Pay Now. Or pick a tip below.';
  }
}
