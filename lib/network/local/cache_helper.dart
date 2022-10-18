import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static bool? isDark;
  static late SharedPreferences preferences;

  static Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setBoolean(
      {required String key, required bool value}) async {
    return await preferences.setBool(key, value);
  }

  static bool? getBoolean({required String key}) {
    return preferences.getBool(key);
  }

  static Future<bool> saveData(
      {required String key, required dynamic value}) async {
    if (value is int) {
      return await preferences.setInt(key, value);
    } else if (value is double) {
      return await preferences.setDouble(key, value);
    } else if (value is String) {
      return await preferences.setString(key, value);
    } else {
      return await preferences.setBool(key, value);
    }
  }

  static dynamic getData(String key) async {
    return preferences.get(key);
  }

  static Future<bool> clearData(String key) async {
    return await preferences.remove(key);
  }
}
