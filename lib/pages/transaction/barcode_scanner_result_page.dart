import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/components/barcode_camera.dart';
import 'package:kasir_mobile/components/barcode_scanner_result_item.dart';
import 'package:kasir_mobile/helper/get_access_token.dart';
import 'package:kasir_mobile/interface/product_interface.dart';
import 'package:kasir_mobile/provider/get_product_by_barcode.dart';

class BarcodeScannerResult extends StatefulWidget {
  const BarcodeScannerResult(
      {super.key, required this.typeTransaction, required this.product});

  final Product product;
  final String typeTransaction;

  @override
  State<BarcodeScannerResult> createState() => _BarcodeScannerResultState();
}

class _BarcodeScannerResultState extends State<BarcodeScannerResult>
    with AccessTokenProvider {
  List<Product> listProduct = [];
  Map<int, Map<String, dynamic>> groupedProducts = {};
  var domain = dotenv.env["BASE_URL"];

  int subTotal = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      listProduct.add(widget.product);
    });
  }

  void updateProductCount(Product product, int count) {
    setState(() {
      listProduct.removeWhere((element) => element.id == product.id);
      for (int i = 0; i < count; i++) {
        listProduct.add(
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
      subTotal = listProduct.fold(0, (sum, item) => sum + item.price.toInt());
    });
  }

  Map<int, Map<String, dynamic>> groupedListTransactions(
      List<Product> transactions) {
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

  @override
  Widget build(BuildContext context) {
    print("widget.listProduct: $groupedProducts");
    print("widget.subTotalPrice: $subTotal");
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
                          child: GestureDetector(
                            onTap: () => handleBarcodeScan(context),
                            child: const Icon(Icons.qr_code_scanner_outlined),
                          )),
                    ],
                  ),
                ),
                BarcodeScannerResultItem(
                  listProduct: groupedListTransactions(listProduct),
                  typeTransaction: widget.typeTransaction,
                  subTotalPrice: subTotal,
                )
              ],
            ),
    );
  }

  handleBarcodeScan(BuildContext context) async {
    try {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      var barcodeResult = await BarcodeCamera().scanner();

      if (barcodeResult == '-1') {
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/barcode-scanner-result',
              arguments: {'typeTransaction': widget.typeTransaction});
          return;
        }
      }

      if (!mounted) return;

      // searchBarController.text = barcodeResult;
      Product result = await getProductByBarcode(barcodeResult);
      if (context.mounted) {
        listProduct.add(result);
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

  Future<Product> getProductByBarcode(String barcode) async {
    try {
      var product = await GetProductByBarcode.getProduct(barcode);
      return product.data!;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
