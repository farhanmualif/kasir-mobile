import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/interface/api_response.dart';
import 'package:kasir_mobile/interface/raport/monthly_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GetMonthlyPurchase {
  static var domain = dotenv.env['BASE_URL'];

  static Future<ApiResponse<MounthlyPurchase>> getMonthlyTransaction(
      String date) async {
    try {
      var pref = await SharedPreferences.getInstance();
      var token = pref.getString('AccessToken');
      var response = await http.get(
        Uri.https(domain!, 'api/monthly-purchases/$date'),
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
              ? MounthlyPurchase.fromJson(json)
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
