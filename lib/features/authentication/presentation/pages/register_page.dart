import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mindset_level2_project/features/authentication/presentation/cubit/register_cubit.dart';
import 'package:mindset_level2_project/features/authentication/presentation/pages/login_page.dart';
import 'package:mindset_level2_project/features/authentication/presentation/widgets/custom_elevated_button.dart';
import 'package:mindset_level2_project/features/authentication/presentation/widgets/custom_text_form_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
      appBar: AppBar(backgroundColor: const Color.fromARGB(255, 15, 23, 28)),
      backgroundColor: const Color.fromARGB(255, 15, 23, 28),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocProvider(
          create: (context) => RegisterCubit(),
          child: BlocConsumer<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if (state is RegisterSuccess) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
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
                  spacing: 20,
                  children: [
                    Icon(
                      Icons.app_registration,
                      size: 100,
                      color: Colors.white,
                    ),
                    Text(
                      'Welcome to MyApp',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Sign up to continue',
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
                        if (!RegExp(r'\w+@\w+.com').hasMatch(value)) {
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
                          icon: isObscure
                              ? Icons.visibility_off
                              : Icons.visibility,
                          toggleObscure: () {
                            isObscure = !isObscure;
                            context.read<RegisterCubit>().toggleObscure();
                          },
                          isObscure: isObscure,
                          controller: passwordController,
                          hintText: 'Enter your password',
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
                    // Sign Up Button
                    BlocBuilder<RegisterCubit, RegisterState>(
                      builder: (context, state) {
                        return CustomElevatedButton(
                          backgroundColor: const Color.fromARGB(
                            255,
                            40,
                            140,
                            235,
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context.read<RegisterCubit>().registerUser(
                                emailController.text,
                                passwordController.text,
                              );
                            }
                          },
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
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
                    BlocBuilder<RegisterCubit, RegisterState>(
                      builder: (context, state) {
                        return CustomElevatedButton(
                          backgroundColor: const Color.fromARGB(
                            255,
                            15,
                            23,
                            28,
                          ),
                          onPressed: () async {
                            await context
                                .read<RegisterCubit>()
                                .signInWithGoogle();
                          },
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
                              if (state is RegisterLoading)
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
                          'have an account?',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
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
                            ' Sign In',
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
