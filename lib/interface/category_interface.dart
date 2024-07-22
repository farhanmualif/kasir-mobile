class CategoryProduct {
  final int id;
  String? uuid;
  final String name;
  String? capital;
  int? remainingStock;
  String? categoryId;
  final String createdAt;
  final String updatedAt;

  CategoryProduct({
    required this.id,
    this.uuid,
    required this.name,
    this.capital,
    this.remainingStock,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryProduct.fromJson(Map<String, dynamic> json) {
    return CategoryProduct(
      id: json['id'],
      uuid: json['uuid'],
      name: json['name'],
      capital: json['capital'],
      remainingStock: json['remaining_stock'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
