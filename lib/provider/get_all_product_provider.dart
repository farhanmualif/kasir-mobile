import 'dart:convert';

import 'package:kasir_mobile/helper/get_access_token.dart';
import 'package:kasir_mobile/interface/category_interface.dart';
import 'package:kasir_mobile/interface/product_interface.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GetAllProduct with AccessTokenProvider {
  bool status;
  String message;
  List<Product> data;

  GetAllProduct({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GetAllProduct.fromJson(Map<String, dynamic> object) {
    List<Product> products = [];

    if (object['data'] != null) {
      for (var productData in object['data']) {
        List<CategoryProduct> categories = [];

        if (productData['category'] != null) {
          for (var categoryData in productData['category']) {
            categories.add(CategoryProduct(
                id: categoryData['id'],
                uuid: categoryData['uuid'],
                name: categoryData['name'],
                createdAt: categoryData['created_at'],
                updatedAt: categoryData['updated_at']));
          }
        }

        var product = Product(
          id: productData['id'],
          link: productData['link'],
          uuid: productData['uuid'],
          name: productData['name'],
          barcode: productData['barcode'],
          stock: productData['stock'],
          price: double.parse(productData['selling_price']),
          purchasePrice: double.parse(productData['purchase_price']),
          image: productData['image'],
          createdAt: DateTime.parse(productData['created_at']),
          updatedAt: DateTime.parse(productData['updated_at']),
          category: categories,
        );

        products.add(product);
      }
    }

    return GetAllProduct(
      status: object['status'],
      message: object['message'],
      data: products,
    );
  }

  static Future<GetAllProduct> getAllProduct() async {
    try {
      var domain = dotenv.env["BASE_URL"];

      String? token = await AccessTokenProvider.token();

      var response =
          await http.get(Uri.parse("$domain/api/products"), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token'
      });

      final body = json.decode(response.body);
      return GetAllProduct.fromJson(body);
    } catch (e, stacktrace) {
      throw Exception('line: $stacktrace: $e');
    }
  }
}
