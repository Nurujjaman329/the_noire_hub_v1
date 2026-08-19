class JsonParseUtils {
  JsonParseUtils._();

  static String asString(dynamic value, [String fallback = '']) {
    if (value == null) return fallback;
    return value.toString();
  }

  static double asDouble(dynamic value, [double fallback = 0.0]) {
    if (value == null) return fallback;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? fallback;
    return fallback;
  }

  static int asInt(dynamic value, [int fallback = 0]) {
    if (value == null) return fallback;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  static bool asBool(dynamic value, [bool fallback = false]) {
    if (value == null) return fallback;
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.toLowerCase();
      if (normalized == 'true') return true;
      if (normalized == 'false') return false;
    }
    return fallback;
  }

  static String asId(Map<String, dynamic> json) {
    return asString(json['id'] ?? json['_id']);
  }

  static List<double> asCoordinateList(dynamic raw) {
    if (raw is! List) return const [];

    return raw.map((entry) {
      if (entry is num) return entry.toDouble();
      if (entry is String) return double.tryParse(entry) ?? 0.0;
      return 0.0;
    }).toList();
  }
}
