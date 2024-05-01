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
  var domain = dotenv.env['BASE_URL'];
  List<Product> findProduct = [];
  bool isLoading = true;

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
        isLoading = false;
      });
    });
  }

  void onQueryChanged(String query) {
    getProduct().then((products) {
      setState(() {
        findProduct = products
            .where(
                (item) => item.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    });
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
                    onChanged: onQueryChanged,
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
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: findProduct.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(
                            top: 5, bottom: 15, left: 20, right: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Image(
                                image: NetworkImage(
                                  "https://$domain/storage/images/${findProduct[index].image}",
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
                                    findProduct[index].name,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "kode: ${findProduct[index].barcode ?? "0"}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "Hrg dsr: Rp. ${findProduct[index].purchasePrice}",
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
                                    "Stok: ${findProduct[index].stock}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Rp. ${findProduct[index].sellingPrice}",
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  GestureDetector(
                                      onTap: () async {
                                        var dialog = UpdateDialog(
                                            dataProduct: findProduct[index]);
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
          )
        ],
      ),
    );
  }
}
