import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindset_level2_project/core/app_themes.dart';
import 'package:mindset_level2_project/core/widgets/custom_text_widget.dart';
import 'package:mindset_level2_project/features/authentication/presentation/cubit/login_cubit.dart';
import 'package:mindset_level2_project/features/authentication/presentation/cubit/register_cubit.dart';
import 'package:mindset_level2_project/features/authentication/presentation/pages/register_page.dart';
import 'package:mindset_level2_project/core/widgets/custom_elevated_button.dart';
import 'package:mindset_level2_project/core/widgets/custom_text_form_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  bool isObscure = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: AppThemes.primaryColor,
        title: CustomTextWidget(
          fontSize: 28,
          data: 'Create new account',
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: AppThemes.primaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocProvider(
            create: (context) => RegisterCubit(),
            child: BlocConsumer<RegisterCubit, RegisterState>(
              listener: (context, state) {
                if (state is RegisterSuccess) {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => HomePage()),
                  // );
                } else if (state is RegisterFailure) {
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
                    spacing: 5,
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
                          data: 'Full Name',
                          color: const Color.fromARGB(239, 255, 255, 255),
                          fontSize: 18,
                        ),
                      ),
                      // TextFormField for Email
                      CustomTextFormField(
                        controller: userNameController,
                        hintText: 'Enter your name',
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your email';
                          }

                          return null;
                        },
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: CustomTextWidget(
                          data: 'Email',
                          color: const Color.fromARGB(239, 255, 255, 255),
                          fontSize: 18,
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
                      BlocBuilder<RegisterCubit, RegisterState>(
                        builder: (context, state) {
                          return CustomTextFormField(
                            controller: passwordController,
                            hintText: 'Enter your password',
                            isObscure: isObscure,
                            toggleObscure: () {
                              context.read<RegisterCubit>().toggleObscure();
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
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'Confirm password',
                          style: TextStyle(
                            color: Color.fromARGB(239, 255, 255, 255),
                            fontSize: 20,
                          ),
                        ),
                      ),
                      // TextFormField for Password
                      BlocBuilder<RegisterCubit, RegisterState>(
                        builder: (context, state) {
                          return CustomTextFormField(
                            controller: confirmPasswordController,
                            hintText: 'confirm your password',
                            isObscure: isObscure,
                            toggleObscure: () {
                              context.read<RegisterCubit>().toggleObscure();
                              isObscure = !isObscure;
                            },
                            icon: isObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                            validator: (value) {
                              if (value != passwordController.text) {
                                return 'Please confirm your password';
                              }

                              return null;
                            },
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      // Sign In Button
                      CustomElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context.read<RegisterCubit>().registerUser(
                              emailController.text,
                              passwordController.text,
                              userNameController.text,
                            );
                          }
                        },
                        child: CustomTextWidget(
                          data: 'Register',

                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppThemes.primaryColor,
                        ),
                      ),
                      SizedBox(height: 60),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
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
