import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindset_level2_project/features/authentication/data/repositories/shared_prefs_helper_impl.dart';
import 'package:mindset_level2_project/features/authentication/data/repositories/user_repo_impl.dart';
import 'package:mindset_level2_project/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mindset_level2_project/features/authentication/presentation/pages/home_page.dart';
import 'package:mindset_level2_project/features/authentication/presentation/pages/login_page.dart';
import 'package:mindset_level2_project/features/authentication/presentation/pages/register_page.dart';
import 'package:mindset_level2_project/firebase_options.dart';
import 'core/dependency_injection/injection.dart';
import 'features/authentication/presentation/pages/onboarding_page.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final getIt = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await sl.init();
  await SharedPrefsHelperImpl.initSharedPref();
  getIt.registerSingleton<UserRepoImpl>(UserRepoImpl());
  runApp(
    BlocProvider(
      create: (context) => sl.getTaskCubit(),
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: getIt<UserRepoImpl>().isUserLoggedIn() ?? false
              ? "/home"
              : getIt<UserRepoImpl>().isFristTime() ?? true
              ? "/"
              : "/login",
          routes: {
            "/": (context) => OnboardingPage(),
            "/register": (context) => BlocProvider(
              create: (context) =>
                  AuthenticationCubit(userRepo: getIt<UserRepoImpl>()),
              child: RegisterPage(),
            ),
            "/login": (context) => BlocProvider(
              create: (context) =>
                  AuthenticationCubit(userRepo: getIt<UserRepoImpl>()),
              child: LoginPage(),
            ),
            "/home": (context) => HomePage(),
          },
        ),
        child: BlocProvider(
          create: (context) =>
              AuthenticationCubit(userRepo: getIt<UserRepoImpl>()),
          child: LoginPage(),
        ),
      ),
    ),
  );
}
