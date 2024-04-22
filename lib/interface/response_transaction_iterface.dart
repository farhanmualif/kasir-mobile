class TransactionResponse {
  bool status;
  String message;
  TransactionData? data;

  TransactionResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      status: json['status'],
      message: json['message'],
      data: json['data'] != null ? TransactionData.fromJson(json['data']) : null,
    );
  }
}

class TransactionData {
  String noTransaction;
  int totalPayment;
  int cash;
  dynamic change; // Sesuaikan tipe data dengan kebutuhan Anda
  String createdAt;
  String updatedAt;

  TransactionData({
    required this.noTransaction,
    required this.totalPayment,
    required this.cash,
    this.change,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      noTransaction: json['no_transaction'],
      totalPayment: json['total_payment'],
      cash: json['cash'],
      change: json['change'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}