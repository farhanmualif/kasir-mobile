import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kasir_mobile/pages/management/management.dart';
import 'package:kasir_mobile/pages/report/report_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  void _buyProduct(BuildContext context) {
    Navigator.pushNamed(context, '/transaction',
        arguments: {'typeTransaction': 'Pembelian Barang'});
  }

  void _createTransaction(BuildContext context) {
    Navigator.pushNamed(context, "/transaction",
        arguments: {"typeTransaction": "Transaksi"});
  }

  void _raport() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ReportPage(),
      ),
    );
  }

  void management() {
    debugPrint('management cliked');
  }

  Future<String?> _getUsername() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("name");
  }

  String _dateNow() {
    DateTime now = DateTime.now();
    return DateFormat("EEEE, d MMMM").format(now);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(20),
        child: _cardMenu(),
      ),
    );
  }

  Widget _headBuild() {
    return Row(
      children: [_sayUser(), const Spacer(), _dateBuild()],
    );
  }

  Widget _sayUser() {
    return FutureBuilder<String?>(
      future: _getUsername(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("");
        } else {
          if (snapshot.hasData) {
            return Expanded(
              flex: -1,
              child: Text(
                "Hello ${snapshot.data!}",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return const Text("");
          }
        }
      },
    );
  }

  Widget _dateBuild() {
    return Expanded(
      child: Text(
        _dateNow(),
        textAlign: TextAlign.end,
        style: const TextStyle(fontSize: 11),
      ),
    );
  }

  Widget _cardMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _headBuild(),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buyProductCard(),
            const Spacer(),
            _transactionCard(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _managementCard(),
            const Spacer(),
            _reportCard(),
          ],
        ),
      ],
    );
  }

  Widget _buyProductCard() {
    return GestureDetector(
      onTap: () {
        _buyProduct(context);
      },
      child: Container(
        // onTap
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width * 0.4,
        height: 72,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Column(
          children: [Icon(Icons.shopping_cart), Text("Pembelian Barang")],
        ),
      ),
    );
  }

  Widget _transactionCard() {
    return GestureDetector(
      onTap: () {
        _createTransaction(context);
      },
      child: Row(
        // Wrap the Padding widget with a Row widget
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xffFFCA45),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15),
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
    );
  }

  Widget _managementCard() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const Management(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width * 0.4,
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
    );
  }

  Widget _reportCard() {
    return GestureDetector(
      onTap: () {
        _raport();
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width * 0.4,
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
    );
  }
}
