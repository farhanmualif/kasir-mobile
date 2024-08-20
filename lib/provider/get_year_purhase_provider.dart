import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/helper/get_access_token.dart';
import 'package:kasir_mobile/interface/api_response_interface.dart';
import 'package:kasir_mobile/interface/raport/year_purchase.dart';

import 'package:http/http.dart' as http;

class GetYearPurchase with AccessTokenProvider {
  static var domain = dotenv.env['BASE_URL'];

  static Future<ApiResponse<YearPurchase>> getYearPurchase(String date) async {
    try {
      String? token = await AccessTokenProvider.token();
      var response = await http.get(
        Uri.parse('$domain/api/purchases/yearly/$date'),
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
          (json) => json is Map<String, dynamic>
              ? YearPurchase.fromJson(json)
              : throw ArgumentError('Invalid JSON format'),
        );
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e, stacktrace) {
      throw Exception('line: $stacktrace: $e');
    }
  }
}
