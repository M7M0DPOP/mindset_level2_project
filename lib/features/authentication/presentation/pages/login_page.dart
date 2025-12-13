import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindset_level2_project/features/authentication/presentation/cubit/login_cubit.dart';
import 'package:mindset_level2_project/features/authentication/presentation/pages/register_page.dart';
import 'package:mindset_level2_project/features/authentication/presentation/widgets/custom_elevated_button.dart';
import 'package:mindset_level2_project/features/authentication/presentation/widgets/custom_text_form_field.dart';

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
      backgroundColor: const Color.fromARGB(255, 15, 23, 28),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocProvider(
          create: (context) => LoginCubit(),
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
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
                    Icon(Icons.login, size: 100, color: Colors.white),
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Sign in to continue',
                      style: TextStyle(color: Colors.white60, fontSize: 18),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Email',
                        style: TextStyle(
                          color: const Color.fromARGB(239, 255, 255, 255),
                          fontSize: 20,
                        ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Password',
                          style: TextStyle(
                            color: Color.fromARGB(239, 255, 255, 255),
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 21, 97, 160),
                            fontSize: 14,
                          ),
                        ),
                      ],
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
                      backgroundColor: const Color.fromARGB(255, 40, 140, 235),
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.white60,
                            thickness: 1,
                            height: 20,
                            radius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.white60,
                            thickness: 1,
                            height: 20,
                            radius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                    // Sign In with Google Button
                    BlocBuilder<LoginCubit, LoginState>(
                      builder: (context, state) {
                        return CustomElevatedButton(
                          onPressed: () async {
                            await context.read<LoginCubit>().signInWithGoogle();
                          },
                          backgroundColor: const Color.fromARGB(
                            255,
                            15,
                            23,
                            28,
                          ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: SvgPicture.asset(
                                  'icons/google.svg',
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                              if (state is LoginLoading)
                                CircularProgressIndicator()
                              else
                                Text(
                                  'continue with Google',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              255,
                              15,
                              23,
                              28,
                            ),
                          ),
                          child: Text(
                            ' Sign Up',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 26, 117, 192),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
