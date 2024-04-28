class YearPurchase {
  final String link;
  final int totalTransaction;
  final int totalExpenditure;
  final List<DetailYearPurchase> detailYearPurchase;

  YearPurchase({
    required this.link,
    required this.totalTransaction,
    required this.totalExpenditure,
    required this.detailYearPurchase,
  });

  factory YearPurchase.fromJson(Map<String, dynamic> json) {
    return YearPurchase(
      link: json['link'],
      totalTransaction: json['total_transaction'],
      totalExpenditure: json['total_expendeture'],
      detailYearPurchase: List<DetailYearPurchase>.from(
        json['monthly_data'].map(
          (data) => DetailYearPurchase.fromJson(data),
        ),
      ),
    );
  }
}

class DetailYearPurchase {
  final int month;
  final int year;
  final int totalTransaction;
  final double totalExpenditure;
  final String link;

  DetailYearPurchase({
    required this.month,
    required this.year,
    required this.totalTransaction,
    required this.totalExpenditure,
    required this.link,
  });

  factory DetailYearPurchase.fromJson(Map<String, dynamic> json) {
    return DetailYearPurchase(
      month: json['month'],
      year: json['year'],
      totalTransaction: json['total_transaction'],
      totalExpenditure: double.parse(json['total_expendeture']),
      link: json['link'],
    );
  }
}