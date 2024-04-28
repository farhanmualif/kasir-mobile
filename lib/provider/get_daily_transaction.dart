import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/interface/raport/daily_transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GetDailyTransaction {
  static var domain = dotenv.env['BASE_URL'];
  bool status;
  String message;
  DailyTransaction? dailyTransaction;

  GetDailyTransaction({
    this.dailyTransaction,
    required this.message,
    required this.status,
  });

  factory GetDailyTransaction.fromJson(Map<String, dynamic> object) {
    List<DetailTransaction> listDetailTransactions = [];
    DailyTransaction dailyTransaction;

    if (object['data'] != null) {
      for (var listDetailTransaction in object['data']['transactions']) {
        DetailTransaction detailTransaction = DetailTransaction(
            time: listDetailTransaction['time'],
            revenue: listDetailTransaction['revenue'],
            profit: listDetailTransaction['profit'],
            noTransaction: listDetailTransaction['no_transaction']);

        listDetailTransactions.add(detailTransaction);
      }

      dailyTransaction = DailyTransaction(
          date: object['data']['date'],
          totalProfit: object['data']['total_profit'],
          totalRevenue: object['data']['total_revenue'],
          totalTransactions: object['data']['total_transactions'],
          detailTransaction: listDetailTransactions);

      return GetDailyTransaction(
        status: object['status'],
        message: object['message'],
        dailyTransaction: dailyTransaction,
      );
    } else {
      return GetDailyTransaction(
          message: object['message'], status: object['status']);
    }
  }

  static Future<GetDailyTransaction> getdailyTransaction(String date) async {
    try {
      var pref = await SharedPreferences.getInstance();
      var token = pref.getString('AccessToken');
      var response = await http
          .get(Uri.https(domain!, 'api/daily-transaction/$date'), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': 'Bearer $token'
      });

      final body = jsonDecode(response.body);
      return GetDailyTransaction.fromJson(body);
    } catch (e, stacktrace) {
      throw Exception('line: $stacktrace: $e');
    }
  }
}
