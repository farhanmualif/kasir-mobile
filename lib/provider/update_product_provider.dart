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

      // "name": "stella",
      // "barcode": "8992745999881",
      // "add_or_reduce_stock": "add",
      // "quantity_stok": 10,
      // "selling_price": 2000,
      // "purchase_price": 3000

      var response = await http.put(Uri.parse("$domain/api/products/$uuid"),
          body: json.encode(body),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            'Authorization': 'Bearer $token'
          });

      final resBody = jsonDecode(response.body);
      print("req.body: ${json.encode(body)}");
      print("response.body: ${response.body}");
      return ApiResponse.fromJson(
        resBody,
        (json) => json is Map<String, dynamic>
            ? ProductUpdateResponse.fromJson(json)
            : throw ArgumentError('Invalid JSON format'),
      );
    } catch (e) {
      rethrow;
    }
  }
}
