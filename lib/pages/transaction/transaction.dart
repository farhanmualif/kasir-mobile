import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/components/barcode_camera.dart';
import 'package:kasir_mobile/helper/format_cuurency.dart';
import 'package:kasir_mobile/interface/product_interface.dart';
import 'package:kasir_mobile/interface/transaction_interface.dart';
import 'package:kasir_mobile/pages/home/home_app.dart';
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
  List<TransactionData> transactions = [];
  List<Product> findProduct = [];
  final searchBarController = TextEditingController();
  int subTotal = 0;
  bool _isLoading = true;
  bool _buttonEnable = false;
  int fullStock = 0;

  Future<List<Product>> getProduct() async {
    try {
      var response = await GetProduct.getProduct(); //
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    getProduct().then((value) {
      setState(() {
        findProduct = value;
        _isLoading = false;
      });
    });
  }

  void onQueryChanged(String query) {
    getProduct().then((products) {
      setState(() {
        findProduct = products
            .where((item) =>
                item.name.toLowerCase().contains(query.toLowerCase()) ||
                (item.barcode != null &&
                    item.barcode!.toLowerCase().contains(query.toLowerCase())))
            .toList();
      });
    });
  }

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Tambahkan logika untuk kembali ke halaman sebelumnya
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeApp(),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(width: 1, color: Color(0xffDDDDDD)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchBarController,
                      onChanged: onQueryChanged,
                      decoration: InputDecoration(
                        hintText: "Cari Produk",
                        suffixIcon: const Icon(
                          Icons.search,
                          size: 35,
                        ),
                        isDense: true,
                        isCollapsed: true,
                        contentPadding: const EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: -1,
                    child: GestureDetector(
                      onTap: () async {
                        try {
                          var barcodeResult = await BarcodeCamera().scanner();

                          setState(() {
                            searchBarController.text = barcodeResult;
                          });
                        } catch (e) {
                          rethrow;
                        }
                      },
                      child: const Image(
                          image: AssetImage("assets/images/barcode.png")),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.typeTransaction == "Pembelian Barang")
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const FormAddProductPage()));
                },
                child: Container(
                  height: 60,
                  margin: const EdgeInsets.only(left: 15, right: 15),
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
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.95,
              child: Stack(
                children: [
                  _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: findProduct.length,
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
                                              "http://$domain/storage/images/${findProduct[index].image}",
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
                                            findProduct[index].name,
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Stok: ${findProduct[index].stock}",
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
                                                  convertToIdr(
                                                      findProduct[index]
                                                          .sellingPrice),
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
                                            if (findProduct[index].stock == 0 &&
                                                widget.typeTransaction ==
                                                    "Transaksi") {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  duration: const Duration(
                                                      seconds: 1),
                                                  content: Text(
                                                      'Stok ${findProduct[index].name} kosong'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            } else {
                                              setState(() {
                                                if (transactions.isNotEmpty) {
                                                  final lastIndexs =
                                                      transactions
                                                          .lastIndexWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  findProduct[
                                                                          index]
                                                                      .id);

                                                  if (lastIndexs != -1) {
                                                    subTotal -=
                                                        transactions[lastIndexs]
                                                            .price
                                                            .toInt();
                                                    transactions
                                                        .removeAt(lastIndexs);
                                                  }
                                                }
                                              });

                                              if (fullStock >= 1) {
                                                setState(() {
                                                  fullStock--;
                                                });
                                              }

                                              if (fullStock < 1) {
                                                setState(() {
                                                  _buttonEnable = true;
                                                });
                                              }
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
                                                  Radius.circular(5)),
                                            ),
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
                                              child: Text(transactions
                                                  .where((element) =>
                                                      element.id ==
                                                      findProduct[index].id)
                                                  .length
                                                  .toString())),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (findProduct[index].stock == 0 &&
                                                widget.typeTransaction ==
                                                    "Transaksi") {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  duration: const Duration(
                                                      seconds: 5),
                                                  content: Text(
                                                      'Stok ${findProduct[index].name} kosong'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            } else {
                                              if (transactions
                                                      .where((element) =>
                                                          element.id ==
                                                          findProduct[index].id)
                                                      .length <
                                                  findProduct[index].stock) {
                                                setState(() {
                                                  transactions.add(
                                                    TransactionData.set(
                                                        purcahsePrice:
                                                            findProduct[index]
                                                                .purchasePrice,
                                                        barcode:
                                                            findProduct[index]
                                                                .barcode,
                                                        uuid: findProduct[index]
                                                            .uuid,
                                                        image:
                                                            "http://$domain/storage/images/${findProduct[index].image}",
                                                        id: findProduct[index]
                                                            .id,
                                                        name: findProduct[index]
                                                            .name,
                                                        price:
                                                            findProduct[index]
                                                                .sellingPrice,
                                                        remaining:
                                                            findProduct[index]
                                                                .stock,
                                                        selected: 1),
                                                  );
                                                  subTotal += findProduct[index]
                                                      .sellingPrice
                                                      .toInt();
                                                  _buttonEnable = true;
                                                });
                                              }
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
                                                  Radius.circular(5)),
                                            ),
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
                    margin: const EdgeInsets.only(bottom: 80),
                    child: Container(
                      decoration: BoxDecoration(
                          color: widget.typeTransaction == "Transaksi"
                              ? (_buttonEnable
                                  ? const Color(0xffFFCA45)
                                  : const Color.fromARGB(255, 255, 240, 202))
                              : const Color(0xffFFCA45),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50))),
                      width: 330,
                      height: 60,
                      child: TextButton(
                        onPressed: _buttonEnable
                            ? () {
                                if (transactions.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ConfirmTransaction(
                                        listTransaction: transactions,
                                        typeTransaction: widget.typeTransaction,
                                      ),
                                    ),
                                  );
                                }
                              }
                            : null,
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                              convertToIdr(subTotal),
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff000000)),
                            )),
                            Expanded(
                                flex: -1,
                                child: Text(
                                  widget.typeTransaction == "Pembelian Barang"
                                      ? "Update"
                                      : "Lanjut",
                                  style:
                                      const TextStyle(color: Color(0xff000000)),
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
      ),
    );
  }
}
