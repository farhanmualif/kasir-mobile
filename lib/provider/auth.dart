import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kasir_mobile/interface/user.dart';

class Auth {
  bool status;
  dynamic data;

  Auth({required this.status, required this.data});

  factory Auth.loginResult(Map<String, dynamic> object) {
    try {
      if (object["status"] == true) {
        var data = object["data"];
        User user = User(
            id: data["id"],
            name: data["name"],
            createdAt: data["created_at"],
            updatedAt: data["updated_at"]);
        return Auth(status: object["status"], data: user);
      } else {
        return Auth(
          status: object["status"],
          data: object["data"],
        );
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static login(String email, String password) async {
    try {
      var respons =
          await http.post(Uri.parse("http://192.168.1.11:8001/api/login"),
              body: jsonEncode(<String, String>{
                'email': email,
                'password': password,
              }),
              headers: <String, String>{'Content-Type': 'application/json'});
      var jsonRespons = json.decode(respons.body);
      return Auth.loginResult(jsonRespons);
    } catch (e) {
      print(e);
      return e;
    }
  }
}
