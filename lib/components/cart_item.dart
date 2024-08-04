// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kasir_mobile/helper/format_cuurency.dart';
import 'package:kasir_mobile/helper/get_access_token.dart';

import 'package:kasir_mobile/helper/show_snack_bar.dart';
import 'package:kasir_mobile/interface/product_interface.dart';
import 'package:kasir_mobile/provider/update_product_provider.dart';

class CartItem extends StatefulWidget {
  CartItem(
      {super.key,
      required this.listTransaction,
      required this.typeTransaction,
      required this.subTotalPrice});

  final Map<int, Map<String, dynamic>> listTransaction;
  final String typeTransaction;
  int subTotalPrice;

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> with AccessTokenProvider {
  String? _accessToken;

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
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      height: MediaQuery.of(context).size.height * 0.8,
      child: Stack(
        children: [
          ListView.builder(
            itemCount: widget.listTransaction.length,
            itemBuilder: (context, index) {
              List<Product> products = widget.listTransaction.values
                  .toList()
                  .map((e) => Product.set(
                      id: e['id'],
                      uuid: e['uuid'],
                      name: e['name'],
                      image: e['image'],
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
                            Row(
                              children: [
                                Text(
                                  "${product.selected}",
                                  style: const TextStyle(fontSize: 10),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: const Text("x"),
                                ),
                                Text(convertToIdr(product.price),
                                    style: const TextStyle(fontSize: 10))
                              ],
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.listTransaction.removeWhere((key, value) {
                              return key ==
                                  widget.listTransaction.keys.toList()[index];
                            });
                            widget.subTotalPrice =
                                widget.subTotalPrice.toInt() -
                                    (product.price.toInt() * product.selected!);
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
                onPressed: () async {
                  if (widget.typeTransaction == "Transaksi") {
                    setState(() {
                      Navigator.pushNamed(context, "/payment", arguments: {
                        'totalPrice': widget.subTotalPrice,
                        'listTransaction': widget.listTransaction,
                      });
                    });
                  } else {
                    bool response = false;
                    setState(() {});
                    try {
                      setState(() {});

                      for (var product
                          in widget.listTransaction.values.toList()) {
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
