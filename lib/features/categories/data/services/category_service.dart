import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:masroof_app/core/constants/api_constants.dart';

class CategoryService {
  Future<Map<String, dynamic>> getCategories({
    required String type,
  }) async {
    final url = Uri.parse(ApiConstants.getCategory);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'type': type}),
      ).timeout(const Duration(seconds: 10));

      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return decodedResponse;
      } else {
        final message =
            decodedResponse['message'] ??
            decodedResponse['error'] ??
            'حدث خطأ أثناء جلب الفئات';

        throw Exception(message);
      }
    } catch (e) {
      print('CategoryService ERROR: $e');
      rethrow;
    }
  }
}