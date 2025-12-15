import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mindset_level2_project/features/authentication/presentation/pages/login_page.dart';
import 'package:mindset_level2_project/features/authentication/presentation/pages/onboarding_page.dart';
import 'package:mindset_level2_project/features/authentication/presentation/pages/register_page.dart';
import 'package:mindset_level2_project/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final bool isLogged = await isLoggedIn();
  print(isLogged);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: isLogged ? "/login" : '/',
      routes: {
        "/": (context) => OnboardingPage(),
        "/register": (context) => RegisterPage(),
        "/login": (context) => LoginPage(),
      },
    ),
  );
}
