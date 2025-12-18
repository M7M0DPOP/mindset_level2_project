import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/app_themes.dart';
import '../cubit/task_cubit.dart';
import 'add_task_page.dart' as add_task_page;

class TaskDetailsPage extends StatelessWidget {
  final Map<String, dynamic> task;

  const TaskDetailsPage({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final isComplete = task['isComplete'] ?? false;
    final priority = task['priority'] ?? 'Low';
    final dueDate = task['dueDate'];

    String formattedDate = 'No date';
    if (dueDate != null) {
      try {
        final date = (dueDate is DateTime)
            ? dueDate
            : (dueDate as dynamic).toDate();
        formattedDate = DateFormat('MMM dd, yyyy').format(date);
      } catch (e) {
        formattedDate = 'Invalid date';
      }
    }

    return Scaffold(
      backgroundColor: AppThemes.primaryColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF121714),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppThemes.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Task Details',
          style: TextStyle(color: AppThemes.textColor, fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task['taskTitle'] ?? 'No Title',
              style: TextStyle(
                color: AppThemes.textColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  isComplete ? 'Completed' : 'Pending',
                  style: TextStyle(
                    color: isComplete ? Colors.green : Colors.orange,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Icon(
                  isComplete ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isComplete ? AppThemes.secondaryColor : AppThemes.gray ,
                  size: 28,
                ),
              ],
            ),
            const SizedBox(height: 30),

            Text(
              task['description'] ?? 'No Description',
              style: TextStyle(
                color: AppThemes.lightGreen,
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Due Date',
                  style: TextStyle(
                    color: AppThemes.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  formattedDate,
                  style: TextStyle(
                    color: AppThemes.lightGreen,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Priority',
                  style: TextStyle(
                    color: AppThemes.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getPriorityColor(priority),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      priority,
                      style: TextStyle(
                        color: _getPriorityColor(priority),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Row(
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => add_task_page.AddTask(task: task),
                        ),
                      );
                    },
                    child: const Text(
                      'Edit',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
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
                    onPressed: () {
                      _showDeleteConfirmation(context);
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return AppThemes.red;
      case 'Medium':
        return AppThemes.orange;
      case 'Low':
        return AppThemes.secondaryColor;
      default:
        return AppThemes.gray;
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF121714),
          title: Text(
            'Delete Task',
            style: TextStyle(color: AppThemes.textColor),
          ),
          content: Text(
            'Are you sure you want to delete this task?',
            style: TextStyle(color: AppThemes.lightGreen,),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancel', style: TextStyle(color: AppThemes.gray,)),
            ),
            TextButton(
              onPressed: () async {
                final taskId = task['id'] as String;
                await context.read<TaskCubit>().removeTask(taskId);
                Navigator.pop(dialogContext); // Close dialog
                Navigator.pop(context); // Go back to home
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Task deleted successfully'),
                    backgroundColor: AppThemes.thireedColor,
                  ),
                );
              },
              child: Text('Delete', style: TextStyle(color: AppThemes.red)),
            ),
          ],
        );
      },
    );
  }
}