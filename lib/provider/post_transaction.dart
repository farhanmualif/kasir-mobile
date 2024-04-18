import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

class PostTransaction {
  static post(double cash, List<RequestTransaction> items) async {
    try {
      var pref = await SharedPreferences.getInstance();
      var token = pref.getString('AccessToken');
      var domain = dotenv.env["BASE_URL"]!;

      var transaction = {
        "cash": cash.toInt(),
        "items": items.map((item) => item.toJson()).toList()
      };

      print('check payload $transaction');

      var response = await http.post(Uri.https(domain, "api/transaction"),
          body: jsonEncode({"transaction": transaction}),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            'Authorization': 'Bearer $token'
          });

      return jsonDecode(response.body);
    } catch (e) {
      rethrow;
    }
  }
}
