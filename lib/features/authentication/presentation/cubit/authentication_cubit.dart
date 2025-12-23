import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mindset_level2_project/features/authentication/data/repositories/user_repo_impl.dart';
import 'package:mindset_level2_project/features/authentication/domain/entities/user_entity.dart';
import 'package:mindset_level2_project/features/authentication/domain/repositories/user_repo.dart';
part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticatonState> {
  UserRepo userRepo = UserRepoImpl();
  AuthenticationCubit({required this.userRepo}) : super(AuthenticatonInitial());

  void toggleObscure() {
    emit(AuthenticatonInitial());
  }

  Future<void> signUser(String email, String password, String? name) async {
    emit(AuthenticatonLoading());
    try {
      final UserCredential user;
      if (name != null) {
        user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await user.user!.updateDisplayName(name);
      } else {
        user = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }

      await userRepo.saveUser(
        UserEntity(
          userId: user.user!.uid,
          userImage: user.user!.photoURL ?? '',
          userName: user.user!.displayName ?? '',
          email: user.user!.email!,
        ),
      );

      if (!isClosed) emit(AuthenticatonSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        if (!isClosed) {
          emit(AuthenticatonFailure('The password provided is too weak.'));
        }
      } else if (e.code == 'email-already-in-use') {
        if (!isClosed) {
          emit(
            AuthenticatonFailure('The account already exists for that email.'),
          );
        }
      }
    } catch (e) {
      if (!isClosed) emit(AuthenticatonFailure(e.toString()));
    }
  }
}
