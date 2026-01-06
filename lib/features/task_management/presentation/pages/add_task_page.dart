import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindset_level2_project/core/widgets/custom_text_form_field.dart';
import 'package:mindset_level2_project/core/widgets/custom_text_widget.dart';
import 'package:mindset_level2_project/features/task_management/presentation/cubit/task_manage_cubit.dart';
import 'package:mindset_level2_project/features/task_management/presentation/widgets/priority_button.dart';
import '../../../../core/app_themes.dart';

class AddTask extends StatefulWidget {
  final Map<String, dynamic>? task;

  const AddTask({super.key, this.task});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late String selectedPriority;
  DateTime? selectedDate;
  bool get isEditMode => widget.task != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      titleController = TextEditingController(
        text: widget.task!['taskTitle'] ?? '',
      );
      descriptionController = TextEditingController(
        text: widget.task!['description'] ?? '',
      );
      selectedPriority = widget.task!['priority'] ?? 'Low';

      final dueDate = widget.task!['dueDate'];
      if (dueDate != null) {
        try {
          selectedDate = (dueDate is DateTime)
              ? dueDate
              : (dueDate as dynamic).toDate();
        } catch (e) {
          selectedDate = DateTime.now();
        }
      }
    } else {
      titleController = TextEditingController();
      descriptionController = TextEditingController();
      selectedPriority = 'Low';
      selectedDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.primaryColor,
      appBar: AppBar(
        backgroundColor: AppThemes.primaryColor,
        centerTitle: true,
        title: Text(
          isEditMode ? 'Edit Task' : 'Add Task',
          style: TextStyle(color: AppThemes.textColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: AppThemes.textColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextWidget(
              data: "Task Title",
              color: AppThemes.textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 20.h),
            CustomTextFormField(
              controller: titleController,
              hintText: "Task Title",
              validator: (value) {
                if (value.isEmpty) {
                  return 'Title is required';
                }
                return null;
              },
            ),
            SizedBox(height: 10.h),
            CustomTextWidget(
              data: "Description",
              color: AppThemes.textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 20.h),
            CustomTextFormField(
              controller: descriptionController,
              hintText: "Description",
              minLines: 4,
              maxLines: 6,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Description is required';
                }
                return null;
              },
            ),
            SizedBox(height: 10.h),
            CustomTextWidget(
              data: "Due Date",
              color: AppThemes.textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                  ),
                  lastDate: DateTime(2030),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.dark().copyWith(
                        colorScheme: ColorScheme.dark(
                          primary: AppThemes.secondaryColor,
                          onPrimary: AppThemes.textColor,
                          surface: AppThemes.primaryColor,
                          onSurface: AppThemes.textColor,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppThemes.thireedColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppThemes.secondaryColor.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                      data: selectedDate != null
                          ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                          : 'Select Date',
                      color: AppThemes.textColor,
                      fontSize: 16,
                    ),
                    Icon(Icons.calendar_today, color: AppThemes.secondaryColor),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20.h),

            CustomTextWidget(
              data: "Priority",
              color: AppThemes.textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                PriorityButton(
                  priorityLabel: 'Low',
                  isSelected: selectedPriority == 'Low',
                  onTap: () => setState(() => selectedPriority = 'Low'),
                ),
                PriorityButton(
                  priorityLabel: 'Medium',
                  isSelected: selectedPriority == 'Medium',
                  onTap: () => setState(() => selectedPriority = 'Medium'),
                ),
                PriorityButton(
                  priorityLabel: 'High',
                  isSelected: selectedPriority == 'High',
                  onTap: () => setState(() => selectedPriority = 'High'),
                ),
              ],
            ),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemes.thireedColor,
                      foregroundColor: AppThemes.textColor,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: CustomTextWidget(data: 'Cancel', fontSize: 16),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemes.secondaryColor,
                      foregroundColor: AppThemes.textColor,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: () async {
                      if (titleController.text.isEmpty ||
                          descriptionController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please fill all fields'),
                            backgroundColor: AppThemes.red,
                          ),
                        );
                        return;
                      }
                      final taskData = {
                        'taskTitle': titleController.text,
                        'description': descriptionController.text,
                        'priority': selectedPriority,
                        'dueDate': selectedDate ?? DateTime.now(),
                      };
                      if (isEditMode) {
                        final taskId = widget.task!['id'] as String;
                        await context.read<TaskManageCubit>().updateTaskData(
                          taskId,
                          taskData,
                        );
                        if (context.mounted) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Task updated successfully '),
                              backgroundColor: AppThemes.secondaryColor,
                            ),
                          );
                        }
                      } else {
                        taskData['isComplete'] = false;
                        await context.read<TaskManageCubit>().addNewTask(
                          taskData,
                        );
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Task added successfully '),
                              backgroundColor: AppThemes.secondaryColor,
                            ),
                          );
                        }
                      }
                    },
                    child: CustomTextWidget(
                      data: isEditMode ? 'Save Changes' : 'Save',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
