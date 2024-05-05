// transaction.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/interface/product_interface.dart';
import 'package:kasir_mobile/interface/transaction_interface.dart';
import 'package:kasir_mobile/pages/transaction/confirm_transaction.dart';
// import 'package:kasir_mobile/pages/transaction/form_add_product.dart';
import 'package:kasir_mobile/provider/get_product.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key, required this.typeTransaction});

  final String typeTransaction;

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  final _searchController = TextEditingController();
  List<Product> _products = [];
  List<TransactionData> _transaction = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final getProductResponse = await GetProduct.getProduct();
    setState(() {
      _products = getProductResponse.data;
    });
  }

  void _onQueryChanged(String query) {
    setState(() {
      _products = _products
          .where(
              (item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _SearchBar(
              controller: _searchController,
              onQueryChanged: _onQueryChanged,
            ),
            _ProductList(
              products: _products,
              transaction: _transaction,
              onAddProduct: (product) {
                setState(() {
                  _transaction.add(TransactionData.set(
                    image: product.image,
                    id: product.id,
                    name: product.name,
                    price: product.sellingPrice,
                    remaining: product.stock,
                  ));
                });
              },
              onRemoveProduct: (product) {
                setState(() {
                  _transaction
                      .removeWhere((element) => element.id == product.id);
                });
              },
            ),
            _TransactionButton(
              transaction: _transaction,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmTransaction(
                      listTransaction: _transaction,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// search_bar.dart
class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.onQueryChanged,
  });

  final TextEditingController controller;
  final void Function(String) onQueryChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1, color: Color(0xffDDDDDD)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onQueryChanged,
              decoration: InputDecoration(
                hintText: "Cari Kategori",
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
          const Icon(Icons.qr_code_scanner_outlined),
        ],
      ),
    );
  }
}

// product_list.dart
class _ProductList extends StatelessWidget {
  const _ProductList({
    required this.products,
    required this.transaction,
    required this.onAddProduct,
    required this.onRemoveProduct,
  });

  final List<Product> products;
  final List<TransactionData> transaction;
  final void Function(Product) onAddProduct;
  final void Function(Product) onRemoveProduct;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.74,
      width: MediaQuery.of(context).size.width * 0.95,
      child: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          final isInTransaction =
              transaction.any((element) => element.id == product.id);
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
                            "https://${dotenv.env['BASE_URL']}/storage/images/${product.image}",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
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
                              "${product.stock}",
                              style: const TextStyle(fontSize: 10),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 5, right: 5),
                              child: const Icon(
                                Icons.do_not_disturb_on_sharp,
                                size: 10,
                              ),
                            ),
                            Text("Rp.${product.sellingPrice}",
                                style: const TextStyle(fontSize: 10))
                          ],
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      if (!isInTransaction)
                        GestureDetector(
                          onTap: () {
                            if (product.stock == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 1),
                                  content: Text('Stok ${product.name} kosong'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              onAddProduct(product);
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            height: 35,
                            width: 25,
                            decoration: const BoxDecoration(
                                color: Color(0xffE0EBFF),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: const Icon(Icons.add),
                          ),
                        ),
                      if (isInTransaction)
                        GestureDetector(
                          onTap: () {
                            if (product.stock == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: const Duration(seconds: 1),
                                  content: Text('Stok ${product.name} kosong'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else {
                              onRemoveProduct(product);
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            height: 35,
                            width: 25,
                            decoration: const BoxDecoration(
                                color: Color(0xffE0EBFF),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: const Icon(Icons.minimize),
                          ),
                        ),
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        height: 35,
                        width: 20,
                        decoration: const BoxDecoration(
                            color: Color(0xffE0EBFF),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Center(
                            child: Text(transaction
                                .where((element) => element.id == product.id)
                                .length
                                .toString())),
                      ),
                    ],
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}

// transaction_button.dart
class _TransactionButton extends StatelessWidget {
  const _TransactionButton({
    required this.transaction,
    required this.onPressed,
  });

  final List<TransactionData> transaction;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: const BoxDecoration(
            color: Color(0xffFFCA45),
            borderRadius: BorderRadius.all(Radius.circular(50))),
        width: 330,
        height: 60,
        child: TextButton(
          onPressed: onPressed,
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
    );
  }
}
