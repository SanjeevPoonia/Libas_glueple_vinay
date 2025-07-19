
import 'package:shared_preferences/shared_preferences.dart';

class MyUtils
{
  static Future<Null> saveSharedPreferences(String key, String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(key, value);
    return null;
  }

  static Future<String?> getSharedPreferences(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? value =  preferences.getString(key);
    return value;
  }
}