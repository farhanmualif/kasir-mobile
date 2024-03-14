import 'package:flutter/material.dart';
import 'package:kasir_mobile/components/confirm_transaction_component.dart';
import 'package:kasir_mobile/interface/transaction.dart';
import 'package:kasir_mobile/pages/transaction/payment.dart';

class ConfirmTransaction extends StatefulWidget {
  const ConfirmTransaction({Key? key, required this.list}) : super(key: key);

  final List<TransactionData> list;

  @override
  State<ConfirmTransaction> createState() => _ConfirmTransactionState();
}

class _ConfirmTransactionState extends State<ConfirmTransaction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff076A68),
        title: const Text(
          "Transaksi",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        margin: EdgeInsets.only(top: 50),
        child: Stack(
          children: [
            ListView.builder(
              itemCount: widget.list.length,
              itemBuilder: (context, index) {
                return ConfirmTransactionComponent(
                  index: index + 1,
                  name: widget.list[index].name,
                  count: widget.list[index].count,
                  price: widget.list[index].price,
                );
              },
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: 20),
              child: Container(
                decoration: const BoxDecoration(
                    color: Color(0xffFFCA45),
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                width: 330,
                height: 60,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Payment()));
                  },
                  child: const Row(
                    children: [
                      Expanded(
                          child: Text(
                        '4',
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff000000)),
                      )),
                      Expanded(
                          flex: -1,
                          child: Text(
                            "Lanjut",
                            style: TextStyle(color: Color(0xff000000)),
                          )),
                      Expanded(
                        flex: -1,
                        child: Icon(
                          Icons.navigate_next,
                          color: Color(0xff000000),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
