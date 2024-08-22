import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/helper/get_access_token.dart';
import 'package:kasir_mobile/interface/api_response_interface.dart';
import 'package:kasir_mobile/interface/invoice_interface.dart';

class GetInvoiceProvider with AccessTokenProvider {
  static var domain = dotenv.env['BASE_URL'];

  static Future<ApiResponse<Invoice>> getInvoice(String noTransaction) async {
    try {
      String? token = await AccessTokenProvider.token();
      var response = await http.get(
        Uri.parse('$domain/api/invoices/$noTransaction'),
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
              ? Invoice.fromJson(json)
              : throw ArgumentError('Invalid JSON format'),
        );
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e, stacktrace) {
      throw Exception('line: $stacktrace: $e');
    }
  }

  static Future<Uint8List> getFile(String noTransaction) async {
    try {
      var token = await AccessTokenProvider.token();
      var response = await http.get(
        Uri.parse('$domain/api/transaction/$noTransaction/invoice'),
        headers: {
          'Authorization': 'Bearer $token',
          "Accept": "*/*",
          "Accept-Encoding": "gzip, deflate, br",
          "Connection": "keep-alive"
        },
      );
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to load invoice: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting invoice: $e');
    }
  }
}
