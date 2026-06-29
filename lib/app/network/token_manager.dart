import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static const _storage = FlutterSecureStorage();

  static const _keyAccess = "access_token";
  static const _keyRefresh = "refresh_token";

  static String? _accessToken;
  static String? _refreshToken;

  static String? get accessToken => _accessToken;
  static String? get refreshToken => _refreshToken;

  /// 初始化（App 启动时调用）
  static Future<void> init() async {
    _accessToken = await _storage.read(key: _keyAccess);
    _refreshToken = await _storage.read(key: _keyRefresh);
  }

  /// 保存 token（内存 + 本地）
  static Future<void> saveToken({
    required String access,
    required String refresh,
  }) async {
    _accessToken = access;
    _refreshToken = refresh;

    await _storage.write(key: _keyAccess, value: access);
    await _storage.write(key: _keyRefresh, value: refresh);
  }

  /// 清除 token（退出登录）
  static Future<void> clear() async {
    _accessToken = null;
    _refreshToken = null;

    await _storage.delete(key: _keyAccess);
    await _storage.delete(key: _keyRefresh);
  }
}
