import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  String loginToken = "loginToken";
  String userId = "userId";

  Future<void> setLoginToken(String loginToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.loginToken, loginToken);
  }

//get value from shared preferences
  Future<String> getLoginToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    loginToken = pref.getString(this.loginToken) ?? null;
    return loginToken;
  }

  Future<void> setUserId(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.userId, userId);
  }

  Future<String> getUserId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    userId = pref.getString(this.userId) ?? null;
    return userId;
  }

  clearShared() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    // preferences.clear();
    preferences.getKeys();
    preferences.remove("userId");
    preferences.remove("loginToken");
  }
}
