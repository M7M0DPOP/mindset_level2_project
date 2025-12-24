import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindset_level2_project/core/app_themes.dart';
import 'package:mindset_level2_project/core/widgets/custom_text_widget.dart';
import 'package:mindset_level2_project/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:mindset_level2_project/features/authentication/presentation/pages/register_form.dart';

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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
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
                return RegisterForm(
                  formKey: formKey,
                  userNameController: userNameController,
                  emailController: emailController,
                  passwordController: passwordController,
                  confirmPasswordController: confirmPasswordController,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
