class TransactionResponseModel {
  final bool status;
  final String message;
  final int transactionId;

  TransactionResponseModel({
    required this.status,
    required this.message,
    required this.transactionId,
  });

  factory TransactionResponseModel.fromJson(Map<String, dynamic> json) {
    return TransactionResponseModel(
      status: json['status'],
      message: json['message'],
      transactionId: json['transaction_id'],
    );
  }
}
