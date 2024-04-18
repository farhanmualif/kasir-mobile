import 'package:flutter/material.dart';
import 'package:kasir_mobile/interface/user_interface.dart';
import 'package:http/http.dart' as http;
import 'package:kasir_mobile/main.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  bool status;
  String message;
  dynamic data;
  static var domain = dotenv.env["BASE_URL"] ?? "http://192.168.1.11:8080";

  Auth({required this.status, required this.data, required this.message});

  static deletePrefer(BuildContext context) async {
    var pref = await SharedPreferences.getInstance();
    pref.remove("AccessToken");
    Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: ((context) => const MyApp())));
  }

  factory Auth.loginResult(Map<String, dynamic> object) {
    try {
      if (object["status"] == true) {
        var data = object["data"];
        User user = User(
          token: data["token"],
          uuid: data["uuid"],
          name: data["user"],
          email: data["email"],
        );
        return Auth(
            status: object["status"], data: user, message: object['message']);
      } else {
        return Auth(
            status: object["status"],
            data: object["data"],
            message: object['message']);
      }
    } catch (e, stacktrace) {
      throw Exception('$stacktrace: $e');
    }
  }

  static login(String email, String password) async {
    try {
      var response = await http.post(Uri.https(domain, "api/login"),
          body: jsonEncode({"email": email, "password": password}),
          headers: {
            "Content-Type": "application/json",
          });

      var data = jsonDecode(response.body);
      return Auth.loginResult(data);
    } catch (e, stacktrace) {
      throw Exception('line: $stacktrace: $e');
    }
  }

  static logout(BuildContext context) async {
    try {
      var pref = await SharedPreferences.getInstance();
      var token = pref.getString('AccessToken');
      var response = await http.post(
          Uri.https(
            domain,
            "api/logout",
          ),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });
      var resJson = jsonDecode(response.body);
      if (resJson['status']) {
        // ignore: use_build_context_synchronously
        deletePrefer(context);
      }
      // return resJson;
    } catch (e) {
      return e;
    }
  }

  static checkAuth() async {
    try {
      var pref = await SharedPreferences.getInstance();
      var token = pref.getString('AccessToken');
      var response = await http.get(
          Uri.https(
            domain,
            "api/check-auth",
          ),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });
      var res = jsonDecode(response.body);
      return res;
    } catch (e) {
      return e;
    }
  }
}
