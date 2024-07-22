import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kasir_mobile/interface/api_response_interface.dart';
import 'package:kasir_mobile/interface/check_auth_interface.dart';
import 'package:kasir_mobile/interface/login_result_interface.dart';
import 'package:kasir_mobile/interface/register_result_interface.dart';
import 'package:http/http.dart' as http;
import 'package:kasir_mobile/main.dart';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  bool status;
  String message;
  dynamic data;
  static var domain = dotenv.env["BASE_URL"]!;

  Auth({required this.status, required this.data, required this.message});

  static deletePrefer(BuildContext context) async {
    var pref = await SharedPreferences.getInstance();
    pref.remove("AccessToken");
    Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: ((context) => const MyApp())));
  }

  static Future<ApiResponse<LoginResult>> login(
    String email,
    String password,
  ) async {
    try {
      var response = await http.post(Uri.http(domain, "api/login"),
          body: jsonEncode({
            "email": email,
            "password": password,
          }),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          });

      var data = jsonDecode(response.body);
      return ApiResponse.fromJson(data, (json) => LoginResult.fromjson(data));
    } catch (e, stacktrace) {
      throw Exception('line: $stacktrace: $e');
    }
  }

  static Future<ApiResponse<RegisterResult>> register(String name, String email,
      String password, String confirmPassword, String address) async {
    try {
      var response = await http.post(Uri.http(domain, "api/register"),
          body: jsonEncode({
            "name": name,
            "email": email,
            "password": password,
            'password_confirmation': confirmPassword,
            'address': address
          }),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          });

      var data = jsonDecode(response.body);
      return ApiResponse.fromJson(
          data, (json) => RegisterResult.fromjson(json));
    } catch (e, stacktrace) {
      throw Exception('line: $stacktrace: $e');
    }
  }

  static logout(BuildContext context) async {
    try {
      var pref = await SharedPreferences.getInstance();
      var token = pref.getString('AccessToken');
      var response = await http.post(
          Uri.http(
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
    } catch (e, stacktrace) {
      throw Exception('line: $stacktrace: $e');
    }
  }

  static authenticated() async {
    try {
      var pref = await SharedPreferences.getInstance();
      var token = pref.getString('AccessToken');
      final httpClient = HttpClient();
      httpClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);

      var response =
          await http.get(Uri.http(domain, "api/authenticated"), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      var responseJson = jsonDecode(response.body);
      CheckAuthResponse res = CheckAuthResponse.fromJson(responseJson);

      if (response.statusCode == 200) {
        return res;
      } else if (res.data == null) {
        CheckAuthResponse failureResp =
            CheckAuthResponse(status: false, message: "uauthenticated");
        return failureResp;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      return e;
    }
  }
}
