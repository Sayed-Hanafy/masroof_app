import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:masroof_app/core/constants/api_constants.dart';

class AuthService {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse(ApiConstants.login);

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 10));

      final decodedResponse = jsonDecode(response.body);

      // هنا أهم جزء: التحقق من status code
      if (response.statusCode == 200 || response.statusCode == 201) {
        return decodedResponse;
      } else {
        // السيرفر رجع خطأ (401 باسورد غلط، 400، 422، ...الخ)
        final message =
            decodedResponse['message'] ??
            decodedResponse['error'] ??
            'حدث خطأ أثناء تسجيل الدخول';
        throw Exception(message);
      }
    } catch (e) {
      print('AuthService ERROR: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse(ApiConstants.register);

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"name": name, 'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 10));

      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return decodedResponse;
      } else {
        
        final message =
            decodedResponse['message'] ??
            decodedResponse['error'] ??
            ' حدث خطأ أثناء إنشاء الحساب ';
        throw Exception(message);
      }
    } catch (e) {
      print('AuthService ERROR: $e');
      rethrow;
    }
  }
}
