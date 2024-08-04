// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/helper/format_cuurency.dart';
import 'package:kasir_mobile/helper/get_access_token.dart';

import 'package:kasir_mobile/helper/show_snack_bar.dart';
import 'package:kasir_mobile/interface/product_interface.dart';
import 'package:kasir_mobile/provider/update_product_provider.dart';

class BarcodeScannerResultItem extends StatefulWidget {
  BarcodeScannerResultItem({
    super.key,
    required this.listProduct,
    required this.typeTransaction,
    required this.subTotalPrice,
  });
  late int subTotalPrice;

  final Map<int, Map<String, dynamic>> listProduct;
  final String typeTransaction;

  @override
  State<BarcodeScannerResultItem> createState() =>
      _BarcodeScannerResultItemState();
}

class _BarcodeScannerResultItemState extends State<BarcodeScannerResultItem>
    with AccessTokenProvider {
  String? _accessToken;
  var domain = dotenv.env["BASE_URL"];

  Future<void> _initializeToken() async {
    _accessToken = await getToken();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initializeToken();
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

  @override
  Widget build(BuildContext context) {
    print("widget.listProduct : ${widget.listProduct}");
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      height: MediaQuery.of(context).size.height * 0.8,
      child: Stack(
        children: [
          ListView.builder(
            itemCount: widget.listProduct.length,
            itemBuilder: (context, index) {
              List<Product> products = widget.listProduct.values
                  .toList()
                  .map((e) => Product.set(
                      id: e['id'],
                      uuid: e['uuid'],
                      name: e['name'],
                      image: "$domain/api/products/images/${e['uuid']}",
                      price: e['price'],
                      purchasePrice: e['purchasePrice'],
                      barcode: e['barcode'],
                      remaining: e['remaining'],
                      selected: e['count']))
                  .toList();

              Product product = products[index];

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
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(product.image,
                                    headers: {
                                      "Authorization": "Bearer $_accessToken",
                                      "Access-Control-Allow-Headers":
                                          "Access-Control-Allow-Origin, Accept"
                                    }),
                                fit: BoxFit.cover,
                              )),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(convertToIdr(product.price),
                                style: const TextStyle(fontSize: 10))
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: 5, // Atur lebar sesuai kebutuhan
                              child: TextField(
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 0),
                                ),
                                onChanged: (value) {
                                  int count = int.tryParse(value) ?? 0;
                                  // Tambahkan logika untuk memperbarui jumlah produk di sini
                                },
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                widget.listProduct.removeWhere((key, value) {
                                  return key ==
                                      widget.listProduct.keys.toList()[index];
                                });
                                widget.subTotalPrice = widget.subTotalPrice
                                        .toInt() -
                                    (product.price.toInt() * product.selected!);
                              });
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Color(0xffFF0000),
                            ),
                          )
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
                onPressed: () async {
                  if (widget.typeTransaction == "Transaksi") {
                    setState(() {
                      Navigator.pushNamed(context, "/payment", arguments: {
                        'totalPrice': widget.subTotalPrice,
                        'listProduct': widget.listProduct,
                      });
                    });
                  } else {
                    bool response = false;
                    setState(() {});
                    try {
                      setState(() {});

                      for (var product in widget.listProduct.values.toList()) {
                        var res = await updateProduct(
                            uuid: product['uuid'],
                            name: product['name'],
                            barcode: product['barcode'] ?? "",
                            quantityStock: product['count'],
                            sellingPrice: product['price'],
                            purchasePrice: product['purchasePrice'],
                            addOrreduceStock: "add");
                        setState(() {
                          response = res;
                        });
                      }

                      setState(() {
                        showSnackbar(response, context);
                      });
                    } catch (e) {
                      rethrow;
                    }

                    setState(() {
                      Navigator.pushReplacementNamed(context, '/transaction',
                          arguments: {
                            'typeTransaction': widget.typeTransaction
                          });
                    });
                  }
                },
                child: Row(
                  children: [
                    Expanded(
                        child: Text(
                      convertToIdr(widget.subTotalPrice),
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
                          style: const TextStyle(color: Color(0xff000000)),
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
    );
  }
}
