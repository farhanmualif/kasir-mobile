import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/helper/get_access_token.dart';
import 'package:kasir_mobile/interface/api_response_interface.dart';
import 'package:kasir_mobile/interface/raport/year_transaction.dart';
import 'package:http/http.dart' as http;

class GetYearTransaction with AccessTokenProvider {
  static var domain = dotenv.env['BASE_URL'];

  static Future<ApiResponse<YearTransaction>> getYearTransaction(
      String date) async {
    try {
      String? token = await AccessTokenProvider.token();
      var response = await http.get(
        Uri.parse('$domain/api/sales/yearly/$date'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          'Authorization': 'Bearer $token'
        },
      );

      debugPrint(response.body);

      final resBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return ApiResponse.fromJson(
          resBody,
          (json) => json is Map<String, dynamic>
              ? YearTransaction.fromJson(json)
              : throw ArgumentError('Invalid JSON format'),
        );
      } else {
        return ApiResponse(
          status: false,
          message: resBody['message'] ?? 'Failed to load data',
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
