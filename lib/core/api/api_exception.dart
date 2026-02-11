abstract class AppException implements Exception {
  final String message;
  final String? details;

  AppException(this.message, [this.details]);

  @override
  String toString() {
    // Return only the message for the UI
    return message;
  }
}

class ServerException extends AppException {
  final int? statusCode;

  ServerException(super.message, [this.statusCode, super.details]);

  @override
  String toString() {
    // For the UI, we only return the clean message (e.g., "No users found with this email")
    return message;
  }

  /// Use this for your internal debug logging so you still see the full error in the console
  String toDebugString() {
    return 'ServerException ($statusCode): $message${details != null ? ' - $details' : ''}';
  }
}

class NoInternetException extends AppException {
  NoInternetException([String? details])
      : super('No internet connection. Please check your data/Wi-Fi.', details);
}

class TimeoutException extends AppException {
  TimeoutException([String? details])
      : super('Request timeout. The server is taking too long to respond.', details);
}

class ParsingException extends AppException {
  ParsingException([String? details])
      : super('Failed to parse data', details);
}

class CacheException extends AppException {
  CacheException([String? details])
      : super('Cache operation failed', details);
}

class NotFoundException extends AppException {
  NotFoundException([String? details])
      : super('Data not found', details);
}

class UnknownException extends AppException {
  UnknownException([String? details])
      : super('An unknown error occurred', details);
}