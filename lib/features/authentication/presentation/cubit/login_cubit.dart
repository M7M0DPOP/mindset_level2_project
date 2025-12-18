
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindset_level2_project/features/authentication/data/models/current_user.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  void toggleObscure() {
    emit(LoginInitial());
  }

  loginUser(String email, String password) async {
    emit(LoginLoading());
    try {
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      CurrentUser.saveUserState(
        user.user!.uid,
        user.user!.email ?? "",
        user.user!.displayName ?? '',
        user.user!.photoURL ?? '',
      );
      CurrentUser.initSharedPref();

      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        emit(LoginFailure('No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        emit(LoginFailure('Wrong password provided for that user.'));
      }
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> signout() async {
    emit(LoginLoading());
    CurrentUser.logout();
    await FirebaseAuth.instance.signOut();
    emit(LoginInitial());
  }
}
