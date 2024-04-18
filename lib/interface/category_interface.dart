class CategoryProduct {
  int id;
  String uuid;
  String name;
  String? createdAt;
  String? updatedAt;

  CategoryProduct(
      {required this.id,
      required this.uuid,
      required this.name,
      this.createdAt,
      this.updatedAt});
}
