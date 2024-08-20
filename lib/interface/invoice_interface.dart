class Invoice {
  final String noTransaction;
  final int totalPayment;
  final int cash;
  final String time;
  final String date;
  final List<Item> items;

  Invoice({
    required this.noTransaction,
    required this.totalPayment,
    required this.cash,
    required this.time,
    required this.date,
    required this.items,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      noTransaction: json['no_transaction'],
      totalPayment: json['total_payment'],
      cash: json['cash'],
      time: json['time'],
      date: json['date'],
      items: (json['items'] as List)
          .map((item) => Item.fromJson(item))
          .toList(),
    );
  }
}

class Item {
  final String name;
  final int quantity;
  final int itemPrice;
  final int totalPrice;

  Item({
    required this.name,
    required this.quantity,
    required this.itemPrice,
    required this.totalPrice,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'],
      quantity: json['quantity'],
      itemPrice: json['item_price'],
      totalPrice: json['total_price'],
    );
  }
}