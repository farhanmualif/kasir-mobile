import 'package:flutter/material.dart';
import 'package:kasir_mobile/pages/report/anual_report.dart';
import 'package:kasir_mobile/pages/report/daily_report.dart';
import 'package:kasir_mobile/pages/report/monthly_report.dart';
import 'package:kasir_mobile/pages/report/yesterday_report.dart';

class ReportPage extends StatelessWidget {
  ReportPage({super.key});

  final List<String> laporanList = [
    'Penjualan Kemarin',
    'Penjualan Perhari',
    'Penjualan Perbulan',
    'Penjualan Pertahun',
    'Pembelian kemarin',
    'Pembelian Perhari',
    'Pembelian Perbulan',
    'Pembelian Pertahun',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff076A68),
        title: const Text(
          'Laporan',
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: laporanList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              switch (index) {
                case 0:
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const YesterdayReport(
                            typeRaport: "Penjualan",
                          )));
                  break;
                case 1:
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const DailyReport(
                            typeRaport: "Penjualan",
                          )));
                  break;
                case 2:
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MonthlyReport(
                            typeRaport: "Penjualan",
                          )));
                case 3:
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AnualReport(
                            typeRaport: "Penjualan",
                          )));
                case 4:
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const YesterdayReport(
                            typeRaport: "Pembelian",
                          )));
                case 5:
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const DailyReport(
                            typeRaport: "Pembelian",
                          )));
                case 6:
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MonthlyReport(
                            typeRaport: "Pembelian",
                          )));
                case 7:
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AnualReport(
                            typeRaport: "Pembelian",
                          )));
                default:
              }
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1),
              ),
              color: Colors.white,
              child: ListTile(
                leading: const Icon(Icons.description),
                title: Text(laporanList[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}
