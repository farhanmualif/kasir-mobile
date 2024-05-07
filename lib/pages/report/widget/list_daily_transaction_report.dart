import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/pages/struk.dart';
import 'package:kasir_mobile/provider/get_daily_transaction.dart';

class ListDailyTransactionReport extends StatefulWidget {
  const ListDailyTransactionReport({super.key, required this.date});

  final String date;

  @override
  State<ListDailyTransactionReport> createState() =>
      _ListDailyTransactionReportState();
}

class _ListDailyTransactionReportState
    extends State<ListDailyTransactionReport> {
  var domain = dotenv.env['BASE_URL'];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetDailyTransaction.getdailyTransaction(widget.date),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData == false) {
            return const Center(
              child: Text('Data Belum Tersedia'),
            );
          } else if (snapshot.data == null || snapshot.data!.dailyTransaction == null) {
            return const Center(
              child: Text('data belum tersedia'),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
          if (snapshot.data?.dailyTransaction?.detailTransaction != null) {
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
                                          "${snapshot.data?.dailyTransaction?.totalTransactions}",
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
                                            "Keuntungan",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "Rp. ${snapshot.data?.dailyTransaction?.totalRevenue}",
                                            style: const TextStyle(
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Column(
                                children: [
                                  TextButton(
                                    onPressed: null,
                                    child: Column(
                                      children: [
                                        const Text(
                                          "Pendapatan",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          "Rp. ${snapshot.data?.dailyTransaction?.totalProfit}",
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
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot
                          .data!.dailyTransaction?.detailTransaction.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(
                              top: 16, left: 10, right: 10),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 1,
                                color: Color(0xffDDDDDD),
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data!.dailyTransaction!
                                          .detailTransaction[index].time,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color: Color.fromARGB(151, 0, 0, 0),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          snapshot.data!.dailyTransaction!.day,
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
                                                snapshot.data!.dailyTransaction!
                                                    .month,
                                                style: const TextStyle(
                                                    fontSize: 10),
                                              ),
                                              Text(
                                                snapshot.data!.dailyTransaction!
                                                    .year,
                                                style: const TextStyle(
                                                    fontSize: 10),
                                              ),
                                            ],
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
                                            child: const Text("Pendapatan"),
                                          ),
                                          Text(
                                            "Rp. ${snapshot.data!.dailyTransaction!.detailTransaction[index].revenue}",
                                            style: const TextStyle(
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
                                            margin: const EdgeInsets.only(
                                                bottom: 3),
                                            child: const Text("Keuntungan"),
                                          ),
                                          Text(
                                            "Rp. ${snapshot.data!.dailyTransaction!.detailTransaction[index].profit}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "No. ${snapshot.data!.dailyTransaction!.detailTransaction[index].noTransaction}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: -1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              var noTransaction = snapshot
                                                  .data!
                                                  .dailyTransaction!
                                                  .detailTransaction[index]
                                                  .noTransaction;
                                              String url =
                                                  "https://$domain/storage/invoices/invoice_$noTransaction.pdf";
                                              return Struk(url: url);
                                            },
                                          ),
                                        );
                                      },
                                      child: const Icon(
                                          Icons.navigate_next_outlined),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ]),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text("data belum tersedia"),
            );
          }
        }
      },
    );
  }
}
