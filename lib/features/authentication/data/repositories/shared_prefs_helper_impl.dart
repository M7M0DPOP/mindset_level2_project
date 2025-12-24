import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelperImpl {
  SharedPrefsHelperImpl._();
  static SharedPreferences? _prefs;

  static Future<void> initSharedPref() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences? get getInstance => _prefs;
}
