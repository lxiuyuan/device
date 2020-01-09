import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class SpUtils{

  //json转换框架
  static JsonDecoder _mJsonDecoder = JsonDecoder();
  static JsonEncoder _mJsonEncoder = JsonEncoder();
  static SharedPreferences _sharedPreferences;
  ///获取string字符串
  static Future<String> getString(String key) async {
    await init();
    return _sharedPreferences.getString(key);
  }

  static Future<Map<String,dynamic>> getJson(String key) async {
    await init();
    try {
      var str = _sharedPreferences.getString(key);
      if (str != null) {
        return _mJsonDecoder.convert(str);
      } else {
        return Map();
      }
    }catch(e){
      print(e.toString());
      return Map();
    }
  }

  static Future<bool> setJson(String key,Map<String,dynamic> value) async{
    await init();
    var str=_mJsonEncoder.convert(value);
    return await _sharedPreferences.setString(key, str);
  }

  ///保存string字符串
  static Future<bool> setString(String key,String value)async {
    await init();
    return await _sharedPreferences.setString(key, value);
  }
  ///获取StringList
  static Future<List<String>> getStringList(String key) async {
    await init();
    return _sharedPreferences.getStringList(key);
  }
  ///保存StringList
  static Future<bool > setStringList(String key,List<String> value)async{
    await init();
    return await _sharedPreferences.setStringList(key, value);
  }

  static Future<void> init() async {
    if(_sharedPreferences==null)
     _sharedPreferences=await SharedPreferences.getInstance();

  }


}