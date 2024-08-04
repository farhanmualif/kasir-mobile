import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/interface/api_response_interface.dart';
import 'package:kasir_mobile/interface/product_update_response_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UpdateProduct {
  static Future<ApiResponse<ProductUpdateResponse>> put(
    String uuid,
    String name,
    String barcode,
    int quantityStock,
    double sellingPrice,
    double purchasePrice,
    String addOrreduceStock,
  ) async {
    try {
      var pref = await SharedPreferences.getInstance();
      var token = pref.getString('AccessToken');
      var domain = dotenv.env["BASE_URL"]!;

      var body = {
        "name": name,
        "barcode": barcode,
        "quantity_stok": quantityStock,
        "selling_price": sellingPrice,
        "purchase_price": purchasePrice,
        "add_or_reduce_stock": addOrreduceStock,
      };

      var response = await http.put(Uri.parse("$domain/api/products/$uuid"),
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
              ? ProductUpdateResponse.fromJson(json)
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
