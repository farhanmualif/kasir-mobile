class MonthlyTransaction {
  final String link;
  final int totalTransactions;
  final int totalIncome;
  final int totalProfit;
  final String month;
  final String monthNumber;
  final String year;
  final List<DetailMonthlyTransaction> detailTransactions;

  MonthlyTransaction({
    required this.link,
    required this.totalTransactions,
    required this.totalIncome,
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
      totalIncome: json['total_income'],
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
  final double income;
  final double profit;
  final int transactionAmount;

  DetailMonthlyTransaction({
    required this.link,
    required this.date,
    required this.income,
    required this.profit,
    required this.transactionAmount,
  });

  factory DetailMonthlyTransaction.fromJson(Map<String, dynamic> json) {
    return DetailMonthlyTransaction(
      link: json['link'],
      date: json['date'],
      income: json['income'].toDouble(),
      profit: json['profit'].toDouble(),
      transactionAmount: json['transaction_amount'],
    );
  }
}
