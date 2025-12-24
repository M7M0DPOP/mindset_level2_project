import 'package:mindset_level2_project/features/authentication/domain/entities/user_entity.dart';

abstract class UserRepo {
  Future<void> saveUser(UserEntity userEntity);
  UserEntity loadUser();
  Future<void> clearUser();
  bool? isUserLoggedIn();
  bool? isFristTime();
}
