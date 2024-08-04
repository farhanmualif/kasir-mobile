import 'package:kasir_mobile/interface/category_interface.dart';

class Product {
  String link;
  int id;
  String uuid;
  String name;
  String? barcode;
  dynamic stock;
  double price;
  double purchasePrice;
  int? selected;
  int? remaining;
  String image;
  DateTime createdAt;
  DateTime updatedAt;

  List<CategoryProduct>? category;

  Product({
    required this.link,
    required this.uuid,
    required this.id,
    required this.name,
    this.barcode,
    required this.stock,
    required this.price,
    required this.purchasePrice,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    this.category,
  });

  Product.set({
    required this.id,
    required this.uuid,
    required this.name,
    required this.image,
    required this.price,
    required this.purchasePrice,
    required this.barcode,
    this.selected = 0,
    required this.remaining,
  })  : link = '',
        stock = 0,
        createdAt = DateTime.now(),
        updatedAt = DateTime.now();

  factory Product.fromJson(Map<String, dynamic> json) {
    if (json['selling_price'] is String) {
      json['selling_price'] = double.parse(json['selling_price']);
    } else if (json['selling_price'] is int) {
      json['selling_price'] = json['selling_price'].toDouble();
    }

    return Product(
      id: json['id'],
      uuid: json['uuid'],
      name: json['name'],
      category: (json['category'] as List<dynamic>?)
          ?.map((e) => CategoryProduct.fromJson(e))
          .toList(),
      image: json['image'],
      link: json['link'],
      price: json['selling_price'],
      purchasePrice: json['purchase_price']?.toDouble() ?? 0.0,
      stock: json['stock'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
