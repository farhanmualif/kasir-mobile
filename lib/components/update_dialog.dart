import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/helper/get_access_token.dart';
import 'package:kasir_mobile/provider/update_product_provider.dart';
import 'package:kasir_mobile/themes/AppColors.dart';

class UpdateDialog with AccessTokenProvider {
  UpdateDialog({required this.dataProduct, required this.accessToken});
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _typeChange = "";
  // ignore: prefer_typing_uninitialized_variables
  final dataProduct;
  final bool _isLoading = false;
  String? accessToken;

  Future<bool> updateProduct({
    required String uuid,
    required String name,
    required String barcode,
    required int quantityStock,
    required double sellingPrice,
    required double purchasePrice,
    required String addOrreduceStock,
  }) async {
    try {
      var response = await UpdateProduct.put(uuid, name, barcode, quantityStock,
          sellingPrice, purchasePrice, addOrreduceStock);
      return response.status;
    } catch (e) {
      rethrow;
    }
  }

  showEditingFormDialog(
    BuildContext context,
  ) {
    TextEditingController quantityStocktController =
        TextEditingController(text: "");
    TextEditingController purchasePriceController =
        TextEditingController(text: dataProduct.purchasePrice.toString());

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    var domain = dotenv.env['BASE_URL'];
    return _isLoading
        ? const CircularProgressIndicator()
        : showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  content: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Form(
                      key: _formKey,
                      child: SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Manajemen Stok",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const Divider(),
                            Row(
                              children: [
                                Expanded(
                                  child: CachedNetworkImage(
                                    cacheManager: CacheManager(Config(
                                        'imgCacheKey',
                                        stalePeriod: const Duration(days: 1))),
                                    imageUrl:
                                        "$domain/storage/images/${dataProduct.image}",
                                    httpHeaders: {
                                      "Authorization": "Bearer $accessToken",
                                      "Access-Control-Allow-Headers":
                                          "Access-Control-Allow-Origin, Accept"
                                    },
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) {
                                      return GestureDetector(
                                        onTap: () {
                                          // Memicu reload gambar
                                          CachedNetworkImage.evictFromCache(
                                              url);
                                          setState(() {});
                                        },
                                        child: Container(
                                          color: Colors.grey[300],
                                          child: const Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.error),
                                              Text("Tap to reload"),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dataProduct.name,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "code:  ${dataProduct.barcode ?? 0}",
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Rp. ${dataProduct.price}",
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Stok: ${dataProduct.stock}",
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Radio(
                                        value: "reduce",
                                        groupValue: _typeChange,
                                        onChanged: (value) {
                                          setState(() {
                                            _typeChange = value!;
                                          });
                                        },
                                      ),
                                      const Text("Kurangi"),
                                      Radio(
                                        value: "add",
                                        groupValue: _typeChange,
                                        onChanged: (value) {
                                          setState(() {
                                            _typeChange = value!;
                                          });
                                        },
                                      ),
                                      const Text("Tambah")
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child:
                                      const Icon(Icons.calendar_month_outlined),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  "Klik untuk Menentukan Tanggal",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Harga Dasar",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.33,
                                      child: TextFormField(
                                        controller: purchasePriceController,
                                        decoration: const InputDecoration(
                                          prefixText: "Rp. ",
                                          hintStyle: TextStyle(fontSize: 15),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50)),
                                          ),
                                          isCollapsed: true,
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Jumlah",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.33,
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "jumlah kosong";
                                          }
                                          return null;
                                        },
                                        controller: quantityStocktController,
                                        decoration: const InputDecoration(
                                          hintStyle: TextStyle(fontSize: 15),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50)),
                                          ),
                                          isCollapsed: true,
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Keterangan",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(fontSize: 15),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
                                ),
                                isCollapsed: true,
                                isDense: true,
                                contentPadding: EdgeInsets.all(5),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 34,
                                    decoration: const BoxDecoration(
                                      color: Color(0xffFFCA45),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Batal",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Container(
                                    height: 34,
                                    decoration: const BoxDecoration(
                                      color: Color(0xff076A68),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: TextButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          try {
                                            if (_typeChange == "reduce" &&
                                                (dataProduct.stock -
                                                        int.parse(
                                                            quantityStocktController
                                                                .text) <=
                                                    0)) {
                                              scaffoldMessenger.showSnackBar(
                                                const SnackBar(
                                                  content: Text('stok minus'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                              return;
                                            }

                                            var response = await updateProduct(
                                              uuid: dataProduct.uuid,
                                              name: dataProduct.name,
                                              barcode:
                                                  dataProduct.barcode ?? "0",
                                              quantityStock: int.parse(
                                                  quantityStocktController
                                                      .text),
                                              sellingPrice: dataProduct.price,
                                              purchasePrice: double.parse(
                                                  purchasePriceController.text),
                                              addOrreduceStock: _typeChange,
                                            );

                                            setState(() {
                                              dataProduct.name =
                                                  dataProduct.name;
                                              dataProduct.barcode =
                                                  dataProduct.barcode;
                                              dataProduct.stock =
                                                  dataProduct.stock;
                                              dataProduct.price =
                                                  dataProduct.price;
                                              dataProduct.purchasePrice =
                                                  dataProduct.purchasePrice;
                                            });

                                            if (response) {
                                              scaffoldMessenger.showSnackBar(
                                                const SnackBar(
                                                  content:
                                                      Text('Berhasil update'),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                            } else {
                                              scaffoldMessenger.showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Terjadi kesalahan, add or reduce tidak boleh kosong'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          } catch (e) {
                                            scaffoldMessenger.showSnackBar(
                                              const SnackBar(
                                                content:
                                                    Text('Terjadi kesalahan'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                          if (context.mounted) {
                                            Navigator.pop(context);
                                            setState(() {});
                                          }
                                        }
                                      },
                                      child: const Text(
                                        "Simpan",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
            },
          );
  }
}
