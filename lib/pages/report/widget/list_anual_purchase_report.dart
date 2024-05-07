import 'package:flutter/material.dart';
import 'package:kasir_mobile/pages/report/monthly_report.dart';
import 'package:kasir_mobile/provider/get_year_purhase.dart';

class ListAnualPurchaseReport extends StatefulWidget {
  const ListAnualPurchaseReport(
      {super.key, required this.typeReport, required this.date});
  final String typeReport;
  final String date;

  @override
  State<ListAnualPurchaseReport> createState() =>
      _ListAnualPurchaseReportState();
}

class _ListAnualPurchaseReportState extends State<ListAnualPurchaseReport> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetYearPurchase.getYearPurchase(widget.date),
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
        } else {
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
                                        "${snapshot.data!.data!.detailYearPurchase.length}",
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
                                        "${snapshot.data!.data!.totalExpenditure}",
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
                      itemCount: snapshot.data!.data!.detailYearPurchase.length,
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
                                          "${snapshot.data!.data!.detailYearPurchase[index].year}",
                                          style: const TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "${snapshot.data!.data!.detailYearPurchase[index].totalTransaction} Transaksi",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color: Colors.black,
                                          ),
                                        )
                                      ],
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
                                            "Rp. ${snapshot.data!.data!.detailYearPurchase[index].totalExpenditure}",
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
                                          if (widget.typeReport ==
                                              "Pembelian") {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MonthlyReport(
                                                  typeRaport: "Pembelian",
                                                  date:
                                                      "${snapshot.data!.data!.detailYearPurchase[index].year}-${snapshot.data!.data!.detailYearPurchase[index].month}-${snapshot.data!.data!.detailYearPurchase[index]}-1",
                                                ),
                                              ),
                                            );
                                          } else {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MonthlyReport(
                                                  typeRaport: "Penjualan",
                                                  date:
                                                      "${snapshot.data!.data!.detailYearPurchase[index].year}-${snapshot.data!.data!.detailYearPurchase[index].month}-${snapshot.data!.data!.detailYearPurchase[index]}-1",
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: const Icon(
                                            Icons.navigate_next_outlined),
                                      ),
                                    ),
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
