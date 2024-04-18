class TransactionData {
  int id;
  String name;
  double price;
  int remaining;
  int count;
  TransactionData.set(
      {required this.id,
      required this.name,
      required this.price,
      this.count = 0,
      required this.remaining});

  @override
  String toString() {
    return '{id: $id, name: $name, price: $price, count: $count, remaining: $remaining}';
  }
}
