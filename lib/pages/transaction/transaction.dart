import 'package:flutter/material.dart';
import 'package:kasir_mobile/components/list_transaction_component.dart';
import 'package:kasir_mobile/interface/transaction.dart';
import 'package:kasir_mobile/pages/transaction/confirm_transaction.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  List<Map<String, dynamic>> products = [
    {
      "id": "1",
      "name": "Gudang Garam",
      "price": "60000",
      "remaining": "30",
      "count": 0
    },
    {
      "id": "2",
      "name": "Gudang Garam",
      "price": "60000",
      "remaining": "30",
      "count": 0
    },
    {
      "id": "3",
      "name": "Gudang Garam",
      "price": "60000",
      "remaining": "30",
      "count": 0
    },
    {
      "id": "4",
      "name": "Gudang Garam",
      "price": "60000",
      "remaining": "30",
      "count": 0
    },
    {
      "id": "5",
      "name": "Gudang Garam",
      "price": "60000",
      "remaining": "30",
      "count": 0
    },
    {
      "id": "6",
      "name": "Gudang Garam",
      "price": "60000",
      "remaining": "30",
      "count": 0
    },
    {
      "id": "7",
      "name": "Gudang Garam",
      "price": "60000",
      "remaining": "30",
      "count": 0
    },
    {
      "id": "8",
      "name": "Gudang Garam",
      "price": "60000",
      "remaining": "30",
      "count": 0
    },
    {
      "id": "9",
      "name": "Gudang Garam",
      "price": "60000",
      "remaining": "30",
      "count": 0
    },
    {
      "id": "10",
      "name": "Gudang Garam",
      "price": "60000",
      "remaining": "30",
      "count": 0
    },
  ];

  int count = 0;

  List<TransactionData> transaction = [];

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
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(width: 1, color: Color(0xffDDDDDD)))),
            padding: const EdgeInsets.only(bottom: 10, top: 10),
            child: Row(
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
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Stack(
              children: [
                ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.amber,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            try {
                              products[index]['count']++;
                              transaction.add(
                                TransactionData.add(
                                    id: products[index]["id"],
                                    name: products[index]['name'],
                                    price: products[index]['price'],
                                    count: products[index]['count'],
                                    remaining: products[index]['remaining']),
                              );
                              print('cek transaction: $transaction');
                            } catch (e, stacktrace) {
                              print(
                                  'error: $e, line: ${stacktrace.toString()}');
                            }
                          });
                        },
                        child: ListTransaction(
                          name: products[index]['name'],
                          price: products[index]['price'],
                          remaining: products[index]['remaining'],
                          count: products[index]['count'],
                        ),
                      ),
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
                                builder: (context) => ConfirmTransaction(
                                      list: transaction,
                                    )));
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
        ],
      ),
    );
  }
}
