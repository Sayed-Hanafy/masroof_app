import 'package:masroof_app/features/auth/data/models/user_model.dart';

class AuthResponseModel {
  final bool status;
  final String message;
  final UserModel? user;

  AuthResponseModel({
    required this.status,
    required this.message,
    this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      status: json['status'],
      message: json['message'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }
}