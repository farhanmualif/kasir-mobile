class DailyPurchase {
  final String link;
  final int totalTransaction;
  final int totalExpenditure;
  final List<ItemPurchasing> itemsPurchasing;

  DailyPurchase({
    required this.link,
    required this.totalTransaction,
    required this.totalExpenditure,
    required this.itemsPurchasing,
  });

  factory DailyPurchase.fromJson(Map<String, dynamic> json) {
    return DailyPurchase(
      link: json['link'],
      totalTransaction: json['total_transaction'],
      totalExpenditure: json['total_expenditure'],
      itemsPurchasing: List<ItemPurchasing>.from(
        json['items_purchasing'].map(
          (item) => ItemPurchasing.fromJson(item),
        ),
      ),
    );
  }
}

class ItemPurchasing {
  final String time;
  final int year;
  final String month;
  final int day;
  final int purchases;
  final String noTransaction;

  ItemPurchasing({
    required this.time,
    required this.year,
    required this.month,
    required this.day,
    required this.purchases,
    required this.noTransaction,
  });

  factory ItemPurchasing.fromJson(Map<String, dynamic> json) {
    return ItemPurchasing(
      time: json['time'],
      year: json['year'],
      month: json['month'],
      day: json['day'],
      purchases: json['purchases'],
      noTransaction: json['no_transaction'],
    );
  }
}
