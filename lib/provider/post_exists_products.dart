import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/helper/get_access_token.dart';
import 'package:kasir_mobile/interface/api_response_interface.dart';

class PostExistsProductRequest {
  String uuid;
  String barcode;
  int quantityStock;

  PostExistsProductRequest({
    required this.uuid,
    required this.barcode,
    required this.quantityStock,
  });

  Map<String, dynamic> toJson() {
    return {
      "uuid": barcode,
      "barcode": barcode,
      "quantity_stok": quantityStock,
    };
  }
}

class PostExistsProducts {
  static String? domain = dotenv.env["BASE_URL"];

  static Future<ApiResponse> post(
      List<PostExistsProductRequest> products) async {
    try {
      String? token = await AccessTokenProvider.token();

      List<Map<String, dynamic>> productList =
          products.map((product) => product.toJson()).toList();

      Map<String, dynamic> body = {"products": productList};

      var response = await http.post(
        Uri.parse("${domain!}/api/products/purchase/existing"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      var resBody = jsonDecode(response.body);
      

      return ApiResponse.fromJson(resBody, (json) => null);
    } catch (e, stacktrace) {
      throw Exception('line: $stacktrace: $e');
    }
  }
}
