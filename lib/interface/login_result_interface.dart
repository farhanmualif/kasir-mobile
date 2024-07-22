import 'package:kasir_mobile/interface/user_interface.dart';

class LoginResult {
  User user;

  LoginResult({required this.user});

  factory LoginResult.fromjson(Map<String, dynamic> json) {
    final Map<String, dynamic> data =
        json['data'] is Map<String, dynamic> ? json['data'] : json;

    return LoginResult(
        user: User(
            token: data['token'],
            uuid: data['uuid'],
            name: data['user'],
            email: data['email']));
  }
}
