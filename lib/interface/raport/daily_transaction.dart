class DailyTransaction {
  num totalTransactions;
  num totalRevenue;
  num totalProfit;
  String date;
  late List<String> dateParts;
  late String month;
  late String day;
  late String year;
  List<DetailTransaction> detailTransaction;

  DailyTransaction({
    required this.totalTransactions,
    required this.totalProfit,
    required this.totalRevenue,
    required this.date,
    required this.detailTransaction,
  })  : dateParts = date.split(" "),
        month = '',
        day = '',
        year = '' {
    month = dateParts[0];
    day = dateParts[1].replaceFirst(",", "");
    year = dateParts[2].substring(0, 4);
  }
}

class DetailTransaction {
  String time;
  num revenue;
  num profit;
  String noTransaction;
  List<ItemTransaction>? items;

  DetailTransaction(
      {required this.time,
      required this.revenue,
      required this.profit,
      required this.noTransaction,
      this.items});
}

class ItemTransaction {
  String name;
  int quantity;
  double price;
  double totalPrice;

  ItemTransaction(this.name, this.quantity, this.price, this.totalPrice);
}
