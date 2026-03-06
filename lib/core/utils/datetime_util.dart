import 'package:intl/intl.dart';

class DateTimeUtil {
  /// Converts ISO string to: 31 January 2026
  static String formatDate(String dateString) {
    if (dateString.isEmpty) return "";
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('dd MMMM yyyy').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  /// Converts ISO string to: 10:30 AM
  static String formatTime(String dateString) {
    if (dateString.isEmpty) return "";
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }

  /// Combined format: 31 January 2026, 10:30 AM
  static String formatFullDateTime(String dateString) {
    if (dateString.isEmpty) return "Contact for availability";
    try {
      DateTime dateTime = DateTime.parse(dateString);
      return DateFormat('dd MMMM yyyy  hh:mm a').format(dateTime);
    } catch (e) {
      return dateString;
    }
  }
}