import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/interface/transaction_interface.dart';
import 'package:kasir_mobile/pages/transaction/confirm_transaction.dart';
import 'package:kasir_mobile/pages/transaction/form_add_product.dart';
import 'package:kasir_mobile/provider/get_product.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key, required this.typeTransaction});

  final String typeTransaction;

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  int count = 0;

  var domain = dotenv.env['BASE_URL'];

  List<TransactionData> transaction = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff076A68),
        title: Text(
          widget.typeTransaction,
          style: const TextStyle(color: Colors.white),
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
                    child: const Icon(Icons.search)),
              ],
            ),
          ),
          // typeTransactionPembelian Barang
          if (widget.typeTransaction == "Pembelian Barang")
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const FormAddProductPage()));
              },
              child: Container(
                height: 85,
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Expanded(
                      flex: -1,
                      child: Container(
                        margin: const EdgeInsets.only(right: 16),
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                          color: Color(0xffD9D9D9),
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: const Icon(Icons.add),
                      ),
                    ),
                    const Text(
                      "Tambah Barang",
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
            ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.75758,
            child: FutureBuilder(
              future: GetProduct.getProduct(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.data?.data != null) {
                    return Stack(
                      children: [
                        ListView.builder(
                          itemCount: snapshot.data?.data.length,
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
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              "https://$domain/storage/images/${snapshot.data!.data[index].image}",
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data!.data[index].name,
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "${snapshot.data!.data[index].stock}",
                                                style: const TextStyle(
                                                    fontSize: 10),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    left: 5, right: 5),
                                                child: const Icon(
                                                  Icons.do_not_disturb_on_sharp,
                                                  size: 10,
                                                ),
                                              ),
                                              Text(
                                                  "Rp.${snapshot.data!.data[index].sellingPrice}",
                                                  style: const TextStyle(
                                                      fontSize: 10))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if (snapshot
                                                    .data!.data[index].stock ==
                                                0) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  duration: const Duration(
                                                      seconds: 1),
                                                  content: Text(
                                                      'Stok ${snapshot.data!.data[index].name} kosong'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            } else {
                                              setState(() {
                                                if (transaction.isNotEmpty) {
                                                  final lastIndexs = transaction
                                                      .lastIndexWhere(
                                                          (element) =>
                                                              element.id ==
                                                              snapshot
                                                                  .data!
                                                                  .data[index]
                                                                  .id);

                                                  if (lastIndexs != -1) {
                                                    transaction
                                                        .removeAt(lastIndexs);
                                                  }
                                                }
                                              });
                                            }
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            height: 35,
                                            width: 25,
                                            decoration: const BoxDecoration(
                                                color: Color(0xffE0EBFF),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 20),
                                              child: const Icon(Icons.minimize),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          height: 35,
                                          width: 20,
                                          decoration: const BoxDecoration(
                                              color: Color(0xffE0EBFF),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child: Center(
                                              child: Text(transaction
                                                  .where((element) =>
                                                      element.id ==
                                                      snapshot
                                                          .data!.data[index].id)
                                                  .length
                                                  .toString())),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (snapshot
                                                    .data!.data[index].stock ==
                                                0) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  duration: const Duration(
                                                      seconds: 5),
                                                  content: Text(
                                                      'Stok ${snapshot.data!.data[index].name} kosong'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            } else {
                                              setState(() {
                                                transaction.add(TransactionData.set(
                                                    image:
                                                        "https://$domain/storage/images/${snapshot.data!.data[index].image}",
                                                    id: snapshot
                                                        .data!.data[index].id,
                                                    name: snapshot
                                                        .data!.data[index].name,
                                                    price: snapshot
                                                        .data!
                                                        .data[index]
                                                        .sellingPrice,
                                                    remaining: snapshot.data!
                                                        .data[index].stock));
                                              });
                                            }
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                right: 10),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            width: 330,
                            height: 60,
                            child: TextButton(
                              onPressed: () {
                                if (transaction.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ConfirmTransaction(
                                        listTransaction: transaction,
                                      ),
                                    ),
                                  );
                                }
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
                                        style:
                                            TextStyle(color: Color(0xff000000)),
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
                    );
                  } else {
                    return const Text("Produk Kosong");
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
