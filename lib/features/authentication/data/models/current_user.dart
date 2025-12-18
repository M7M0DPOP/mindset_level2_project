import 'package:shared_preferences/shared_preferences.dart';

class CurrentUser {
  CurrentUser._();
  static String? email;
  static String? userId;
  static String? userName;
  static String? userImage;
  static bool? isFristTime;
  static late SharedPreferences _prefs;

  static initSharedPref() async {
    _prefs = await SharedPreferences.getInstance();
    email = _prefs.getString('userEmail');
    userId = _prefs.getString('userId');
    userName = _prefs.getString('userName');
    isFristTime = _prefs.getBool('isFristTime');
    userImage = _prefs.getString("userImage");
  }

  static logout() {
    _prefs.setBool('isLoggedIn', false);
    _prefs.remove('userEmail');
    _prefs.remove('userId');
    _prefs.remove('userName');
    _prefs.remove('userImage');
    email = null;
    userId = null;
    userName = null;
  }

  static bool get isLoggedIn => _prefs.getBool('isLoggedIn') ?? false;

  static saveUserState(
    String userId,
    String email,
    String userName,
    String userImage,
  ) async {
    await _prefs.setString('userEmail', email);
    await _prefs.setString('userId', userId);
    await _prefs.setString('userName', userName);
    await _prefs.setString("userImage", userImage);
    await _prefs.setBool('isFristTime', false);
    await _prefs.setBool('isLoggedIn', true);
  }
}
