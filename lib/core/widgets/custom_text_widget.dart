import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindset_level2_project/core/app_themes.dart';

class CustomTextWidget extends StatelessWidget {
  final String data;
  final double fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  const CustomTextWidget({
    super.key,
    required this.fontSize,
    this.fontWeight,
    this.color,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: TextStyle(
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        color: color ?? AppThemes.textColor,
      ),
    );
  }
}
