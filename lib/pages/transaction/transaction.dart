import 'package:flutter/material.dart';
import 'package:kasir_mobile/interface/transaction_interface.dart';
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
      "name": "Susu frisionflag",
      "price": "1500",
      "remaining": "5",
      "count": 0
    },
    {
      "id": "3",
      "name": "Aqua Galon",
      "price": "20000",
      "remaining": "10",
      "count": 0
    },
    {
      "id": "4",
      "name": "Le mineral",
      "price": "3000",
      "remaining": "21",
      "count": 0
    },
    {
      "id": "5",
      "name": "Roma Kelapa",
      "price": "5000",
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
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.85,
            child: Stack(
              children: [
                ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: -1,
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                height: 50,
                                width: 50,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/image.png"))),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    products[index]['name'],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        products[index]['remaining'],
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        child: const Icon(
                                          Icons.do_not_disturb_on_sharp,
                                          size: 10,
                                        ),
                                      ),
                                      Text("Rp.${products[index]['price']}",
                                          style: const TextStyle(fontSize: 10))
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (transaction.isNotEmpty) {
                                        final lastIndexs = transaction
                                            .lastIndexWhere((element) =>
                                                element.id ==
                                                products[index]['id']);

                                        if (lastIndexs != -1) {
                                          transaction.removeAt(lastIndexs);
                                        }
                                      }
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    height: 35,
                                    width: 25,
                                    decoration: const BoxDecoration(
                                        color: Color(0xffE0EBFF),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      child: const Icon(Icons.minimize),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  height: 35,
                                  width: 20,
                                  decoration: const BoxDecoration(
                                      color: Color(0xffE0EBFF),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Center(
                                      child: Text(transaction
                                          .where((element) =>
                                              element.id ==
                                              products[index]['id'])
                                          .length
                                          .toString())),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      transaction.add(TransactionData.set(
                                          id: products[index]['id'],
                                          name: products[index]['name'],
                                          price: products[index]['price'],
                                          remaining: products[index]
                                              ['remaining']));
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    height: 35,
                                    width: 25,
                                    decoration: const BoxDecoration(
                                        color: Color(0xffE0EBFF),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: const Icon(Icons.add),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    );
                  },
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.only(bottom: 20),
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
                              listTransaction: transaction,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            transaction.length.toString(),
                            style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff000000)),
                          )),
                          const Expanded(
                              flex: -1,
                              child: Text(
                                "Lanjut",
                                style: TextStyle(color: Color(0xff000000)),
                              )),
                          const Expanded(
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
