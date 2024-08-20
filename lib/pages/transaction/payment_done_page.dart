import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/pages/struk/struk.dart';
import 'package:kasir_mobile/themes/AppColors.dart';

// ignore: must_be_immutable
class PaymentDone extends StatelessWidget {
  int change;
  String? noTransaction;
  String typeTransaction;
  var domain = dotenv.env['BASE_URL'];
  PaymentDone(
      {super.key,
      required this.typeTransaction,
      required this.change,
      this.noTransaction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff076A68).withOpacity(0.3),
        leading: Container(
          height: 40,
          width: 45,
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: AppColors.primary,
          ),
          child: GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/transaction',
                    arguments: {'typeTransaction': typeTransaction});
              },
              child: const Icon(
                Icons.done,
                color: Colors.white,
              )),
        ),
      ),
      body: Container(
        color: const Color(0xff076A68).withOpacity(0.3),
        child: Center(
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            padding: const EdgeInsets.all(30),
            height: 357,
            width: 321,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  typeTransaction == "Pembelian Barang"
                      ? 'Berhasil Tambah Barang !'
                      : "Pembayaran berhasil",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25.0),
                Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/icon_done.png"),
                    ),
                  ),
                ),
                const SizedBox(height: 25.0),
                Text(
                  typeTransaction == "Pembelian Barang"
                      ? ''
                      : 'Kembalian: $change',
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 22.0),
                if (typeTransaction == "Transaksi")
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffFFCA45)),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Struk(noTransaction: noTransaction),
                        ),
                      );
                    },
                    child: const Text(
                      'LIHAT STRUK',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
