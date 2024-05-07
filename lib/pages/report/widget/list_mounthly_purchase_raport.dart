import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kasir_mobile/pages/report/daily_report.dart';
import 'package:kasir_mobile/provider/get_monthly_purchase.dart';

class ListMounthlyPurchaseReport extends StatefulWidget {
  const ListMounthlyPurchaseReport(
      {super.key, required this.typeRaport, required this.date});
  final String typeRaport;
  final String date;

  @override
  State<ListMounthlyPurchaseReport> createState() =>
      _ListMounthlyPurchaseReport();
}

class _ListMounthlyPurchaseReport extends State<ListMounthlyPurchaseReport> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetMonthlyPurchase.getMonthlyTransaction(widget.date),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData == false) {
            return const Center(
              child: Text('Data Belum Tersedia'),
            );
          } else if (snapshot.data == null || snapshot.data!.data == null) {
            return const Center(
              child: Text('data belum tersedia'),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }  else {
          return CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Color(0xff076A68),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Column(
                              children: [
                                TextButton(
                                  onPressed: null,
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Jml Transaksi",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        "${snapshot.data!.data!.dailyData.length}",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Color(0xff076A68),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Column(
                              children: [
                                TextButton(
                                  onPressed: null,
                                  child: Column(
                                    children: [
                                      const Text(
                                        "Total Pengeluaran",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        "Rp. ${snapshot.data!.data!.totalExpenditure}",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 26),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.data!.dailyData.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 1,
                                color: Color(0xffDDDDDD),
                              ),
                              top: BorderSide(
                                width: 1,
                                color: Color(0xffDDDDDD),
                              ),
                            ),
                          ),
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          padding: const EdgeInsets.only(bottom: 5, top: 5),
                          height: MediaQuery.of(context).size.height * 0.14,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          DateFormat('dd').format(
                                              DateTime.parse(snapshot
                                                  .data!
                                                  .data!
                                                  .dailyData[index]
                                                  .date)),
                                          style: const TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 3),
                                          child: Column(
                                            children: [
                                              Text(
                                                DateFormat('MM').format(
                                                    DateTime.parse(snapshot
                                                        .data!
                                                        .data!
                                                        .dailyData[index]
                                                        .date)),
                                                style: const TextStyle(
                                                    fontSize: 10),
                                              ),
                                              Text(
                                                DateFormat('yyyy').format(
                                                    DateTime.parse(snapshot
                                                        .data!
                                                        .data!
                                                        .dailyData[index]
                                                        .date)),
                                                style: const TextStyle(
                                                    fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "${snapshot.data!.data!.dailyData[index].totalTransaction} Transaksi",
                                      style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 3),
                                            child: const Text("Pengeluaran"),
                                          ),
                                          Text(
                                            "Rp. ${snapshot.data!.data!.dailyData[index].totalExpenditure}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: -1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Expanded(
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                    Expanded(
                                        child: GestureDetector(
                                            onTap: () {
                                              if (widget.typeRaport ==
                                                  "Pembelian") {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return DailyReport(
                                                        typeRaport: "Pembelian",
                                                        date: snapshot
                                                            .data!
                                                            .data!
                                                            .dailyData[index]
                                                            .date,
                                                      );
                                                    },
                                                  ),
                                                );
                                              } else {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DailyReport(
                                                      typeRaport: "Penjualan",
                                                      date: snapshot
                                                          .data!
                                                          .data!
                                                          .dailyData[index]
                                                          .date,
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            child: const Icon(
                                                Icons.navigate_next_outlined))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ]),
              ),
            ],
          );
        }
      },
    );
  }
}
