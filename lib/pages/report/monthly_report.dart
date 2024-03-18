import 'package:flutter/material.dart';
import 'package:kasir_mobile/helper/get_now.dart';
import 'package:kasir_mobile/pages/report/daily_report.dart';

class MonthlyReport extends StatelessWidget {
  const MonthlyReport({super.key, required this.typeRaport});

  final String typeRaport;

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
              '$typeRaport Bulan Ini',
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
      body: CustomScrollView(
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
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: const Column(
                          children: [
                            TextButton(
                              onPressed: null,
                              child: Column(
                                children: [
                                  Text(
                                    "Jml Transaksi",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    "3",
                                    style: TextStyle(
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
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: const Column(
                          children: [
                            TextButton(
                                onPressed: null,
                                child: Column(
                                  children: [
                                    Text(
                                      "Keuntungan",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      "15.000",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Color(0xff076A68),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: const Column(
                          children: [
                            TextButton(
                              onPressed: null,
                              child: Column(
                                children: [
                                  Text(
                                    "Pendapatan",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    "Rp. 25000",
                                    style: TextStyle(
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
                  itemCount: 10,
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
                                    const Text(
                                      "10",
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 3),
                                      child: const Column(
                                        children: [
                                          Text(
                                            "Mar",
                                            style: TextStyle(fontSize: 10),
                                          ),
                                          Text(
                                            "2024",
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Text(
                                  "10 Transaksi",
                                  style: TextStyle(
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
                                        margin:
                                            const EdgeInsets.only(bottom: 3),
                                        child: const Text("Pendapatan"),
                                      ),
                                      const Text(
                                        "Rp. 45.000",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 3),
                                        child: const Text("Keuntungan"),
                                      ),
                                      const Text(
                                        "Rp. 20.000",
                                        style: TextStyle(
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
                                          if (typeRaport == "Pembelian") {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const DailyReport(
                                                        typeRaport:
                                                            "Pembelian"),
                                              ),
                                            );
                                          } else {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const DailyReport(
                                                        typeRaport:
                                                            "Penjualan"),
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
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
