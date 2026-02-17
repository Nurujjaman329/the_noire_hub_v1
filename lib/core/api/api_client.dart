import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import 'api_exception.dart';
import 'api_interceptor.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late Dio _dio;

  factory ApiClient() => _instance;

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        headers: ApiConstants.headers,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
      ),
    );

    // Interceptors (logging + token etc)
    _dio.interceptors.add(ApiInterceptor());

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) print('REQ → ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint('RES → ${response.statusCode} ${response.requestOptions.path}');
          }
          return handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            debugPrint('ERR → ${error.response?.statusCode} ${error.requestOptions.path}');
          }
          return handler.next(error);
        },
      ),
    );
  }

  Dio get dio => _dio;

  // ====================== GET ======================
  Future<Response> get(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ====================== POST JSON ======================
  Future<Response> postJson(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ====================== POST FormData ======================
  Future<Response> postFormData(
      String path, {
        required FormData data,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        options: options ?? Options(contentType: 'multipart/form-data'),
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ====================== PUT ======================
  Future<Response> put(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ====================== PATCH ======================
  // ====================== PATCH ======================
  Future<Response> patch(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      // ✅ IMPROVEMENT: Automatically set contentType if data is FormData
      if (data is FormData) {
        options ??= Options();
        options.contentType = 'multipart/form-data';
      }

      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Add this inside your ApiClient class
  Future<Response> patchFormData(
      String path, {
        required FormData data,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      return await _dio.patch(
        path,
        data: data,
        // Force multipart/form-data content type
        options: options ?? Options(contentType: 'multipart/form-data'),
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ====================== DELETE ======================
  Future<Response> delete(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ====================== Error Handling ======================
  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException("Connection timed out. Please check your internet.");

      case DioExceptionType.connectionError:
        return NoInternetException("Unable to connect to the server. Please check your data or Wi-Fi.");

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;

        // 1. Extract the custom message from the backend JSON body
        // Backends usually send: {"message": "Email already taken"} or {"error": "..."}
        String? serverMessage;
        if (error.response?.data != null && error.response?.data is Map) {
          serverMessage = error.response?.data['message']?.toString() ??
              error.response?.data['error']?.toString();
        }

        // 2. Fallback to statusMessage ("Bad Request") if JSON is empty
        final finalMessage = serverMessage ?? error.response?.statusMessage ?? 'Server error occurred';

        debugPrint('❌ API Error [$statusCode]: $finalMessage');
        return ServerException(finalMessage, statusCode, error.message);

      case DioExceptionType.cancel:
        return UnknownException('Request was cancelled');

      case DioExceptionType.badCertificate:
        return ServerException('Security certificate validation failed', null, error.message);

      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          return NoInternetException("No internet connection detected.");
        }
        return UnknownException(error.message ?? "An unexpected error occurred");

      }
  }
}
