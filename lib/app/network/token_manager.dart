class TokenManager {
  static String? _accessToken;
  static String? _refreshToken;

  static String? get accessToken => _accessToken;
  static String? get refreshToken => _refreshToken;

  static Future<void> saveToken({
    required String access,
    required String refresh,
  }) async {
    _accessToken = access;
    _refreshToken = refresh;

    // TODO: 持久化（SharedPreferences / SecureStorage）
  }

  static Future<void> clear() async {
    _accessToken = null;
    _refreshToken = null;
  }
}
