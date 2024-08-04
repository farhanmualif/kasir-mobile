import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/components/barcode_camera.dart';
import 'package:kasir_mobile/components/barcode_scanner_result_item.dart';
import 'package:kasir_mobile/helper/get_access_token.dart';
import 'package:kasir_mobile/interface/product_interface.dart';
import 'package:kasir_mobile/provider/get_product_by_barcode.dart';

class BarcodeScannerResult extends StatefulWidget {
  const BarcodeScannerResult({
    super.key,
    required this.typeTransaction,
    required this.product,
  });

  final Product? product;
  final String typeTransaction;

  @override
  State<BarcodeScannerResult> createState() => _BarcodeScannerResultState();
}

class _BarcodeScannerResultState extends State<BarcodeScannerResult>
    with AccessTokenProvider {
  List<Product> listProduct = [];
  Map<int, Map<String, dynamic>> groupedProducts = {};
  final String domain = dotenv.env["BASE_URL"] ?? '';

  int subTotal = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      listProduct.add(widget.product!);
    }
    _updateSubTotal();
  }

  void _updateSubTotal() {
    subTotal = listProduct.fold(0, (sum, item) => sum + item.price.toInt());
  }

  void updateProductCount(Product product, int count) {
    setState(() {
      listProduct.removeWhere((element) => element.id == product.id);
      for (int i = 0; i < count; i++) {
        listProduct.add(Product.set(
          purchasePrice: product.purchasePrice,
          barcode: product.barcode,
          uuid: product.uuid,
          image: "$domain/api/products/images/${product.uuid}",
          id: product.id,
          name: product.name,
          price: product.price,
          remaining: product.stock,
          selected: 1,
        ));
      }
      _updateSubTotal();
    });
  }

  Map<int, Map<String, dynamic>> groupedListTransactions(
      List<Product> transactions) {
    groupedProducts.clear();
    for (var product in transactions) {
      int id = product.id;
      groupedProducts.update(
        id,
        (existingProduct) =>
            {...existingProduct, 'count': existingProduct['count'] + 1},
        ifAbsent: () => {
          'id': product.id,
          'uuid': product.uuid,
          'barcode': product.barcode,
          'name': product.name,
          'price': product.price,
          'purchasePrice': product.purchasePrice,
          'count': 1,
          'remaining': product.remaining,
          'image': product.image
        },
      );
    }
    return groupedProducts;
  }

  Future<void> handleBarcodeScan(BuildContext context) async {
    try {
      setState(() => _isLoading = true);

      final barcodeResult = await BarcodeCamera().scanner();

      if (barcodeResult == '-1') {
        if (context.mounted) {
          Navigator.pop(context);
        }
        return;
      }

      if (!mounted) return;

      final result = await getProductByBarcode(barcodeResult);
      setState(() {
        listProduct.add(result);
        _updateSubTotal();
      });
    } on PlatformException catch (e) {
      _showSnackBar('Izin kamera tidak diizinkan oleh pengguna: $e');
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<Product> getProductByBarcode(String barcode) async {
    try {
      final product = await GetProductByBarcode.getProduct(barcode);
      return product.data!;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xff076A68),
        title: Text(widget.typeTransaction,
            style: const TextStyle(color: Colors.white)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildTopMenu(),
                  BarcodeScannerResultItem(
                    listProduct: groupedListTransactions(listProduct),
                    typeTransaction: widget.typeTransaction,
                    subTotalPrice: subTotal,
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTopMenu() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width: 1, color: Color(0xffDDDDDD))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => handleBarcodeScan(context),
            child: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.qr_code_scanner_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
