class ProductUpdateResponse {
  final int? id;
  final String? uuid;
  final String? name;
  final String? barcode;
  final int? stock;
  final int? sellingPrice;
  final int? purchasePrice;
  final String? image;
  final String? createdAt;
  final String? updatedAt;

  ProductUpdateResponse({
    this.id,
    this.uuid,
    this.name,
    this.barcode,
    this.stock,
    this.sellingPrice,
    this.purchasePrice,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductUpdateResponse.fromJson(Map<String, dynamic> json) {
    return ProductUpdateResponse(
      id: json['id'],
      uuid: json['uuid'],
      name: json['name'],
      barcode: json['barcode'],
      stock: json['stock'],
      sellingPrice: int.tryParse(json['selling_price']),
      purchasePrice: int.tryParse(json['purchase_price']),
      image: json['image'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
