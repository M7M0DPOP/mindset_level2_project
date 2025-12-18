import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindset_level2_project/features/authentication/data/models/current_user.dart';
import 'package:mindset_level2_project/features/authentication/presentation/pages/home_page.dart';
import 'package:mindset_level2_project/features/authentication/presentation/pages/login_page.dart';
import 'package:mindset_level2_project/features/authentication/presentation/pages/register_page.dart';
import 'package:mindset_level2_project/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/dependency_injection/injection.dart';
import 'features/authentication/presentation/pages/onboarding_page.dart';

Future<bool> isLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await sl.init();
  await CurrentUser.initSharedPref();
  runApp(
    BlocProvider(
      create: (context) => sl.getTaskCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: CurrentUser.isLoggedIn ? "/home" : CurrentUser.isFristTime??true ? "/" : "/login",
        routes: {
          "/": (context) => OnboardingPage(),
          "/register": (context) => RegisterPage(),
          "/login": (context) => LoginPage(),
          "/home": (context) => HomePage(),
        },
      ),
    ),
  );
}
