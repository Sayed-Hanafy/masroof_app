
class TransactionResponseModel {
  final bool status;
  final String message;
  final int? transactionId;

  TransactionResponseModel({
    required this.status,
    required this.message,
    this.transactionId,
  });

  factory TransactionResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TransactionResponseModel(
      status: json['status'] == true,
      message: json['message']?.toString() ?? '',
      transactionId: json['transaction_id'] == null
          ? null
          : int.parse(json['transaction_id'].toString()),
    );
  }
}
