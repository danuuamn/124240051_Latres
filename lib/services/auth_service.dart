import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService {
  static Future<bool> register(String username, String password) async {
    final box = Hive.box<User>('users');
    for (int i = 0; i < box.length; i++) {
      final user = box.getAt(i);
      if (user != null && user.username == username) {
        return false;
      }
    }
    await box.add(User(username: username, password: password));
    return true;
  }

  static Future<bool> login(String username, String password) async {
    final box = Hive.box<User>('users');
    for (int i = 0; i < box.length; i++) {
      final user = box.getAt(i);
      if (user != null &&
          user.username == username &&
          user.password == password) {
        final loginData = await SharedPreferences.getInstance();
        await loginData.setBool('loginData', true);
        return true;
      }
    }
    return false;
  }

  static Future<bool> isLoggedIn() async {
    final loginData = await SharedPreferences.getInstance();
    return loginData.getBool('loginData') ?? false;
  }

  static Future<void> logout() async {
    final loginData = await SharedPreferences.getInstance();
    await loginData.setBool('loginData', false);
  }
}
