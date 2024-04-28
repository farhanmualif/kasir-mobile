class AuthData {
  final String token;
  final String uuid;
  final String user;
  final String email;

  AuthData({
    required this.token,
    required this.uuid,
    required this.user,
    required this.email,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      token: json['token'],
      uuid: json['uuid'],
      user: json['user'],
      email: json['email'],
    );
  }
}

class CheckAuthResponse {
  final bool status;
  final String message;
  final List<AuthData>? data;

  CheckAuthResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory CheckAuthResponse.fromJson(Map<String, dynamic> json) {
    return CheckAuthResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'],
    );
  }
}
