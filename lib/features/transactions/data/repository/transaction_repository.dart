import 'package:masroof_app/features/transactions/data/models/transaction_data_model.dart';
import 'package:masroof_app/features/transactions/data/models/transaction_model.dart';
import 'package:masroof_app/features/transactions/data/models/transaction_response_model.dart';
import 'package:masroof_app/features/transactions/data/services/transaction_service.dart';

class TransactionRepository {
  final TransactionService transactionService;

  TransactionRepository({required this.transactionService});

  Future<TransactionResponseModel> createTransaction(
    TransactionModel transaction,
  ) async {
    final response = await transactionService.createTransaction(transaction);

    return TransactionResponseModel.fromJson(response);
  }

  Future<List<TransactionDataModel>> getTransactions(int userId) async {
    final response = await transactionService.getTransactions(userId: userId);

    if (response['status'] == true && response['data'] != null) {
      final List<dynamic> transactionsJson = response['data'];
      return transactionsJson
          .map((json) => TransactionDataModel.fromJson(json))
          .toList();
    } else {
      throw Exception(response['message'] ?? 'حدث خطأ أثناء جلب العمليات');
    }
  }
}
