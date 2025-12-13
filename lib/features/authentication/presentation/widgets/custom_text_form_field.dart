import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  bool isObscure;
  final String hintText;
  final String? Function(String) validator;
  final void Function()? toggleObscure;
  IconData? icon;
  CustomTextFormField({
    super.key,
    required this.controller,
    this.isObscure = false,
    required this.hintText,
    required this.validator,
    this.toggleObscure,
    this.icon,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
        fillColor: const Color.fromARGB(255, 28, 35, 51),
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) => widget.validator(value!),
    );
  }
}
