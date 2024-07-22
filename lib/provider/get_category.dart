import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/interface/api_response_interface.dart';
import 'package:kasir_mobile/interface/category_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GetCategory {
  
  static final String domain = dotenv.env['BASE_URL'] ?? '';

  static Future<ApiResponse<List<CategoryProduct>>> getCategory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('AccessToken');

      final response = await http.get(
        Uri.http(domain, 'api/category'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        final resBody = jsonDecode(response.body);
        return ApiResponse.fromJson(
          resBody,
          (json) => (json as List)
              .map((categoryJson) => CategoryProduct.fromJson(categoryJson))
              .toList(),
        );
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e, stacktrace) {
      throw Exception('line: $stacktrace: $e');
    }
  }
}