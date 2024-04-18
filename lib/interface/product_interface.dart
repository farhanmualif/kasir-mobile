import 'package:kasir_mobile/interface/category_interface.dart';

class Product {
  String link;
  int id;
  String uuid;
  String name;
  String? barcode;
  dynamic stock;
  double sellingPrice;
  double purchasePrice;
  String image;
  DateTime createdAt;
  DateTime updatedAt;

  List<CategoryProduct> category;

  Product({
    required this.link,
    required this.uuid,
    required this.id,
    required this.name,
    this.barcode,
    required this.stock,
    required this.sellingPrice,
    required this.purchasePrice,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
  });
}
