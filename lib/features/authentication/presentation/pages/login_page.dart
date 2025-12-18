import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindset_level2_project/core/app_themes.dart';
import 'package:mindset_level2_project/core/widgets/custom_text_widget.dart';
import 'package:mindset_level2_project/features/authentication/presentation/cubit/login_cubit.dart';
import 'package:mindset_level2_project/core/widgets/custom_elevated_button.dart';
import 'package:mindset_level2_project/core/widgets/custom_text_form_field.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isObscure = true;
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocProvider(
            create: (context) => LoginCubit(),
            child: BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
                if (state is LoginSuccess) {
                  Navigator.pushNamed(context, "/home");
                } else if (state is LoginFailure) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
                }
              },
              builder: (context, state) {
                return Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    spacing: 20,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(100),
                        child: Image.asset(
                          'assets/logo.png',
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: CustomTextWidget(
                          data: 'Email',
                          color: const Color.fromARGB(239, 255, 255, 255),
                          fontSize: 20,
                        ),
                      ),
                      // TextFormField for Email
                      CustomTextFormField(
                        controller: emailController,
                        hintText: 'Enter your email',
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (value.contains(RegExp(r'\w+@\w+.com')) == false) {
                            return 'email must have @ and .com';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Password',
                          style: TextStyle(
                            color: Color.fromARGB(239, 255, 255, 255),
                            fontSize: 20,
                          ),
                        ),
                      ),
                      // TextFormField for Password
                      BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state) {
                          return CustomTextFormField(
                            controller: passwordController,
                            hintText: 'Enter your password',
                            isObscure: isObscure,
                            toggleObscure: () {
                              context.read<LoginCubit>().toggleObscure();
                              isObscure = !isObscure;
                            },
                            icon: isObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                      // Sign In Button
                      CustomElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<LoginCubit>().loginUser(
                              emailController.text,
                              passwordController.text,
                            );
                          }
                        },
                        child: CustomTextWidget(
                          data: 'Login',

                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppThemes.primaryColor,
                        ),
                      ),
                      SizedBox(height: 180),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: CustomTextWidget(
                          fontSize: 14,
                          data: 'Create new account',
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
