import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:kasir_mobile/helper/get_now.dart';
import 'package:kasir_mobile/pages/report/widget/list_daily_report.dart';

class DailyReport extends StatelessWidget {
  const DailyReport({super.key, required this.typeRaport, this.date});
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
                '$typeRaport Hari Ini',
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
        body: ListDailyReport(
          date: date ?? DateFormat('yyyy-MM-dd').format(DateTime.now())
        ));
  }
}
