import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:kasir_mobile/helper/get_now.dart';
import 'package:kasir_mobile/pages/report/widget/list_daily_purchase_report.dart';
import 'package:kasir_mobile/pages/report/widget/list_daily_transaction_report.dart';

class YesterdayReport extends StatelessWidget {
  const YesterdayReport({super.key, required this.typeRaport, this.date});
  final String typeRaport;
  final String? date;

  String getYesterdayDate() {
    // Mendapatkan tanggal hari ini
    DateTime now = DateTime.now();

    // Mendapatkan tanggal hari kemarin
    DateTime yesterday = now.subtract(const Duration(days: 1));

    // Memformat tanggal hari kemarin ke dalam format 'yyyy-MM-dd'
    return DateFormat('yyyy-MM-dd').format(yesterday);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff076A68),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$typeRaport Kemarin',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              getDayNow(),
              style: const TextStyle(color: Colors.white, fontSize: 16),
            )
          ],
        ),
      ),
      body: typeRaport == "Penjualan"
          ? ListDailyTransactionReport(
              date: date ?? getYesterdayDate(),
            )
          : ListDailyPurchaseReport(
              date: date ?? getYesterdayDate(),
            ),
    );
  }
}
