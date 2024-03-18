import 'package:flutter/material.dart';
import 'package:kasir_mobile/pages/management/management.dart';
import 'package:kasir_mobile/pages/report/report_page.dart';
import 'package:kasir_mobile/pages/transaction/transaction.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  void buyProduct(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            const Transaction(typeTransaction: "Pembelian Barang")));
  }

  void createTransaction(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Transaction(
          typeTransaction: "Transaksi",
        ),
      ),
    );
  }

  void raport() {
    debugPrint('raport cliked');
  }

  void management() {
    debugPrint('management cliked');
  }

  // get name async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Row(
              children: [
                Expanded(
                    flex: -1,
                    child: Text(
                      'Selamat Siang, Nay',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )),
                Spacer(),
                Expanded(
                  child: Text(
                    "jum'at 8 Maret 2024",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 23),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      buyProduct(context);
                    },
                    child: Container(
                      // onTap
                      padding: const EdgeInsets.all(10),
                      width: 170,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Column(
                        children: [
                          Icon(Icons.shopping_cart),
                          Text("Pembelian Barang")
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      createTransaction(context);
                    },
                    child: Row(
                      // Wrap the Padding widget with a Row widget
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            width: 170,
                            height: 72,
                            decoration: BoxDecoration(
                              color: const Color(0xffFFCA45),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  child: const Text(
                                    "+",
                                    style: TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                const Expanded(
                                  child: Text(
                                    "Buat Transaksi",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const Management(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: 170,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.storage_rounded),
                        Text("Manajemen"),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: raport,
                  child: Row(
                    // Wrap the Padding widget with a Row widget
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ReportPage(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: 170,
                            height: 72,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Column(
                              children: [
                                Icon(Icons.file_copy),
                                Text("Laporan"),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
