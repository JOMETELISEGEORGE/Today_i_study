import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  static const _email = 'email';
  static const _pass = 'pass';
  static const _logged = 'logged';

  static String _hash(String v) =>
      base64Encode(utf8.encode(v));

  static Future<bool> signup(String e, String p) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_email)) return false;
    await prefs.setString(_email, e);
    await prefs.setString(_pass, _hash(p));
    await prefs.setBool(_logged, true);
    return true;
  }

  static Future<bool> login(String e, String p) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_email) == e &&
        prefs.getString(_pass) == _hash(p)
        ? await prefs.setBool(_logged, true)
        : false;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_logged) ?? false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_logged, false);
  }
}
