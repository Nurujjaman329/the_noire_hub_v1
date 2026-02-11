import 'package:dio/dio.dart';
import '../services/cache_service.dart';
import '../storage/local_storage.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 1. Get token directly from your static CacheService
    final token = CacheService.token;

    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Standard headers
    options.headers['Accept'] = 'application/json';
    // You can also add dynamic headers here, like current userId if needed
    // options.headers['X-User-ID'] = CacheService.userId;

    super.onRequest(options, handler);
  }
}