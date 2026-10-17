import 'dart:convert';

import 'package:flutter/foundation.dart';
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
      ).timeout(const Duration(seconds: 15));
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
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(decodedResponse);
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

  Future<Map<String, dynamic>> updateTransaction(
    int transactionId,
    TransactionModel transaction,
  ) async {
    final url = Uri.parse(ApiConstants.updateTransaction);
    try {
      final data = transaction.toJson();
      data['transaction_id'] = transactionId;
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      ).timeout(const Duration(seconds: 10));
      Map<String, dynamic>? decodedResponse;
      try {
        decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (_) {
        decodedResponse = null;
      }
      if (response.statusCode == 200 && decodedResponse != null) {
        return decodedResponse;
      } else {
        final message =
            decodedResponse?['message'] ??
            decodedResponse?['error'] ??
            'حدث خطأ أثناء تحديث العملية';
        throw Exception(message);
      }
    } catch (e) {
      print('TransactionService ERROR: $e');
      rethrow;
    }
  }

    Future<Map<String, dynamic>> deleteTransaction(
    int transactionId,
    int userId,
  ) async {
    final url = Uri.parse(ApiConstants.deleteTransaction);
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'transaction_id': transactionId,
          'user_id': userId,
        }),
      ).timeout(const Duration(seconds: 10));

      Map<String, dynamic>? decodedResponse;
      try {
        decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (_) {
        decodedResponse = null;
      }
      // final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200 && decodedResponse != null) {
        return decodedResponse;
      } else {
        final message =
            decodedResponse?['message'] ??
            decodedResponse?['error'] ??
            'حدث خطأ أثناء حذف العملية';
        throw Exception(message);
      }
    } catch (e) {
      print('TransactionService ERROR: $e');
      rethrow;
    }
  }
}
