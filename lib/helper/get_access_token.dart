import 'package:shared_preferences/shared_preferences.dart';

mixin AccessTokenProvider {
  Future<String?> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("AccessToken");
  }

  static Future<String?> token() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("AccessToken");
  }
}
