import '../constants/api_constants.dart';

extension ImageUrlFormatter on String? {
  String get toFullUrl {
    if (this == null || this!.isEmpty) {
      // Useful for testing to see if images are actually missing
      return "https://ui-avatars.com/api/?name=No+Image";
    }

    if (this!.startsWith('http')) {
      return this!;
    }

    final path = this!.startsWith('/') ? this! : '/$this';
    return '${ApiConstants.baseImageUrl}$path';
  }
}