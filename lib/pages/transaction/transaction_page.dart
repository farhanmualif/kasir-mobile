import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/components/barcode_camera.dart';
import 'package:kasir_mobile/helper/format_cuurency.dart';
import 'package:kasir_mobile/helper/get_access_token.dart';
import 'package:kasir_mobile/interface/product_interface.dart';
import 'package:kasir_mobile/provider/get_all_product_provider.dart';
import 'package:kasir_mobile/provider/get_product_by_barcode.dart';
import 'package:kasir_mobile/themes/AppColors.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key, required this.typeTransaction});

  final String typeTransaction;

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage>
    with AccessTokenProvider {
  final searchBarController = TextEditingController();

  // initial each count controller
  Map<int, TextEditingController> countItemProductController = {};

  var domain = dotenv.env['BASE_URL'];
  List<Product> transactions = [];
  List<Product> findProduct = [];
  String? _accessToken;
  bool _buttonEnable = false;
  bool _isLoading = true;
  int fullStock = 0;
  int subTotal = 0;

  Future<void> _initializeToken() async {
    _accessToken = await getToken();
    if (mounted) {
      setState(() {});
    }
  }

  Map<int, Map<String, dynamic>> groupedListTransactions(
      List<Product> transactions) {
    Map<int, Map<String, dynamic>> groupedProducts = {};

    for (var product in transactions) {
      int id = product.id;
      if (groupedProducts.containsKey(id)) {
        groupedProducts[id]!['count']++;
      } else {
        groupedProducts[id] = {
          'id': product.id,
          'uuid': product.uuid,
          'barcode': product.barcode,
          'name': product.name,
          'price': product.price,
          'purchasePrice': product.purchasePrice,
          'count': 1,
          'remaining': product.remaining,
          'image': product.image
        };
      }
    }

    return groupedProducts;
  }

  Future<List<Product>> getProduct() async {
    try {
      var response = await GetAllProduct.getAllProduct();
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    getProduct().then((value) {
      if (mounted) {
        setState(() {
          findProduct = value;
          _isLoading = false;
          // initial controller for each product
          for (var product in findProduct) {
            countItemProductController[product.id] =
                TextEditingController(text: '0');
          }
        });
      }
    });

    _initializeToken();
  }

  @override
  void dispose() {
    // remove controller when widget dispose
    for (var controller in countItemProductController.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void updateProductCount(Product product, int count) {
    setState(() {
      transactions.removeWhere((element) => element.id == product.id);
      for (int i = 0; i < count; i++) {
        transactions.add(
          Product.set(
            purchasePrice: product.purchasePrice,
            barcode: product.barcode,
            uuid: product.uuid,
            image: "$domain/api/products/images/${product.uuid}",
            id: product.id,
            name: product.name,
            price: product.price,
            remaining: product.stock,
            selected: 1,
          ),
        );
      }
      subTotal = transactions.fold(0, (sum, item) => sum + item.price.toInt());
      _buttonEnable = transactions.isNotEmpty;
    });
  }

  void onQueryChanged(String query) {
    getProduct().then((products) {
      if (mounted) {
        setState(() {
          findProduct = products
              .where((item) =>
                  item.name.toLowerCase().contains(query.toLowerCase()) ||
                  (item.barcode != null &&
                      item.barcode!
                          .toLowerCase()
                          .contains(query.toLowerCase())))
              .toList();
        });
      }
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
            // logic for back to before page
            Navigator.pushReplacementNamed(context, "/home",
                arguments: {"typeTransaction": widget.typeTransaction});
          },
        ),
      ),
      body: _body(),
    );
  }

  Future<Product?> getProductByBarcode(String barcode) async {
    try {
      var product = await GetProductByBarcode.getProduct(barcode);

      return product.data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> handleBarcodeScan(BuildContext context) async {
    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      var barcodeResult = await BarcodeCamera().scanner();

      if (barcodeResult == '-1') {
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/transaction',
              arguments: {'typeTransaction': widget.typeTransaction});
          return;
        }
      }

      if (!mounted) return;

      // searchBarController.text = barcodeResult;
      Product? result = await getProductByBarcode(barcodeResult);
      if (result == null) {
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/transaction',
              arguments: {'typeTransaction': widget.typeTransaction});
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('produk tidak ditemukan'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }
      if (context.mounted) {
        Navigator.pushNamed(context, '/barcode-scanner-result', arguments: {
          'product': result,
          'typeTransaction': widget.typeTransaction,
        });
      }
    } on PlatformException catch (e) {
      // Handle error
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Izin kamera tidak diizinkan oleh si pengguna: $e')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(width: 1, color: Color(0xffDDDDDD)))),
            child: _header(),
          ),
          if (widget.typeTransaction == "Pembelian Barang")
            _buttonFormAddProduct(),
          _listProductBody(),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Expanded(
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
    );
  }

  List<Widget> _barcodeBox() {
    return [
      Expanded(
        flex: -1,
        child: GestureDetector(
          onTap: () => handleBarcodeScan(context),
          child: const Image(image: AssetImage("assets/images/barcode.png")),
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      Container(
          margin: const EdgeInsets.only(right: 10),
          child: const Icon(Icons.qr_code_2)),
    ];
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _searchBar(),
        const SizedBox(
          width: 10,
        ),
        ..._barcodeBox()
      ],
    );
  }

  Widget _bottomButton() {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: const EdgeInsets.only(bottom: 80),
      child: Container(
        decoration: BoxDecoration(
            color: widget.typeTransaction == "Transaksi"
                ? (_buttonEnable ? AppColors.secondary : AppColors.disable)
                : AppColors.secondary,
            borderRadius: const BorderRadius.all(Radius.circular(50))),
        width: 330,
        height: 60,
        child: TextButton(
          onPressed: _buttonEnable
              ? () {
                  if (transactions.isNotEmpty) {
                    Navigator.pushNamed(context, '/cart', arguments: {
                      'listTransaction': groupedListTransactions(transactions),
                      'typeTransaction': widget.typeTransaction,
                      'totalPrice': subTotal
                    });
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
                    color: AppColors.dark),
              )),
              Expanded(
                  flex: -1,
                  child: Text(
                    widget.typeTransaction == "Pembelian Barang"
                        ? "Tambah Barang"
                        : "Lanjut",
                    style: const TextStyle(color: AppColors.dark),
                  )),
              const Expanded(
                flex: -1,
                child: Icon(
                  Icons.navigate_next,
                  color: AppColors.dark,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonFormAddProduct() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/form-add-product");
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
              "Tambah Barang Baru",
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }

  Widget _listProductBody() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width * 0.95,
      child: Stack(
        children: [
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                )
              : _listProductView(),
          _bottomButton()
        ],
      ),
    );
  }

  Widget _listProductView() {
    return ListView.builder(
      itemCount: findProduct.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Row(
              children: [
                _imageProduct(index),
                _productInfo(index),
                _buttonEnv(index),
              ],
            )
          ],
        );
      },
    );
  }

  _imageProduct(int index) {
    return Expanded(
      flex: -1,
      child: Container(
        margin: const EdgeInsets.all(5),
        height: 50,
        width: 50,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          child: CachedNetworkImage(
            cacheManager: CacheManager(
                Config('imgCacheKey', stalePeriod: const Duration(days: 1))),
            imageUrl: "$domain/api/products/images/${findProduct[index].uuid}",
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
      ),
    );
  }

  Widget _productInfo(int index) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            findProduct[index].name,
            style: const TextStyle(fontSize: 16),
          ),
          Row(
            children: [
              Text(
                "Stok: ${findProduct[index].stock}",
                style: const TextStyle(fontSize: 10),
              ),
              Container(
                margin: const EdgeInsets.only(left: 5, right: 5),
                child: const Icon(
                  Icons.do_not_disturb_on_sharp,
                  size: 10,
                ),
              ),
              Text(convertToIdr(findProduct[index].price),
                  style: const TextStyle(fontSize: 10))
            ],
          )
        ],
      ),
    );
  }

  Widget _buttonEnv(int index) {
    return Row(
      children: [
        _reduceProductSelectWidget(index),
        _countProductsSelectedWidget(index),
        _addProductSelectWidget(index),
      ],
    );
  }

  Widget _reduceProductSelectWidget(int index) {
    return GestureDetector(
      onTap: () {
        if (findProduct[index].stock == 0 &&
            widget.typeTransaction == "Transaksi") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 1),
              content: Text('Stok ${findProduct[index].name} kosong'),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          if (mounted) {
            setState(() {
              if (transactions.isNotEmpty) {
                final lastIndexs = transactions.lastIndexWhere(
                    (element) => element.id == findProduct[index].id);

                if (lastIndexs != -1) {
                  subTotal -= transactions[lastIndexs].price.toInt();
                  transactions.removeAt(lastIndexs);
                }
              }

              if (widget.typeTransaction == "Pembelian Barang") {
                int currentValue = int.tryParse(
                        countItemProductController[findProduct[index].id]!
                            .text) ??
                    0;
                if (currentValue > 0) {
                  currentValue--;
                  countItemProductController[findProduct[index].id]!.text =
                      currentValue.toString();
                  updateProductCount(findProduct[index], currentValue);
                }
              }
            });
          }

          if (fullStock >= 1) {
            if (mounted) {
              setState(() {
                fullStock--;
              });
            }
          }

          if (fullStock < 1) {
            if (mounted) {
              setState(() {
                _buttonEnable = true;
              });
            }
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        height: 35,
        width: 25,
        decoration: const BoxDecoration(
          color: Color(0xffE0EBFF),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: const Icon(Icons.minimize),
        ),
      ),
    );
  }

  Widget _addProductSelectWidget(int index) {
    return GestureDetector(
      onTap: () {
        if (widget.typeTransaction == "Transaksi") {
          // if stock <= 0
          if (findProduct[index].stock <= 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 2),
                content: Text('Stok ${findProduct[index].name} kosong'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          // if itemselected == stock
          if (transactions
                  .where(
                      (itemProduct) => itemProduct.id == findProduct[index].id)
                  .length >=
              findProduct[index].stock) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 2),
                content: Text(
                    'Tidak dapat menambahkan lebih banyak ${findProduct[index].name}, stok habis.'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
        }

        if (mounted) {
          setState(() {
            transactions.add(
              Product.set(
                purchasePrice: findProduct[index].purchasePrice,
                barcode: findProduct[index].barcode,
                uuid: findProduct[index].uuid,
                image: "$domain/api/products/images/${findProduct[index].uuid}",
                id: findProduct[index].id,
                name: findProduct[index].name,
                price: findProduct[index].price,
                remaining: findProduct[index].stock,
                selected: 1,
              ),
            );
            subTotal += findProduct[index].price.toInt();
            _buttonEnable = true;
          });

          int currentValue = int.tryParse(
                  countItemProductController[findProduct[index].id]!.text) ??
              0;
          currentValue++;
          countItemProductController[findProduct[index].id]!.text =
              currentValue.toString();
          updateProductCount(findProduct[index], currentValue);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        height: 35,
        width: 25,
        decoration: const BoxDecoration(
          color: Color(0xffE0EBFF),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _countProductsSelectedWidget(int index) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      height: 35,
      width: 40, // Perlebar sedikit untuk TextField
      decoration: const BoxDecoration(
          color: Color(0xffE0EBFF),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Center(
          child: widget.typeTransaction == "Pembelian Barang"
              ? TextField(
                  controller: countItemProductController[findProduct[index].id],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onChanged: (value) {
                    int count = int.tryParse(value) ?? 0;
                    updateProductCount(findProduct[index], count);
                  },
                )
              : Text(transactions
                  .where((element) => element.id == findProduct[index].id)
                  .length
                  .toString())),
    );
  }
}
