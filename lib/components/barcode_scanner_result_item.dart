import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kasir_mobile/helper/format_cuurency.dart';
import 'package:kasir_mobile/helper/get_access_token.dart';
import 'package:kasir_mobile/helper/show_snack_bar.dart';
import 'package:kasir_mobile/interface/product_interface.dart';
import 'package:kasir_mobile/provider/update_product_provider.dart';

// ignore: must_be_immutable
class BarcodeScannerResultItem extends StatefulWidget {
  final Map<int, Map<String, dynamic>> listProduct;
  final String typeTransaction;
  int subTotalPrice;

  BarcodeScannerResultItem({
    super.key,
    required this.listProduct,
    required this.typeTransaction,
    required this.subTotalPrice,
  });

  @override
  State<BarcodeScannerResultItem> createState() =>
      _BarcodeScannerResultItemState();
}

class _BarcodeScannerResultItemState extends State<BarcodeScannerResultItem>
    with AccessTokenProvider {
  String? _accessToken;
  final String? domain = dotenv.env["BASE_URL"];

  Map<int, TextEditingController> countItemProductController = {};

  @override
  void initState() {
    super.initState();
    _initializeToken();

    for (var product in widget.listProduct.values.toList()) {
      setState(() {
        countItemProductController[product['id']] =
            TextEditingController(text: '1');
      });
    }
  }

  Future<void> _initializeToken() async {
    _accessToken = await getToken();
    setState(() {});
  }

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

  void _handleProductUpdate() async {
    bool response = false;
    try {
      for (var product in widget.listProduct.values) {
        response = await updateProduct(
          uuid: product['uuid'],
          name: product['name'],
          barcode: product['barcode'] ?? "",
          quantityStock: product['count'],
          sellingPrice: product['price'],
          purchasePrice: product['purchasePrice'],
          addOrreduceStock: "add",
        );
      }
      if (mounted) {
        showSnackbar(response, context);
        Navigator.pushReplacementNamed(context, '/transaction',
            arguments: {'typeTransaction': widget.typeTransaction});
      }
    } catch (e) {
      if (mounted) {
        showSnackbar(false, context);
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: MediaQuery.of(context).size.height * 0.8,
      child: Stack(
        children: [
          _buildProductList(),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return ListView.builder(
      itemCount: widget.listProduct.length,
      itemBuilder: (context, index) {
        Product product =
            _getProductFromMap(widget.listProduct.values.toList()[index]);
        return _buildProductItem(product, index);
      },
    );
  }

  Product _getProductFromMap(Map<String, dynamic> e) {
    return Product.set(
      id: e['id'],
      uuid: e['uuid'],
      name: e['name'],
      image: "$domain/api/products/images/${e['uuid']}",
      price: e['price'],
      purchasePrice: e['purchasePrice'],
      barcode: e['barcode'],
      remaining: e['remaining'],
      selected: e['count'],
    );
  }

  Widget _buildProductItem(Product product, int index) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              (index + 1).toString(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            _buildProductImage(product),
            Expanded(child: _buildProductInfo(product)),
            _buildQuantityAndDeleteSection(product, index),
          ],
        ),
      ],
    );
  }

  Widget _buildProductImage(Product product) {
    return Container(
      margin: const EdgeInsets.all(5),
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        image: DecorationImage(
          image: CachedNetworkImageProvider(
            product.image,
            headers: {
              "Authorization": "Bearer $_accessToken",
              "Access-Control-Allow-Headers":
                  "Access-Control-Allow-Origin, Accept"
            },
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProductInfo(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(product.name, style: const TextStyle(fontSize: 16)),
        Text(convertToIdr(product.price), style: const TextStyle(fontSize: 10))
      ],
    );
  }

  Widget _buildQuantityAndDeleteSection(Product product, int index) {
    return IntrinsicWidth(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 50,
            child: TextField(
              controller: countItemProductController[product.id],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              ),
              onChanged: (value) {
                int? newValue = int.tryParse(value);
                if (newValue != null) {
                  _handleQuantityChanged(product.id, newValue);
                }
              },
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _removeProduct(product, index),
            child: const Icon(Icons.delete, color: Color(0xffFF0000)),
          ),
        ],
      ),
    );
  }

  void _handleQuantityChanged(int productId, int newValue) {
    setState(() {
      if (widget.listProduct.containsKey(productId)) {
        widget.listProduct[productId]!['count'] = newValue;

        // Recalculate subtotal
        widget.subTotalPrice = widget.listProduct.values.fold(0, (sum, item) {
          final price =
              (item['price'] as double).toInt(); // Convert double ke int
          final count = item['count'] as int;
          return sum + price * count;
        });
      }
    });
  }

  void _removeProduct(Product product, int index) {
    setState(() {
      widget.listProduct.removeWhere(
          (key, value) => key == widget.listProduct.keys.toList()[index]);
      widget.subTotalPrice -= product.price.toInt() * product.selected!;
    });
  }

  Widget _buildBottomButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: const BoxDecoration(
          color: Color(0xffFFCA45),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        width: 330,
        height: 60,
        child: TextButton(
          onPressed: widget.typeTransaction == "Transaksi"
              ? () => Navigator.pushNamed(context, "/payment", arguments: {
                    'totalPrice': widget.subTotalPrice,
                    'listProduct': widget.listProduct,
                  })
              : _handleProductUpdate,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  convertToIdr(widget.subTotalPrice),
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Text(
                widget.typeTransaction == "Transaksi" ? "Lanjut" : "Update",
                style: const TextStyle(color: Colors.black),
              ),
              const Icon(Icons.navigate_next, color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
