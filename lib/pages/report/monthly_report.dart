import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kasir_mobile/helper/get_now.dart';
import 'package:kasir_mobile/pages/report/widget/list_mounthly_purchase_raport.dart';
import 'package:kasir_mobile/pages/report/widget/list_mounthly_transaction_raport.dart';

class MonthlyReport extends StatelessWidget {
  const MonthlyReport({super.key, required this.typeRaport, this.date});

  final String typeRaport;
  final String? date;

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
                '$typeRaport Perbulan',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                getMounthNow(),
                style: const TextStyle(color: Colors.white, fontSize: 16),
              )
            ],
          ),
        ),
        body: typeRaport == "Penjualan"
            ? ListMounthlyTransactionRaport(
                typeRaport: typeRaport,
                date: date ??
                    DateFormat('yyyy-MM-dd').format(
                      DateTime.now(),
                    ),
              )
            : ListMounthlyPurchaseReport(
                typeRaport: typeRaport,
                date: date ??
                    DateFormat('yyyy-MM-dd').format(
                      DateTime.now(),
                    )));
  }
}
