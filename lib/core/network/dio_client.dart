import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/secure_storage_service.dart';
import '../errors/exceptions.dart';
import 'api_interceptors.dart';

/// Provider for raw Dio, useful for basic queries
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.lumierebeauty.com/v1', // Mock Base URL (can be customized via environment config)
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      contentType: 'application/json',
    ),
  );

  final secureStorage = ref.watch(secureStorageServiceProvider);
  dio.interceptors.add(AuthInterceptor(secureStorage, dio));
  dio.interceptors.add(LoggingInterceptor());

  return dio;
});

/// Provider for custom DioClient
final dioClientProvider = Provider<DioClient>((ref) {
  final dio = ref.watch(dioProvider);
  return DioClient(dio);
});

/// DioClient acts as a clean wrapper around Dio, enforcing custom global error mappings.
class DioClient {
  final Dio _dio;

  DioClient(this._dio);

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

  Future<Response> post(
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

  CustomException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException('Connection timeout. Please check your internet.');
      case DioExceptionType.badResponse:
        final status = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'Server error occurred.';
        if (status == 400) {
          return ValidationException(message);
        } else if (status == 401 || status == 403) {
          return AuthException(message, status);
        } else {
          return ServerException(message, status);
        }
      case DioExceptionType.cancel:
        return const CustomException('Request was cancelled.');
      case DioExceptionType.badCertificate:
        return const CustomException('Security certificate validation failed.');
      case DioExceptionType.unknown:
      default:
        return const CustomException('An unexpected network error occurred.');
    }
  }
}