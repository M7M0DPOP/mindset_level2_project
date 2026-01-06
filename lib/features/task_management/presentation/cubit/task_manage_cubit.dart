import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'task_manage_state.dart';

class TaskManageCubit extends Cubit<TaskManageState> {
  TaskManageCubit() : super(TaskManageInitial());
}
