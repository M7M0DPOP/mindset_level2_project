
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  void toggleObscure() {
    emit(RegisterInitial());
  }

  registerUser(String email, String password) async {
    emit(RegisterLoading());
    try {
      final user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      emit(RegisterSuccess(userCredential: user));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        emit(RegisterFailure('The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        emit(RegisterFailure('The account already exists for that email.'));
      }
    } catch (e) {
      print(e);
      emit(RegisterFailure(e.toString()));
    }
  }
  //thanks for Flutter Root youtube channel for google sign in help

  Future signInWithGoogle() async {
    emit(RegisterLoading());
    // Trigger the authentication flow
    try {
      final user = await FirebaseAuth.instance.signInWithProvider(
        GoogleAuthProvider(),
      );
      emit(RegisterSuccess(userCredential: user));
    } catch (e) {
      print(e);
      emit(RegisterFailure(e.toString()));
    }
  }

  Future<void> signout() async {
    emit(RegisterLoading());
    await FirebaseAuth.instance.signOut();
    emit(RegisterInitial());
  }
}
