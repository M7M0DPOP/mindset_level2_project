part of 'task_manage_cubit.dart';

@immutable
sealed class TaskManageState {}

final class TaskManageInitial extends TaskManageState {}

final class TaskManageLoading extends TaskManageState {}
final class TaskManageError extends TaskManageState {
  final String message;
  TaskManageError(this.message);
}
final class TaskManageSuccess extends TaskManageState {}
