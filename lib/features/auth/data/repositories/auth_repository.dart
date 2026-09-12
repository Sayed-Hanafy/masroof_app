import 'package:masroof_app/features/auth/data/local/auth_local_data_source.dart';
import 'package:masroof_app/features/auth/data/models/auth_response_model.dart';
import 'package:masroof_app/features/auth/data/models/user_model.dart';
import 'package:masroof_app/features/auth/data/services/auth_service.dart';

class AuthRepository {
  final AuthService authService;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepository({
    required this.authService,
    required this.authLocalDataSource,
  });

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await authService.login(email: email, password: password);

    final authResponse = AuthResponseModel.fromJson(response);

    if (authResponse.status && authResponse.user != null) {
      await authLocalDataSource.saveUser(authResponse.user!);
    }

    return authResponse;
  }

  UserModel? getUser() {
    return authLocalDataSource.getUser();
  }

  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await authService.register(
      name: name,
      email: email,
      password: password,
    );

    final authResponse = AuthResponseModel.fromJson(response);

    return authResponse;
  }

  bool isLoggedIn() {
    return authLocalDataSource.isLoggedIn();
  }

  Future<void> logout() async {
    await authLocalDataSource.logOut();
  }
}
