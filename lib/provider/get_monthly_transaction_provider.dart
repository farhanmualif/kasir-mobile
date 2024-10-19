import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/helper/get_access_token.dart';
import 'package:kasir_mobile/interface/api_response_interface.dart';
import 'package:kasir_mobile/interface/raport/monthly_transactions.dart';
import 'package:http/http.dart' as http;

class GetMonthlyTransaction with AccessTokenProvider {
  static final domain = dotenv.env['BASE_URL'];

  static Future<ApiResponse<MonthlyTransaction>> getMonthlyTransaction(String date) async {
    try {
      final String? token = await AccessTokenProvider.token();
      if (token == null) {
        return ApiResponse(
          status: false,
          message: 'Failed to get access token',
          data: null,
        );
      }

      final response = await http.get(
        Uri.parse('$domain/api/sales/monthly/$date'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          'Authorization': 'Bearer $token'
        },
      );

      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(
          responseBody,
          (json) => json is Map<String, dynamic>
              ? MonthlyTransaction.fromJson(json)
              : throw ArgumentError('Invalid JSON format'),
        );
      } else {
        // Handle non-200 status codes
        debugPrint('API request failed with status: ${response.statusCode}');
        return ApiResponse(
          status: false,
          message: responseBody['message'] ?? 'Failed to load data',
          data: null,
        );
      }
    } catch (e, stacktrace) {
      debugPrint('Error in getMonthlyTransaction: $e\n$stacktrace');
      return ApiResponse(
        status: false,
        message: 'An error occurred: ${e.toString()}',
        data: null,
      );
    }
  }
}