class ApiResponse<T> {
  final bool status;
  final dynamic message;
  final T? data;

  ApiResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    if (json['status'] == false) {
      return ApiResponse(
          status: json["status"], message: json["message"], data: null);
    }
    return ApiResponse<T>(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}
