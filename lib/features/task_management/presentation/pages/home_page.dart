import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mindset_level2_project/core/app_themes.dart';
import 'package:mindset_level2_project/core/widgets/custom_text_widget.dart';
import 'package:mindset_level2_project/features/task_management/presentation/cubit/task_manage_cubit.dart';
import 'package:mindset_level2_project/features/task_management/presentation/pages/task_details_page.dart';
import 'add_task_page.dart';
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [const TasksPage(), const ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.primaryColor,
      body: _pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTask()),
                );
              },
              backgroundColor: AppThemes.secondaryColor,
              child: Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: AppThemes.primaryColor,
        selectedItemColor: AppThemes.textColor,
        unselectedItemColor: AppThemes.lightGreen,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppThemes.primaryColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppThemes.primaryColor,
          centerTitle: true,
          title: CustomTextWidget(
            data: 'Taskly',
            color: AppThemes.textColor,
            fontSize: 25,
          ),
          elevation: 0,
          bottom: TabBar(
            dividerColor: Colors.transparent,
            indicatorColor: AppThemes.textColor,
            indicatorWeight: 3.h,
            labelColor: AppThemes.textColor,
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: AppThemes.lightGreen,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Completed'),
              Tab(text: 'Pending'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTasks(context, filter: 'all'),
            _buildTasks(context, filter: 'completed'),
            _buildTasks(context, filter: 'pending'),
          ],
        ),
      ),
    );
  }

  Widget _buildTasks(BuildContext context, {required String filter}) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: context.read<TaskManageCubit>().tasksStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: CustomTextWidget(
              data: 'Error: ${snapshot.error}',
              color: AppThemes.red,
              fontSize: 16,
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: CustomTextWidget(
              data: 'No Tasks',
              color: AppThemes.textColor,
              fontSize: 16,
            ),
          );
        }

        final tasks = snapshot.data!.where((task) {
          final isComplete = task['isComplete'] as bool? ?? false;
          if (filter == 'completed') return isComplete;
          if (filter == 'pending') return !isComplete;
          return true;
        }).toList();

        if (tasks.isEmpty) {
          return Center(
            child: CustomTextWidget(
              data: 'No ${filter == 'all' ? '' : filter} tasks',
              color: AppThemes.textColor,
              fontSize: 16,
            ),
          );
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Card(
              color: AppThemes.primaryColor,
              margin: EdgeInsets.all(8.h),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskDetailsPage(task: task),
                    ),
                  );
                },

                title: CustomTextWidget(
                  data: task['taskTitle'] ?? 'No Title',
                  color: AppThemes.textColor,
                  fontSize: 16,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task['description'] ?? 'No Description',
                      style: TextStyle(color: AppThemes.lightGreen),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    CustomTextWidget(
                      data: 'Priority: ${task['priority'] ?? 'Low'}',
                      color: _getPriorityColor(task['priority']),
                      fontSize: 12,
                    ),
                  ],
                ),
                trailing: InkWell(
                  onTap: () {
                    final taskId = task['id'] as String;
                    final isComplete = task['isComplete'] ?? false;
                    context.read<TaskManageCubit>().toggleTaskComplete(
                      taskId,
                      isComplete,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    child: Icon(
                      task['isComplete'] ?? false
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: task['isComplete'] ?? false
                          ? AppThemes.secondaryColor
                          : AppThemes.gray,
                      size: 28.sp,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color _getPriorityColor(String str) {
    Priority priority = str == "High"
        ? Priority.high
        : str == "Medium"
        ? Priority.medium
        : Priority.low;
    switch (priority) {
      case Priority.high:
        return AppThemes.red;
      case Priority.medium:
        return AppThemes.orange;
      case Priority.low:
        return AppThemes.secondaryColor;
    }
  }
}

enum Priority { high, medium, low }
