
class TransactionModel {
  final int userId;
  final int categoryId;
  final double amount;
  final String type;
  final String description;
  final DateTime transactionDate;

  TransactionModel({
    required this.userId,
    required this.categoryId,
    required this.amount,
    required this.type,
    required this.description,
    required this.transactionDate,
  });


  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      userId: json['user_id'],
      categoryId: json['category_id'],
      amount:double.parse(json['amount'].toString()),
      type: json['type'],
      description: json['description'],
      transactionDate: DateTime.parse(json['transaction_date'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'category_id': categoryId,
      'amount': amount,
      'type': type,
      'description': description,
      'transaction_date': transactionDate.toIso8601String().split('T').first,
    };
  }

}
