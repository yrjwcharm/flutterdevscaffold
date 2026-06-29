class ApiResponse<T> {
  final int code;
  final String message;
  final T? data;

  ApiResponse({required this.code, required this.message, this.data});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? parser,
  ) {
    return ApiResponse(
      code: json['code'],
      message: json['message'],
      data: parser != null ? parser(json['data']) : json['data'],
    );
  }

  bool get success => code == 0;
}
