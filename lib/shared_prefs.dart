import 'package:shared_preferences/shared_preferences.dart';

///Keys
///current_screen index shopId name
class SharedPrefs {
  static Future<int> getSavedNum(String key) async =>
      SharedPreferences.getInstance().then((prefs) => prefs.getInt(key));

  static Future<void> saveNum(String key, int value) async =>
      SharedPreferences.getInstance().then((prefs) => prefs.setInt(key, value));

  static Future<double> getSavedDouble(String key) async =>
      SharedPreferences.getInstance().then((prefs) => prefs.getDouble(key));

  static Future<void> saveDouble(String key, double value) async =>
      SharedPreferences.getInstance()
          .then((prefs) => prefs.setDouble(key, value));

  static Future<String> getSavedStr(String key) async =>
      SharedPreferences.getInstance().then((prefs) => prefs.getString(key));

  static Future<void> saveStr(String key, String value) async =>
      SharedPreferences.getInstance()
          .then((prefs) => prefs.setString(key, value));

  static Future<void> clearAll() async =>
      SharedPreferences.getInstance().then((value) => value.clear());
}
