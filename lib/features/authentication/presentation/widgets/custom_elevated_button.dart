import 'package:flutter/material.dart';

class CustomElevatedButton extends StatefulWidget {
  final void Function()? onPressed;
  final Color backgroundColor;
  final Widget child;
  const CustomElevatedButton({
    super.key,
    this.onPressed,
    required this.backgroundColor,
    required this.child,
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
        backgroundColor: widget.backgroundColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white24, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: Size(double.infinity, 50),
      ),
      child: widget.child,
    );
  }
}
