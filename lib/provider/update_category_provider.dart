import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/helper/get_access_token.dart';
import 'package:kasir_mobile/interface/api_response_interface.dart';
import 'package:kasir_mobile/interface/category_interface.dart';
import 'package:http/http.dart' as http;

class UpdateCategory with AccessTokenProvider {
  static Future<ApiResponse<CategoryProduct>> post(
      String uuid, String newName) async {
    try {
      String? token = await AccessTokenProvider.token();
      var domain = dotenv.env["BASE_URL"]!;

      var body = {"name": newName, "_method": "put"};

      var response = await http.post(Uri.parse("$domain/api/category/$uuid"),
          body: jsonEncode(body),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            'Authorization': 'Bearer $token'
          });

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
