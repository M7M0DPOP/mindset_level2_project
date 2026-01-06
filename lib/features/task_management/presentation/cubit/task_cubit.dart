import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/get_task.dart';
import '../../domain/usecases/update_task.dart';
import '../../domain/usecases/delete_task.dart';

class TaskCubit extends Cubit<void> {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  TaskCubit({
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super(null);

  Stream<List<Map<String, dynamic>>> get tasksStream => getTasks();

  Future<void> addNewTask(Map<String, dynamic> task) async {
    await addTask(task);
  }

  Future<void> toggleTaskComplete(String taskId, bool currentStatus) async {
    await updateTask(taskId, {'isComplete': !currentStatus});
  }

  Future<void> updateTaskData(String taskId, Map<String, dynamic> updates) async {
    await updateTask(taskId, updates);
  }

  Future<void> removeTask(String taskId) async {
    await deleteTask(taskId);
  }
}