import 'package:mindset_level2_project/features/authentication/data/models/user_model.dart';
import 'package:mindset_level2_project/features/authentication/data/repositories/shared_prefs_helper_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLocalDatasources {
  Future<void> saveUserChache(UserModel userModel) async {
    SharedPreferences? prefs = SharedPrefsHelperImpl.getInstance!;
    await prefs.setString('user', userModel.toJson());
  }

  UserModel? getUser()  {
    final SharedPreferences? prefs = SharedPrefsHelperImpl.getInstance;

    String? userString = prefs?.getString('user');

    if (userString != null) {
      return UserModel.fromJson(userString);
    }

    return null;
  }
}
