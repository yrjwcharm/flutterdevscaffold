import 'package:dio/dio.dart';
import 'package:flutterdevscaffold/app/network/api_exception.dart';
import 'package:flutterdevscaffold/app/network/api_response.dart';
import 'package:flutterdevscaffold/app/network/env_config.dart';
import 'package:flutterdevscaffold/app/network/interceptors/auth_interceptor.dart';
import 'package:flutterdevscaffold/app/network/interceptors/refresh_token_interceptor.dart';
import 'package:flutterdevscaffold/app/network/interceptors/retry_interceptor.dart';
import 'package:flutterdevscaffold/app/network/request_queue.dart';

class HttpClient {
  static final HttpClient _instance = HttpClient._internal();
  late final Dio dio;

  factory HttpClient() => _instance;

  HttpClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    _init();
  }

  void _init() {
    dio.interceptors.addAll([
      AuthInterceptor(),
      RefreshTokenInterceptor(dio),
      RetryInterceptor(),
      LogInterceptor(),
    ]);
  }

  Future<T> get<T>(
    String url, {
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
    required T Function(dynamic json) parser,
  }) async {
    try {
      final key = url + (params?.toString() ?? '');
      final token = RequestQueue.getToken(key);

      final response = await dio.get(
        url,
        queryParameters: params,
        cancelToken: cancelToken ?? token,
      );

      RequestQueue.remove(key);

      final result = ApiResponse<T>.fromJson(response.data, parser);

      if (!result.success) {
        throw ApiException(code: result.code, message: result.message);
      }

      return result.data as T;
    } on DioException catch (e) {
      throw ApiException(message: e.message ?? "Network Error");
    }
  }

  Future<T> post<T>(
    String url, {
    Map<String, dynamic>? data,
    CancelToken? cancelToken,
    required T Function(dynamic json) parser,
  }) async {
    try {
      final response = await dio.post(
        url,
        data: data,
        cancelToken: cancelToken,
      );

      final result = ApiResponse<T>.fromJson(response.data, parser);

      if (!result.success) {
        throw ApiException(code: result.code, message: result.message);
      }

      return result.data as T;
    } on DioException catch (e) {
      throw ApiException(message: e.message ?? "Network Error");
    }
  }
}
