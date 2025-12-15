import 'package:flutter/material.dart';
import 'package:mindset_level2_project/core/app_themes.dart';
import 'package:mindset_level2_project/core/widgets/custom_elevated_button.dart';
import 'package:mindset_level2_project/core/widgets/custom_text_widget.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.primaryColor,
      appBar: AppBar(
        centerTitle: true,
        title: CustomTextWidget(
          data: 'Taskly',
          fontSize: 28,
          fontWeight: FontWeight.w700,
        ),
        backgroundColor: AppThemes.primaryColor,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(20),
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextWidget(
              data: 'Organize your day, achieve more',

              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),

            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(16),
              child: Image.asset(
                "assets/onbording_img.png",
                fit: BoxFit.cover,
                width: 358,
                height: 537,
              ),
            ),
            SizedBox(width: double.infinity, height: 100),
            CustomElevatedButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/login'),
              child: CustomTextWidget(
                data: 'Get Started',

                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppThemes.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
