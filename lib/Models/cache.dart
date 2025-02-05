import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheUtil {
  static SharedPreferences? _preferences;

  /// Initializes the SharedPreferences instance.
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }


  static Future<void> setList(
      String key, List<Map<String, dynamic>> value) async {
    String jsonString = jsonEncode(value);
    await _preferences?.setString(key, jsonString);
  }

  /// Retrieves a list of maps.
  static List<Map<String, dynamic>> getList(String key) {
    String? jsonString = _preferences?.getString(key);
    if (jsonString == null) return [];
    List<dynamic> decodedList = jsonDecode(jsonString);
    print(decodedList);
    return decodedList.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  /// Stores a map add an item to th elist
  static Future<void> addItemToList(
      String key, Map<String, dynamic> value) async {
    List<Map<String, dynamic>> list = getList(key);
    list.add(value);
    await setList(key, list);
  }


  static Future<void> removeItemFromList(
      String key, Map<String, dynamic> value) async {
    List<Map<String, dynamic>> list = getList(key);
    list.remove(value);
    await setList(key, list);
  }

  static Future<void> clear() async {
    await _preferences?.clear();
  }

  //to change quantity
  static Future<void> changeQuantity(
      String key, Map<String, dynamic> value) async {
    List<Map<String, dynamic>> list = getList(key);
    list.remove(value);
    list.add(value);
    await setList(key, list);
  }
}
