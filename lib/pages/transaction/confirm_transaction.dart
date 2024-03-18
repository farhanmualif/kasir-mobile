import 'package:flutter/material.dart';
import 'package:kasir_mobile/interface/transaction_interface.dart';
import 'package:kasir_mobile/pages/transaction/payment.dart';

class ConfirmTransaction extends StatefulWidget {
  const ConfirmTransaction({super.key, required this.listTransaction});

  final List<TransactionData> listTransaction;

  @override
  State<ConfirmTransaction> createState() => _ConfirmTransactionState();
}

class _ConfirmTransactionState extends State<ConfirmTransaction> {
  Map<int, Map<String, dynamic>> groupedProducts = {};
  int totalPrice = 0;

  @override
  void initState() {
    super.initState();
    for (var product in widget.listTransaction) {
      int id = int.parse(product.id);
      if (groupedProducts.containsKey(id)) {
        groupedProducts[id]!['count']++;
      } else {
        groupedProducts[id] = {
          'id': product.id,
          'name': product.name,
          'price': product.price,
          'count': 1, // Inisialisasi count dengan 1
          'remaining': product.remaining,
        };
      }
    }
    debugPrint('groupedProduct $groupedProducts');
    debugPrint('listTransaction ${widget.listTransaction}');
  }

  int calculateTotalPrice() {
    totalPrice = 0;
    for (var product in groupedProducts.values) {
      int quantity = product['count'];
      int price = int.parse(product['price']);
      totalPrice += quantity * price;
    }
    return totalPrice;
  }

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
        // top menu
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
            height: MediaQuery.of(context).size.height * 0.8,
            child: Stack(
              children: [
                ListView.builder(
                  itemCount: groupedProducts.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> product =
                        groupedProducts.values.toList()[index];
                    int quantity = product['count'];
                    int price = int.parse(product['price']);
                    totalPrice = quantity * price;
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: -1,
                              child: Text(
                                (index + 1).toString(),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
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
                                    product['name'],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        quantity.toString(),
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        child: const Text("x"),
                                      ),
                                      Text(product['price'].toString(),
                                          style: const TextStyle(fontSize: 10))
                                    ],
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // print(groupedProducts.keys.toList()[index]);

                                setState(() {
                                  groupedProducts.removeWhere((key, value) {
                                    widget.listTransaction.removeWhere(
                                        (element) =>
                                            element.id ==
                                            groupedProducts.values
                                                .toList()[index]['id']);
                                    return key ==
                                        groupedProducts.keys.toList()[index];
                                  });
                                });
                              },
                              child: const Icon(
                                Icons.delete,
                                color: Color(0xffFF0000),
                              ),
                            )
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
                        // print("cek listTransaction: ${widget.listTransaction}");
                        // print("cek listTransaction: $groupedProducts");
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Payment(
                                totalPrice: calculateTotalPrice(),
                                listTransaction: widget.listTransaction,
                              ),
                            ),
                          );
                        });
                      },
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            widget.listTransaction.length.toString(),
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
