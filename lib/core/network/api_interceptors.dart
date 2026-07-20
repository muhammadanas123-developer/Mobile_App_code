import 'dart:developer' as dev;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../storage/secure_storage_service.dart';

/// AuthInterceptor injects access tokens in request headers and handles 401 token refresh loops.
class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;
  final Dio _dio;

  AuthInterceptor(this._secureStorage, this._dio);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _secureStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return super.onRequest(options, handler);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if error is 401 Unauthorized
    if (err.response?.statusCode == 401) {
      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken != null) {
        try {
          // Perform refreshing token flow
          final refreshResponse = await _dio.post(
            '/auth/refresh',
            data: {'refresh_token': refreshToken},
            options: Options(headers: {'bypass-interceptor': 'true'}),
          );

          if (refreshResponse.statusCode == 200) {
            final newAccessToken = refreshResponse.data['access_token'];
            final newRefreshToken = refreshResponse.data['refresh_token'];

            await _secureStorage.saveTokens(
              accessToken: newAccessToken,
              refreshToken: newRefreshToken,
            );

            // Re-try the original failed request
            final options = err.requestOptions;
            options.headers['Authorization'] = 'Bearer $newAccessToken';

            final response = await _dio.fetch(options);
            return handler.resolve(response);
          }
        } catch (e) {
          // If refresh fails, clear tokens (logout) and let error pass
          await _secureStorage.clearTokens();
        }
      }
    }
    return super.onError(err, handler);
  }
}

/// LoggingInterceptor displays readable network traffic logs only in debug mode.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      dev.log('--> ${options.method.toUpperCase()} ${options.baseUrl}${options.path}');
      if (options.headers.isNotEmpty) {
        dev.log('Headers: ${options.headers}');
      }
      if (options.data != null) {
        dev.log('Request Body: ${options.data}');
      }
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      dev.log('<-- ${response.statusCode} ${response.requestOptions.method} ${response.requestOptions.path}');
      dev.log('Response Body: ${response.data}');
    }
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      dev.log('<-- ERROR: ${err.message}');
      if (err.response != null) {
        dev.log('Status Code: ${err.response?.statusCode}');
        dev.log('Error Data: ${err.response?.data}');
      }
    }
    return super.onError(err, handler);
  }
}