import 'dart:convert';

import 'package:kasir_mobile/helper/get_access_token.dart';
import 'package:kasir_mobile/interface/api_response_interface.dart';
import 'package:kasir_mobile/interface/category_interface.dart';
import 'package:kasir_mobile/interface/product_interface.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GetProductByBarcode with AccessTokenProvider {
  Product data;

  GetProductByBarcode({
    required this.data,
  });

  factory GetProductByBarcode.fromJson(Map<String, dynamic> object) {
    if (object['data'] == null) {
      throw const FormatException('Invalid JSON: data field is missing');
    }

    List<CategoryProduct> categories = [];

    if (object['category'] != null) {
      for (var categoryData in object['category']) {
        categories.add(CategoryProduct(
            id: categoryData['id'],
            uuid: categoryData['uuid'],
            name: categoryData['name'],
            createdAt: categoryData['created_at'],
            updatedAt: categoryData['updated_at']));
      }
    }


    Product products = Product(
      id: object['id'],
      link: object['link'],
      uuid: object['uuid'],
      name: object['name'],
      barcode: object['barcode'],
      stock: object['stock'],
      price: double.parse(object['selling_price']),
      purchasePrice: double.parse(object['purchase_price']),
      image: object['image'],
      createdAt: DateTime.parse(object['created_at']),
      updatedAt: DateTime.parse(object['updated_at']),
      category: categories,
    );

    return GetProductByBarcode(
      data: products,
    );
  }

  static Future<ApiResponse<Product>> getProduct(String barcode) async {
    try {
      var domain = dotenv.env["BASE_URL"];

      String? token = await AccessTokenProvider.token();

      var response = await http
          .get(Uri.parse("$domain/api/products/$barcode/barcode"), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token'
      });

  

      final body = json.decode(response.body);
      return ApiResponse.fromJson(body, (json) => Product.fromJson(json));
    } catch (e, stacktrace) {
      throw Exception('line: $stacktrace: $e');
    }
  }
}
