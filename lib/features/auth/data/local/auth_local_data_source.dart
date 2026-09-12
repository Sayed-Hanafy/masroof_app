import 'package:masroof_app/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  final SharedPreferences preferences;

  AuthLocalDataSource({required this.preferences});

  Future<void> saveUser(UserModel user) async {
    await preferences.setBool('isLoggedIn', true);
    await preferences.setInt('userId', user.id);
    await preferences.setString('userName', user.name);
    await preferences.setString('userEmail', user.email);
  }

  bool isLoggedIn() {
    return preferences.getBool('isLoggedIn') ?? false;
  }

   UserModel? getUser() {
    final userId = preferences.getInt('userId');
    final userName = preferences.getString('userName');
    final userEmail = preferences.getString('userEmail');

    if (userId == null || userName == null || userEmail == null) {
      return null;
    }

    return UserModel(
      id: userId,
      name: userName,
      email: userEmail,
    );
  }

  Future<void> logOut() async {
    await preferences.remove('isLoggedIn');
    await preferences.remove('userId');
    await preferences.remove('userName');
    await preferences.remove('userEmail');

  }
}
