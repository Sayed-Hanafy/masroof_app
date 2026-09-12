import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:masroof_app/core/constants/api_constants.dart';

class CategoryService {
  Future<Map<String, dynamic>> getCategories({required int userId}) async {
    final url = Uri.parse(ApiConstants.getCategory);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );

      final decodedResponse = jsonDecode(response.body);


      if (response.statusCode == 200 || response.statusCode == 201) {
        return decodedResponse;
      } else {
        decodedResponse['message'] ??
            decodedResponse['error'] ??
            'حدث خطأ أثناء جلب الفئات';
        throw Exception('message');
      }
    } catch (e) {
      print('CategoryService ERROR: $e');
      rethrow;
    }
  }
}
