import 'package:flutter/material.dart';
import 'package:kasir_mobile/components/cart_item.dart';
import 'package:kasir_mobile/helper/get_access_token.dart';

class CartPage extends StatefulWidget {
  const CartPage(
      {super.key,
      required this.subTotalPrice,
      required this.listTransaction,
      required this.typeTransaction});

  final Map<int, Map<String, dynamic>> listTransaction;
  final String typeTransaction;
  final int subTotalPrice;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with AccessTokenProvider {
  Map<int, Map<String, dynamic>> groupedProducts = {};
  int totalPrice = 0;
  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff076A68),
        title: Text(
          widget.typeTransaction,
          style: const TextStyle(color: Colors.white),
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
                CartItem(
                    subTotalPrice: widget.subTotalPrice,
                    listTransaction: widget.listTransaction,
                    typeTransaction: widget.typeTransaction)
              ],
            ),
    );
  }
}
