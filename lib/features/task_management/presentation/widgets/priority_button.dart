import 'package:flutter/material.dart';
import 'package:mindset_level2_project/core/app_themes.dart';
import 'package:mindset_level2_project/core/widgets/custom_text_widget.dart';

class PriorityButton extends StatelessWidget {
  final String priorityLabel;
  final bool isSelected;
  final VoidCallback onTap;

  const PriorityButton({
    super.key,
    required this.priorityLabel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? AppThemes.secondaryColor
            : AppThemes.thireedColor,
        foregroundColor: AppThemes.textColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      onPressed: onTap,
      child: CustomTextWidget(data: priorityLabel, fontSize: 16),
    );
  }
}
