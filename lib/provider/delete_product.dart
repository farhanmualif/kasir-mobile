import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/interface/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DeleteProduct {
  static Future<ApiResponse> delete(String uuid) async {
    try {
      var pref = await SharedPreferences.getInstance();
      var token = pref.getString('AccessToken');
      var domain = dotenv.env["BASE_URL"]!;

      var response =
          await http.delete(Uri.https(domain, "api/products/$uuid"), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token'
      });

      if (response.statusCode == 200) {
        final resBody = jsonDecode(response.body);

        return ApiResponse.fromJson(
          resBody,
          (json) => null,
        );
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      rethrow;
    }
  }
}
