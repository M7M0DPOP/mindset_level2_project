import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindset_level2_project/core/widgets/custom_text_form_field.dart';

import '../../../../core/app_themes.dart';
import '../cubit/task_cubit.dart';

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
      titleController = TextEditingController(text: widget.task!['taskTitle'] ?? '');
      descriptionController = TextEditingController(text: widget.task!['description'] ?? '');
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
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Task Title",
              style: TextStyle(
                color: AppThemes.textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 10),
            Text(
              "Description",
              style: TextStyle(
                color: AppThemes.textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 10),
            Text(
              "Due Date",
              style: TextStyle(
                color: AppThemes.textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
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
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppThemes.thireedColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppThemes.secondaryColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate != null
                          ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                          : 'Select Date',
                      style: TextStyle(color: AppThemes.textColor, fontSize: 16),
                    ),
                    Icon(Icons.calendar_today, color: AppThemes.secondaryColor),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Priority",
              style: TextStyle(
                color: AppThemes.textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _priorityButton('Low'),
                _priorityButton('Medium'),
                _priorityButton('High'),
              ],
            ),

            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemes.thireedColor,
                      foregroundColor: AppThemes.textColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel', style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemes.secondaryColor,
                      foregroundColor: AppThemes.textColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
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
                        await context.read<TaskCubit>().updateTaskData(taskId, taskData);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                            content: Text('Task updated successfully '),
                            backgroundColor: AppThemes.secondaryColor,
                          ),
                        );
                      } else {
                        taskData['isComplete'] = false;
                        await context.read<TaskCubit>().addNewTask(taskData);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Task added successfully '),
                            backgroundColor: AppThemes.secondaryColor,
                          ),
                        );
                      }
                    },
                    child: Text(
                      isEditMode ? 'Save Changes' : 'Save',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  Widget _priorityButton(String priority) {
    final bool isSelected = selectedPriority == priority;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
        isSelected ? AppThemes.secondaryColor : AppThemes.thireedColor,
        foregroundColor: AppThemes.textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      onPressed: () {
        setState(() {
          selectedPriority = priority;
        });
      },
      child: Text(priority),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}