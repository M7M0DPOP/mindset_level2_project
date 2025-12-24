import 'package:mindset_level2_project/features/authentication/data/models/user_model.dart';
import 'package:mindset_level2_project/features/authentication/data/repositories/shared_prefs_helper_impl.dart';
import 'package:mindset_level2_project/features/authentication/domain/entities/user_entity.dart';
import 'package:mindset_level2_project/features/authentication/domain/repositories/user_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepoImpl extends UserRepo {
  static final SharedPreferences _prfs = SharedPrefsHelperImpl.getInstance!;
  @override
  bool? isFristTime() {
    return _prfs.getBool('isFristTime') ?? true;
  }

  @override
  bool? isUserLoggedIn() {
    return _prfs.getBool('isLoggedIn') ?? false;
  }

  @override
  Future<void> saveUser(UserEntity userEntity) async {
    await _prfs.setBool('isLoggedIn', true);
    await _prfs.setBool('isFristTime', false);
    final userModel = UserModel(
      email: userEntity.email,
      userId: userEntity.userId,
      userName: userEntity.userName,
      userImage: userEntity.userImage,
    );
    await _prfs.setString('user', userModel.toJson());
  }

  @override
  UserEntity loadUser() {
    final userModel = UserModel.fromJson(_prfs.getString('user') ?? '');
    return UserEntity(
      email: userModel.email,
      userId: userModel.userId,
      userName: userModel.userName,
      userImage: userModel.userImage,
    );
  }

  @override
  Future<void> clearUser() async {
    await _prfs.remove('user');
    await _prfs.setBool('isLoggedIn', false);
  }
}
