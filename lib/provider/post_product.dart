import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PostProduct {
  static String? domain = dotenv.env["BASE_URL"];

  static postProduct(
      {File? image,
      required String name,
      required int stock,
      required int sellingPrice,
      required int purchasePrice,
      int? categoryId,
      String? barcode}) async {
    try {
      var pref = await SharedPreferences.getInstance();
      var token = pref.getString('AccessToken');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("https://${domain!}/api/products"),
      );
      Map<String, String> headers = {
        "Content-type": "multipart/form-data",
        "Accept": "application/json",
        "Authorization": "Bearer $token"
      };
      request.headers.addAll(headers);

      Map<String, String> productData = {
        'name': name,
        'stock': stock.toString(),
        'selling_price': sellingPrice.toString(),
        'purchase_price': purchasePrice.toString(),
        'category_id': categoryId == null ? "" : categoryId.toString(),
        'barcode': barcode == null ? "" : barcode.toString(),
      };
      request.fields.addAll(productData);

      if (image != null) {
        request.files.add(
          http.MultipartFile(
            'image',
            image.readAsBytes().asStream(),
            image.lengthSync(),
            filename: image.path.split('/').last,
          ),
        );
      }
      var res = await request.send();
      http.Response response = await http.Response.fromStream(res);
      return jsonDecode(response.body);
    } catch (e, stacktrace) {
      throw Exception('line: $stacktrace: $e');
    }
  }
}
