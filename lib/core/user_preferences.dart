import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences? _prefs;

  static const _keyToken = 'token';

  static Future init() async => _prefs = await SharedPreferences.getInstance();

  static Future setToken(String token) async =>
      await _prefs?.setString(_keyToken, token);

  static Future getToken() async => _prefs?.getString(_keyToken);

  static Future removeToken() async => _prefs?.remove(_keyToken);
}
