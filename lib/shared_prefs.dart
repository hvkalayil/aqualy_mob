import 'package:shared_preferences/shared_preferences.dart';

///Keys
///current_screen
class SharedPrefs {
  static Future<String> getSavedStr(String key) async =>
      SharedPreferences.getInstance().then((prefs) => prefs.getString(key));

  static Future<void> saveStr(String key, String value) async =>
      SharedPreferences.getInstance()
          .then((prefs) => prefs.setString(key, value));
}
