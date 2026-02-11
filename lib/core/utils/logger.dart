import 'package:flutter/material.dart';

class Logger {
  static const bool _debugMode = true;

  static void log(String message, {String tag = 'APP'}) {
    if (_debugMode) {
      debugPrint('[LOG - $tag]: $message');
    }
  }

  static void logInfo(String message, {String tag = 'INFO'}) {
    if (_debugMode) {
      debugPrint('[INFO - $tag]: $message');
    }
  }

  static void logWarning(String message, {String tag = 'WARNING'}) {
    if (_debugMode) {
      debugPrint('[WARN - $tag]: $message');
    }
  }

  static void logError(String message, {String tag = 'ERROR'}) {
    if (_debugMode) {
      debugPrint('[ERROR - $tag]: $message');
    }
  }

  static void logDebug(String message, {String tag = 'DEBUG'}) {
    if (_debugMode) {
      debugPrint('[DEBUG - $tag]: $message');
    }
  }

  static void logApiCall(String message) {
    if (_debugMode) {
      debugPrint('[API CALL]: $message');
    }
  }

  static void logRequest(dynamic data) {
    if (_debugMode) {
      debugPrint('[REQUEST]: ${_formatData(data)}');
    }
  }

  static void logResponse(dynamic data) {
    if (_debugMode) {
      debugPrint('[RESPONSE]: ${_formatData(data)}');
    }
  }

  static String _formatData(dynamic data) {
    if (data == null) return 'null';

    if (data is Map || data is List) {
      // For simplicity, just return as string representation
      // In a real app, you might want to use json.encode for pretty debugPrinting
      return data.toString();
    }

    return data.toString();
  }
}