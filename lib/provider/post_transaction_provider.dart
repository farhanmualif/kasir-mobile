import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:kasir_mobile/helper/get_access_token.dart';
import 'package:kasir_mobile/interface/response_transaction_interface.dart';

class RequestTransaction {
  int idProduct;
  int quantity;
  String name;
  double itemPrice;

  RequestTransaction(
      {required this.idProduct,
      required this.name,
      required this.itemPrice,
      required this.quantity});

  Map<String, dynamic> toJson() {
    return {
      'id_product': idProduct,
      'name': name,
      'item_price': itemPrice,
      'quantity': quantity,
    };
  }
}

class PostTransaction with AccessTokenProvider {
  static Future<TransactionResponse> post(
      double cash, List<RequestTransaction> items) async {
    try {
      String? token = await AccessTokenProvider.token();
      var domain = dotenv.env["BASE_URL"]!;

      var transaction = {
        "cash": cash.toInt(),
        "items": items.map((item) => item.toJson()).toList()
      };

      var response = await http.post(Uri.parse("$domain/api/transaction"),
          body: jsonEncode({"transaction": transaction}),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            'Authorization': 'Bearer $token'
          });
      return TransactionResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }
}
