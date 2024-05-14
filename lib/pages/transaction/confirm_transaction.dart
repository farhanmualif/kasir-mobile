import 'package:flutter/material.dart';
import 'package:kasir_mobile/interface/transaction_interface.dart';
import 'package:kasir_mobile/pages/transaction/payment.dart';
import 'package:kasir_mobile/pages/transaction/transaction.dart';
import 'package:kasir_mobile/provider/update_product.dart';

class ConfirmTransaction extends StatefulWidget {
  const ConfirmTransaction(
      {super.key,
      required this.listTransaction,
      required this.typeTransaction});

  final List<TransactionData> listTransaction;
  final String typeTransaction;

  @override
  State<ConfirmTransaction> createState() => _ConfirmTransactionState();
}

class _ConfirmTransactionState extends State<ConfirmTransaction> {
  Map<int, Map<String, dynamic>> groupedProducts = {};
  int totalPrice = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    for (var product in widget.listTransaction) {
      int id = product.id;
      if (groupedProducts.containsKey(id)) {
        groupedProducts[id]!['count']++;
      } else {
        groupedProducts[id] = {
          'id': product.id,
          'uuid': product.uuid,
          'barcode': product.barcode,
          'name': product.name,
          'price': product.price,
          'purchasePrice': product.purcahsePrice,
          'count': 1, // Inisialisasi count dengan 1
          'remaining': product.remaining,
          'image': product.image
        };
      }
    }
  }

  int calculateTotalPrice() {
    totalPrice = 0;
    for (var product in groupedProducts.values) {
      int quantity = product['count'];
      int price = product['price'].toInt();
      totalPrice += quantity * price;
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('type transaction 2: ${widget.typeTransaction}');
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff076A68),
        title: const Text(
          "Transaksi",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              // top menu
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom:
                              BorderSide(width: 1, color: Color(0xffDDDDDD)))),
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
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Stack(
                    children: [
                      ListView.builder(
                        itemCount: groupedProducts.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> product =
                              groupedProducts.values.toList()[index];

                          int quantity = product['count'];
                          int price = product['price'].toInt();
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
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    flex: -1,
                                    child: Container(
                                      margin: const EdgeInsets.all(5),
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  product['image']!))),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product['name'],
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              quantity.toString(),
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 5, right: 5),
                                              child: const Text("x"),
                                            ),
                                            Text(product['price'].toString(),
                                                style: const TextStyle(
                                                    fontSize: 10))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // print(groupedProducts.keys.toList()[index]);

                                      setState(() {
                                        groupedProducts
                                            .removeWhere((key, value) {
                                          widget.listTransaction.removeWhere(
                                              (element) =>
                                                  element.id ==
                                                  groupedProducts.values
                                                      .toList()[index]['id']);
                                          return key ==
                                              groupedProducts.keys
                                                  .toList()[index];
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          width: 330,
                          height: 60,
                          child: TextButton(
                            onPressed: () async {
                              if (widget.typeTransaction == "Transaksi") {
                                setState(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Payment(
                                        totalPrice: calculateTotalPrice(),
                                        listTransaction: groupedProducts,
                                      ),
                                    ),
                                  );
                                });
                              } else {
                                List<bool> response = [];
                                setState(() {
                                  _isLoading = true;
                                });
                                try {
                                  for (var product
                                      in groupedProducts.values.toList()) {
                                    var res = await updateProduct(
                                        uuid: product['uuid'],
                                        name: product['name'],
                                        barcode: product['barcode'] ?? "",
                                        quantityStock: product['count'],
                                        sellingPrice: product['price'],
                                        purchasePrice: product['purchasePrice'],
                                        addOrreduceStock: "add");
                                    response.add(res);
                                  }
                                } catch (e) {
                                  rethrow;
                                }
                                setState(() {
                                  _isLoading = false;
                                });
                                for (var resp in response) {
                                  if (!resp) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        duration: Duration(seconds: 1),
                                        content: Text('Terjadi Kesalahan'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                                setState(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Transaction(
                                          typeTransaction:
                                              widget.typeTransaction),
                                    ),
                                  );
                                });
                              }
                            },
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "Rp. ${calculateTotalPrice()}",
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff000000)),
                                )),
                                Expanded(
                                    flex: -1,
                                    child: Text(
                                      widget.typeTransaction == "Transaksi"
                                          ? "Lanjut"
                                          : "Update",
                                      style: const TextStyle(
                                          color: Color(0xff000000)),
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

  Future updateProduct(
      {required String uuid,
      required String name,
      required String barcode,
      required int quantityStock,
      required double sellingPrice,
      required double purchasePrice,
      required String addOrreduceStock}) async {
    try {
      var response = await UpdateProduct.put(uuid, name, barcode, quantityStock,
          sellingPrice, purchasePrice, addOrreduceStock);
      return response.status;
    } catch (e) {
      rethrow;
    }
  }
}
