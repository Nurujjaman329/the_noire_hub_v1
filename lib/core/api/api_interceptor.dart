import 'package:dio/dio.dart';
import '../storage/local_storage.dart';
import '../utils/logger.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = LocalStorage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    Logger.logApiCall('${options.method} ${options.uri}');
    Logger.logRequest(options.data);

    super.onRequest(options, handler);
  }
}

