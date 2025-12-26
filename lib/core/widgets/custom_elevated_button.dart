import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindset_level2_project/core/app_themes.dart';

class CustomElevatedButton extends StatefulWidget {
  final void Function()? onPressed;
  final Color? backgroundColor;
  final Widget child;
  double width;
  double height;

  CustomElevatedButton({
    super.key,
    this.onPressed,
    this.backgroundColor,
    required this.child,
    this.height = 50,
    this.width = double.infinity,
  });

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.backgroundColor ?? AppThemes.secondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(500)),
        minimumSize: Size(widget.width.w, widget.height.h),
      ),
      child: widget.child,
    );
  }
}
