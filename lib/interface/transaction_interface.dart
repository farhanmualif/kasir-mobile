class TransactionData {
  int id;
  String uuid;
  String name;
  String? barcode;
  double price;
  double purcahsePrice;
  int remaining;
  int selected;
  String image;
  TransactionData.set(
      {required this.id,
      required this.uuid,
      required this.name,
      required this.image,
      required this.price,
      required this.purcahsePrice,
      required this.barcode,
      this.selected = 0,
      required this.remaining});

  @override
  String toString() {
    return '{id: $id, name: $name, price: $price, count: $selected, remaining: $remaining}';
  }
}
