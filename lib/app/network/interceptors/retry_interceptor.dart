import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final int maxRetry;

  RetryInterceptor({this.maxRetry = 2});

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    final request = err.requestOptions;

    int retryCount = request.extra['retry'] ?? 0;

    if (retryCount < maxRetry &&
        err.type == DioExceptionType.connectionTimeout) {
      request.extra['retry'] = retryCount + 1;

      final dio = Dio();
      final response = await dio.fetch(request);
      return handler.resolve(response);
    }

    return handler.next(err);
  }
}
