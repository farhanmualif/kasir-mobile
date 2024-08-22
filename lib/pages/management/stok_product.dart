import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/components/update_dialog.dart';
import 'package:kasir_mobile/helper/format_cuurency.dart';
import 'package:kasir_mobile/helper/get_access_token.dart';
import 'package:kasir_mobile/interface/api_response_interface.dart';
import 'package:kasir_mobile/interface/product_interface.dart';
import 'package:kasir_mobile/provider/delete_product_provider.dart';
import 'package:kasir_mobile/provider/get_all_product_provider.dart';
import 'package:kasir_mobile/themes/AppColors.dart';

class StokProductManagement extends StatefulWidget {
  const StokProductManagement({super.key});

  @override
  State<StokProductManagement> createState() => _StokProductManagementState();
}

class _StokProductManagementState extends State<StokProductManagement>
    with AccessTokenProvider {
  var domain = dotenv.env['BASE_URL'];
  List<Product> findProduct = [];
  bool isLoading = true;

  String? _accessToken;

  Future<void> _initAccessToken() async {
    _accessToken = await getToken();
    if (mounted) {
      setState(() {});
    }
  }

  Future<List<Product>> getProduct() async {
    try {
      var response = await GetAllProduct.getAllProduct(); //
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse> deleteProduct(String uuid) async {
    try {
      var response = await DeleteProduct.delete(uuid);
      var resApi =
          ApiResponse(status: response.status, message: response.message);
      if (resApi.status) {
        // Hapus data dari daftar findProduct
        setState(() {
          findProduct.removeWhere((item) => item.uuid == uuid);
        });
        // Muat ulang data setelah berhasil menghapus
        getProduct().then((value) {
          setState(() {
            findProduct = value;
          });
        });
      }
      return resApi;
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    _initAccessToken();
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
                              child: CachedNetworkImage(
                                cacheManager: CacheManager(Config('imgCacheKey',
                                    stalePeriod: const Duration(days: 1))),
                                imageUrl:
                                    "$domain/api/products/images/${findProduct[index].uuid}",
                                httpHeaders: {
                                  "Authorization": "Bearer $_accessToken",
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
                                      CachedNetworkImage.evictFromCache(url);
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
                                    "Hrg dsr: ${convertToIdr(findProduct[index].purchasePrice)}",
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
                                    convertToIdr(findProduct[index].price),
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () async {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return isLoading
                                                    ? const CircularProgressIndicator()
                                                    : AlertDialog(
                                                        title: const Text(
                                                            "Konfirmasi Hapus"),
                                                        content: Text(
                                                            "Hapus ${findProduct[index].name}?"),
                                                        actions: [
                                                          TextButton(
                                                              onPressed:
                                                                  () async {
                                                                setState(() {
                                                                  isLoading =
                                                                      true;
                                                                });
                                                                var response =
                                                                    await deleteProduct(
                                                                        findProduct[index]
                                                                            .uuid);
                                                                setState(() {
                                                                  isLoading =
                                                                      false;
                                                                });
                                                                if (!response
                                                                    .status) {
                                                                  if (context
                                                                      .mounted) {
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      const SnackBar(
                                                                        duration:
                                                                            Duration(seconds: 1),
                                                                        content:
                                                                            Text('terjadi kesalahan'),
                                                                        backgroundColor:
                                                                            Colors.red,
                                                                      ),
                                                                    );
                                                                  }
                                                                } else {
                                                                  if (context
                                                                      .mounted) {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                      const SnackBar(
                                                                        duration:
                                                                            Duration(seconds: 1),
                                                                        content:
                                                                            Text('berhasil menghapus data'),
                                                                        backgroundColor:
                                                                            Colors.green,
                                                                      ),
                                                                    );
                                                                  }
                                                                }
                                                              },
                                                              child: const Text(
                                                                  "Ya")),
                                                          TextButton(
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(),
                                                              child: const Text(
                                                                  "Batal"))
                                                        ],
                                                      );
                                              },
                                            );
                                          },
                                          child: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          )),
                                      GestureDetector(
                                          onTap: () async {
                                            var dialog = UpdateDialog(
                                                dataProduct:
                                                    findProduct[index], accessToken: _accessToken);
                                            dialog
                                                .showEditingFormDialog(context);
                                          },
                                          child: const Icon(Icons.edit_square)),
                                    ],
                                  )
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
