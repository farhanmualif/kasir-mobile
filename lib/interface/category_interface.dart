class CategoryProduct {
  final int id;
  final String uuid;
  final String name;
  String? categoryId;
  final String createdAt;
  final String updatedAt;

  CategoryProduct({
    required this.id,
    required this.uuid,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryProduct.fromJson(Map<String, dynamic> json) {
    return CategoryProduct(
      id: json['id'],
      uuid: json['uuid'],
      name: json['name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
