class MounthlyPurchase {
  final String link;
  final int totalTransaction;
  final int totalExpenditure;
  final List<DetailMounthlyPurchase> dailyData;

  MounthlyPurchase({
    required this.link,
    required this.totalTransaction,
    required this.totalExpenditure,
    required this.dailyData,
  });

  factory MounthlyPurchase.fromJson(Map<String, dynamic> json) {
    return MounthlyPurchase(
      link: json['link'],
      totalTransaction: json['total_transaction'],
      totalExpenditure: json['total_expenditure'],
      dailyData: List<DetailMounthlyPurchase>.from(
        json['daily_data'].map(
          (data) => DetailMounthlyPurchase.fromJson(data),
        ),
      ),
    );
  }
}

class DetailMounthlyPurchase {
  final int totalTransaction;
  final String date;
  final int month;
  final String monthName;
  final double totalExpenditure;
  final String link;

  DetailMounthlyPurchase({
    required this.totalTransaction,
    required this.date,
    required this.month,
    required this.monthName,
    required this.totalExpenditure,
    required this.link,
  });

  factory DetailMounthlyPurchase.fromJson(Map<String, dynamic> json) {
    return DetailMounthlyPurchase(
      totalTransaction: json['total_transaction'],
      date: json['date'],
      month: json['month'],
      monthName: json['month_name'],
      totalExpenditure: double.parse(json['total_expenditure']),
      link: json['link'],
    );
  }
}