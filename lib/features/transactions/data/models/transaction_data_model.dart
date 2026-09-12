class TransactionDataModel {
  final int transactionId;
  final int userId;
  final int categoryId;
  final String categoryName;
  final double amount;
  final String type;
  final String description;
  final String transactionDate;

  TransactionDataModel({
    required this.transactionId,
    required this.userId,
    required this.categoryId,
    required this.categoryName,
    required this.amount,
    required this.type,
    required this.description,
    required this.transactionDate,
  });

  factory TransactionDataModel.fromJson(Map<String, dynamic> json) {
    return TransactionDataModel(
      transactionId: json['transaction_id'],
      userId: json['user_id'],
      categoryId: json['category_id'],
      categoryName: json['category_name'].toString(),
      amount: double.parse(json['amount'].toString()),
      type: json['type'],
      description: json['description'].toString(),
      transactionDate: json['transaction_date'].toString(),
    );
  }
}
