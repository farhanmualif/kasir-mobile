import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/components/update_dialog.dart';
import 'package:kasir_mobile/interface/product_interface.dart';
import 'package:kasir_mobile/provider/get_product.dart';

class StokProductManagement extends StatefulWidget {
  const StokProductManagement({super.key});

  @override
  State<StokProductManagement> createState() => _StokProductManagementState();
}

class _StokProductManagementState extends State<StokProductManagement> {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final TextEditingController _searchController = TextEditingController();

  var domain = dotenv.env['BASE_URL'];

  Future<List<Product>> getProduct() async {
    try {
      var response = await GetProduct.getProduct(); //
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff076A68),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Manajemen Stok",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 20, top: 10),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Color(0xffD9D9D9)))),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: const Icon(Icons.filter_list_outlined),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Cari Produk",
                      prefixIcon: const Icon(Icons.search),
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
                  width: 15,
                ),
                const Expanded(
                  flex: -1,
                  child: Image(image: AssetImage("assets/images/barcode.png")),
                ),
                const SizedBox(
                  width: 15,
                ),
              ],
            ),
          ),
          FutureBuilder(
            future: getProduct(),
            builder: (context, snapshot) {
              var foundProduct = snapshot.data!;

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData == false) {
                return const Center(
                  child: Text('Data Belum Tersedia'),
                );
              } else if (snapshot.data == null) {
                return const Text('data belum tersedia');
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                void filterProducts(String query) {
                  List<Product> filteredProducts = [];

                  // Ambil data produk dari snapshot
                  if (snapshot.hasData) {
                    final products = snapshot.data!;

                    // Lakukan filtering berdasarkan nama produk
                    filteredProducts = products.where((product) {
                      final productName = product.name.toLowerCase();
                      final input = query.toLowerCase();
                      return productName.contains(input);
                    }).toList();
                  }

                  // Perbarui daftar produk yang ditampilkan
                  setState(() {
                    foundProduct = filteredProducts;
                  });
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: foundProduct.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(
                            top: 5, bottom: 15, left: 20, right: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Image(
                                image: NetworkImage(
                                  "https://$domain/storage/images/${foundProduct[index].image}",
                                ),
                                height: 70,
                                width: 70,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    foundProduct[index].name,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "kode: ${foundProduct[index].barcode ?? "0"}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "Hrg dsr: Rp. ${foundProduct[index].purchasePrice}",
                                    style: const TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              flex: -1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Stok: ${foundProduct[index].stock}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Rp. ${foundProduct[index].sellingPrice}",
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  GestureDetector(
                                      onTap: () async {
                                        var dialog = UpdateDialog(
                                            dataProduct: foundProduct[index]);
                                        dialog.showEditingFormDialog(context);
                                      },
                                      child: const Icon(Icons.edit_square))
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
