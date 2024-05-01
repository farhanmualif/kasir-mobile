import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/interface/api_response.dart';
import 'package:kasir_mobile/interface/category_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PostCategory {
  static Future<ApiResponse<CategoryProduct>> post(String name) async {
    try {
      var pref = await SharedPreferences.getInstance();
      var token = pref.getString('AccessToken');
      var domain = dotenv.env["BASE_URL"]!;

      var body = {
        "name": name,
      };

      var response = await http.post(Uri.https(domain, "api/category"),
          body: jsonEncode(body),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            'Authorization': 'Bearer $token'
          });
      print(response.body);

      if (response.statusCode == 200) {
        final resBody = jsonDecode(response.body);
        return ApiResponse.fromJson(
          resBody,
          (json) => json is Map<String, dynamic>
              ? CategoryProduct.fromJson(json)
              : throw ArgumentError('Invalid JSON format'),
        );
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      rethrow;
    }
  }
}
