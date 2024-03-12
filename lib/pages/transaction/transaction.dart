import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff076A68),
        title: const Text(
          "Transaction",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Spacer(),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: const Icon(Icons.document_scanner_outlined),
                ),
                Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: const Icon(Icons.qr_code_scanner_outlined)),
                Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: const Icon(Icons.add)),
                Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: const Icon(Icons.search)),
              ],
            ),
            Container(
              child: Row(
                children: [
                  Text('foto'),
                  Column(
                    children: [Text('nama'), Text('sisa')],
                  ),
                  Text('jumlah')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
