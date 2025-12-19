import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindset_level2_project/features/authentication/data/models/current_user.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  void toggleObscure() {
    emit(RegisterInitial());
  }

  registerUser(String email, String password, String name) async {
    emit(RegisterLoading());
    try {
      final user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await user.user!.updateDisplayName(name);

      await CurrentUser.saveUserState(
        user.user!.uid,
        user.user!.email ?? '',
        user.user!.displayName ?? "",
        user.user!.photoURL ?? '',
      );
      await CurrentUser.initSharedPref();

      if (!isClosed) emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        if (!isClosed) {
          emit(RegisterFailure('The password provided is too weak.'));
        }
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        if (!isClosed) {
          emit(RegisterFailure('The account already exists for that email.'));
        }
      }
    } catch (e) {
      print(e);
      if (!isClosed) emit(RegisterFailure(e.toString()));
    }
  }
}
