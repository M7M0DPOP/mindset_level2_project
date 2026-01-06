import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/get_task.dart';
import '../../domain/usecases/update_task.dart';
import '../../domain/usecases/delete_task.dart';

part 'task_manage_state.dart';


class TaskManageCubit extends Cubit<TaskManageState> {
  final GetTasks getTasks;
  final AddTask addTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  TaskManageCubit({
    required this.getTasks,
    required this.addTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super(TaskManageInitial());

  Stream<List<Map<String, dynamic>>> get tasksStream => getTasks();

  Future<void> addNewTask(Map<String, dynamic> task) async {
      emit( TaskManageLoading());
      await addTask(task);
      emit(TaskManageSuccess());
  }

  Future<void> toggleTaskComplete(String taskId, bool currentStatus) async {
    emit( TaskManageLoading());
    await updateTask(taskId, {'isComplete': !currentStatus});
    emit(TaskManageSuccess());
  }

  Future<void> updateTaskData(String taskId, Map<String, dynamic> updates) async {
    emit( TaskManageLoading());
    await updateTask(taskId, updates);
    emit(TaskManageSuccess());
  }

  Future<void> removeTask(String taskId) async {
    emit( TaskManageLoading());
    await deleteTask(taskId);
    emit(TaskManageSuccess());
  }
}