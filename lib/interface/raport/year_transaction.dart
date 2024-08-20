class YearTransaction {
  final String link;
  final int totalTransactions;
  final int totalIncome;
  final int totalProfit;
  final int year;
  final List<DetailYearTransaction> transactions;

  YearTransaction({
    required this.link,
    required this.totalTransactions,
    required this.totalIncome,
    required this.totalProfit,
    required this.year,
    required this.transactions,
  });

  factory YearTransaction.fromJson(Map<String, dynamic> json) {
    return YearTransaction(
      link: json['link'],
      totalTransactions: json['total_transactions'],
      totalIncome: json['total_income'],
      totalProfit: json['total_profit'],
      year: json['year'],
      transactions: (json['transactions'] as List)
          .map((transactionJson) =>
              DetailYearTransaction.fromJson(transactionJson))
          .toList(),
    );
  }
}

class DetailYearTransaction {
  final String link;
  final String date;
  final int income;
  final int profit;
  final int monthNum;

  DetailYearTransaction({
    required this.link,
    required this.date,
    required this.income,
    required this.profit,
    required this.monthNum,
  });

  factory DetailYearTransaction.fromJson(Map<String, dynamic> json) {
    return DetailYearTransaction(
        link: json['link'],
        date: json['date'],
        income: double.parse(json['income']).round(),
        profit: double.parse(json['profit']).round(),
        monthNum: json['month_num']);
  }
}
