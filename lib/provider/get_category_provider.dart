import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/helper/get_access_token.dart';
import 'package:kasir_mobile/interface/api_response_interface.dart';
import 'package:kasir_mobile/interface/category_interface.dart';
import 'package:http/http.dart' as http;

class GetCategory {
  static final String domain = dotenv.env['BASE_URL'] ?? '';

  static Future<ApiResponse<List<CategoryProduct>>> getCategory() async {
    try {
      final token = await AccessTokenProvider.token();

      final response = await http.get(
        Uri.parse('$domain/api/category'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        final resBody = jsonDecode(response.body);

        return ApiResponse<List<CategoryProduct>>.fromJson(
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
