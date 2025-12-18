import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mindset_level2_project/core/app_themes.dart';
import 'package:mindset_level2_project/features/authentication/presentation/pages/task%20_details_page.dart';

import '../cubit/task_cubit.dart';
import 'add_task_page.dart' as add_task_page;
import 'profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const TasksPage(),
    const ProfilePage(),
  ];

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
            MaterialPageRoute(builder: (context) => add_task_page.AddTask()),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
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
          title: Text(
            'Taskly',
            style: TextStyle(color: AppThemes.textColor, fontSize: 25),
          ),
          elevation: 0,
          bottom: TabBar(
            dividerColor: Colors.transparent,
            indicatorColor: AppThemes.textColor,
            indicatorWeight: 3,
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
      stream: context.read<TaskCubit>().tasksStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(color: AppThemes.red),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No Tasks',
              style: TextStyle(color: AppThemes.textColor),
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
            child: Text(
              'No ${filter == 'all' ? '' : filter} tasks',
              style: TextStyle(color: AppThemes.textColor),
            ),
          );
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Card(
              color: AppThemes.primaryColor,
              margin: const EdgeInsets.all(8),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskDetailsPage(task: task),
                    ),
                  );
                },


                title: Text(
                  task['taskTitle'] ?? 'No Title',
                  style:  TextStyle(color: AppThemes.textColor),
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
                    const SizedBox(height: 4),
                    Text(
                      'Priority: ${task['priority'] ?? 'Low'}',
                      style: TextStyle(
                        color: _getPriorityColor(task['priority']),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                trailing: InkWell(
                  onTap: () {
                    final taskId = task['id'] as String;
                    final isComplete = task['isComplete'] ?? false;
                    context.read<TaskCubit>().toggleTaskComplete(taskId, isComplete);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      task['isComplete'] ?? false
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: task['isComplete'] ?? false
                          ? AppThemes.secondaryColor
                          : AppThemes.gray,
                      size: 28,
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

  Color _getPriorityColor(String? priority) {
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
}