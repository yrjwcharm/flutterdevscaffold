import 'package:dio/dio.dart';
import 'package:flutterdevscaffold/app/network/env_config.dart';
import 'package:flutterdevscaffold/app/network/token_manager.dart';

class RefreshTokenInterceptor extends Interceptor {
  final Dio dio;

  RefreshTokenInterceptor(this.dio);

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    final response = err.response;

    if (response?.statusCode == 401) {
      try {
        final newToken = await _refreshToken();

        if (newToken != null) {
          TokenManager.saveToken(
            access: newToken,
            refresh: TokenManager.refreshToken ?? '',
          );

          final request = err.requestOptions;
          request.headers['Authorization'] = 'Bearer $newToken';

          final retryResponse = await dio.fetch(request);
          return handler.resolve(retryResponse);
        }
      } catch (e) {
        await TokenManager.clear();
      }
    }

    return handler.next(err);
  }

  Future<String?> _refreshToken() async {
    final dio = Dio();

    final res = await dio.post(
      '${EnvConfig.baseUrl}/auth/refresh',
      data: {'refreshToken': TokenManager.refreshToken},
    );

    return res.data['data']['accessToken'];
  }
}
