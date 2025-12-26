import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindset_level2_project/core/app_themes.dart';
import 'package:mindset_level2_project/core/widgets/custom_text_widget.dart';
import 'package:mindset_level2_project/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mindset_level2_project/features/authentication/presentation/pages/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: AppThemes.primaryColor,
        title: CustomTextWidget(
          fontSize: 28,
          data: 'Welcome to Taskly',
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: AppThemes.primaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.all(20.w),
            child: BlocConsumer<AuthenticationCubit, AuthenticatonState>(
              listener: (context, state) {
                if (state is AuthenticatonSuccess) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    "/home",
                    (route) => false,
                  );
                } else if (state is AuthenticatonFailure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
                }
              },
              builder: (context, state) {
                if (state is AuthenticatonLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return LoginForm(formKey: formKey, emailController: emailController, passwordController: passwordController);
              },
            ),
          ),
        ),
      ),
    );
  }
}
