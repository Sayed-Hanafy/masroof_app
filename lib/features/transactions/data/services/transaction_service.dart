import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:masroof_app/core/constants/api_constants.dart';
import 'package:masroof_app/features/transactions/data/models/transaction_model.dart';

class TransactionService {
  Future<Map<String, dynamic>> createTransaction(
    TransactionModel transaction,
  ) async {
    final url = Uri.parse(ApiConstants.createTransaction);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},

        body: jsonEncode(transaction.toJson()),
      );
      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return decodedResponse;
      } else {
        final message =
            decodedResponse['message'] ??
            decodedResponse['error'] ??
            'حدث خطأ أثناء إضافة العملية';
        throw Exception(message);
      }
    } catch (e) {
      print('TransactionService ERROR: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getTransactions({required int userId}) async {
    final url = Uri.parse('${ApiConstants.getTransactions}?userId=$userId');
    try {
      final response = await http.get(url);
      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return decodedResponse;
      } else {
        final message =
            decodedResponse['message'] ??
            decodedResponse['error'] ??
            'حدث خطأ أثناء جلب العمليات';
        throw Exception(message);
      }
    } catch (e) {
      print('TransactionService ERROR: $e');
      rethrow;
    }
  }
}
