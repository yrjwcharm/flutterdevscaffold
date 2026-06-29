import 'package:dio/dio.dart';

class RequestQueue {
  static final Map<String, CancelToken> _queue = {};

  static CancelToken getToken(String key) {
    if (_queue.containsKey(key)) {
      _queue[key]?.cancel();
    }

    final token = CancelToken();
    _queue[key] = token;

    return token;
  }

  static void remove(String key) {
    _queue.remove(key);
  }
}
