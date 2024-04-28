class MonthlyTransaction {
  final String link;
  final int totalTransactions;
  final int totalRevenue;
  final int totalProfit;
  final String month;
  final int monthNumber;
  final int year;
  final List<DetailMonthlyTransaction> detailTransactions;

  MonthlyTransaction({
    required this.link,
    required this.totalTransactions,
    required this.totalRevenue,
    required this.totalProfit,
    required this.month,
    required this.monthNumber,
    required this.year,
    required this.detailTransactions,
  });

  factory MonthlyTransaction.fromJson(Map<String, dynamic> json) {
    return MonthlyTransaction(
      link: json['link'],
      totalTransactions: json['total_transactions'],
      totalRevenue: json['total_revenue'],
      totalProfit: json['total_profit'],
      month: json['month'],
      monthNumber: json['month_number'],
      year: json['year'],
      detailTransactions: List<DetailMonthlyTransaction>.from(
        json['transactions'].map(
          (transaction) => DetailMonthlyTransaction.fromJson(transaction),
        ),
      ),
    );
  }
}

class DetailMonthlyTransaction {
  final String link;
  final String date;
  final double revenue;
  final double profit;
  final int transactionAmount;

  DetailMonthlyTransaction({
    required this.link,
    required this.date,
    required this.revenue,
    required this.profit,
    required this.transactionAmount,
  });

  factory DetailMonthlyTransaction.fromJson(Map<String, dynamic> json) {
    return DetailMonthlyTransaction(
      link: json['link'],
      date: json['date'],
      revenue: double.parse(json['revenue']),
      profit: double.parse(json['profit']),
      transactionAmount: json['transaction_amount'],
    );
  }
}
