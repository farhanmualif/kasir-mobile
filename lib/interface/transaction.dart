class TransactionData {
  String id;
  String name;
  String price;
  String remaining;
  int count;
  TransactionData.add(
      {required this.id,
      required this.name,
      required this.price,
      this.count = 0,
      required this.remaining});

  @override
  String toString() {
    return '{name: $name, price: $price, count: $count, remaining: $remaining}';
  }
}
