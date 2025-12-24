import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindset_level2_project/core/app_themes.dart';
import 'package:mindset_level2_project/core/widgets/custom_elevated_button.dart';
import 'package:mindset_level2_project/core/widgets/custom_text_form_field.dart';
import 'package:mindset_level2_project/core/widgets/custom_text_widget.dart';
import 'package:mindset_level2_project/features/authentication/presentation/cubit/authentication_cubit.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
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
            controller: widget.emailController,
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
          BlocBuilder<AuthenticationCubit, AuthenticatonState>(
            builder: (context, state) {
              return CustomTextFormField(
                controller: widget.passwordController,
                hintText: 'Enter your password',
                isObscure: isObscure,
                toggleObscure: () {
                  context.read<AuthenticationCubit>().toggleObscure();
                  isObscure = !isObscure;
                },
                icon: isObscure ? Icons.visibility_off : Icons.visibility,
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
              if (widget.formKey.currentState!.validate()) {
                context.read<AuthenticationCubit>().signUser(
                  widget.emailController.text,
                  widget.passwordController.text,
                  null,
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
            child: CustomTextWidget(fontSize: 14, data: 'Create new account'),
          ),
        ],
      ),
    );
  }
}
