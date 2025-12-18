import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindset_level2_project/core/app_themes.dart';

class DatePickerWidget extends StatefulWidget {
  const DatePickerWidget({super.key});

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime? selectedDate;
  final TextEditingController _controller = TextEditingController();

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(color: AppThemes.textColor),
      controller: _controller,
      readOnly: true,
      onTap: () => _pickDate(context),
      decoration: InputDecoration(
        hintText: 'Select Date',
        hintStyle: TextStyle(color: AppThemes.textColor),
        prefixStyle: TextStyle(color: AppThemes.textColor),
        suffixIcon: Icon(Icons.calendar_today, color: AppThemes.secondaryColor),
        filled: true,
        fillColor: AppThemes.thireedColor,
        border: OutlineInputBorder(

          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppThemes.thireedColor,
            width: 2,
          ),
        ),
      ),
    );
  }
}
