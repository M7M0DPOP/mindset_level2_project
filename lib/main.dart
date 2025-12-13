import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mindset_level2_project/features/authentication/presentation/pages/login_page.dart';
import 'package:mindset_level2_project/features/authentication/presentation/pages/register_page.dart';
import 'package:mindset_level2_project/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MaterialApp(
      initialRoute: '/',
      routes: {
        "/": (context) => RegisterPage(),
        "/login": (context) => LoginPage(),
      },
    ),
  );
}
