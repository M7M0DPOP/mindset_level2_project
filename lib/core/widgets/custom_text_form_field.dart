import 'package:flutter/material.dart';
import 'package:mindset_level2_project/core/app_themes.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  bool isObscure;
  final String hintText;
  final String? Function(String) validator;
  final void Function()? toggleObscure;
  final int? minLines;
  IconData? icon;
  CustomTextFormField({
    super.key,
    required this.controller,
    this.isObscure = false,
    required this.hintText,
    required this.validator,
    this.toggleObscure,
    this.icon,
    this.minLines = 1,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return widget.isObscure
        ? TextFormField(
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            style: TextStyle(color: Colors.white),
            obscureText: widget.isObscure,
            controller: widget.controller,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: widget.toggleObscure,
                color: Colors.white60,
                icon: Icon(widget.icon),
              ),

              hint: Text(
                widget.hintText,
                style: TextStyle(color: Colors.white60, fontSize: 18),
              ),
              fillColor: AppThemes.thireedColor,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (value) => widget.validator(value!),
          )
        : TextFormField(
            maxLines: 20,
            minLines: widget.minLines,
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            style: TextStyle(color: Colors.white),
            obscureText: widget.isObscure,
            controller: widget.controller,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: widget.toggleObscure,
                color: Colors.white60,
                icon: Icon(widget.icon),
              ),

              hint: Text(
                widget.hintText,
                style: TextStyle(color: Colors.white60, fontSize: 18),
              ),
              fillColor: AppThemes.thireedColor,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (value) => widget.validator(value!),
          );
  }
}
