
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mindset_level2_project/features/task_management/data/datasources/task_remote_datasource.dart';
import 'package:mindset_level2_project/features/task_management/data/repositories/task_repository_impl.dart';
import 'package:mindset_level2_project/features/task_management/domain/repositories/task_repository.dart';
import 'package:mindset_level2_project/features/task_management/domain/usecases/add_task.dart';
import 'package:mindset_level2_project/features/task_management/domain/usecases/delete_task.dart';
import 'package:mindset_level2_project/features/task_management/domain/usecases/get_task.dart';
import 'package:mindset_level2_project/features/task_management/domain/usecases/update_task.dart';
import 'package:mindset_level2_project/features/task_management/presentation/cubit/task_cubit.dart';


class InjectionContainer {
  static final InjectionContainer _instance = InjectionContainer._internal();
  factory InjectionContainer() => _instance;
  InjectionContainer._internal();

  late TaskCubit taskCubit;

  Future<void> init() async {
    final firestore = FirebaseFirestore.instance;
    final TaskRemoteDataSource dataSource = TaskRemoteDataSourceImpl(firestore);
    final TaskRepository repository = TaskRepositoryImpl(dataSource);
    final GetTasks getTasks = GetTasks(repository);
    final AddTask addTask = AddTask(repository);
    final UpdateTask updateTask = UpdateTask(repository);
    final DeleteTask deleteTask = DeleteTask(repository);

    taskCubit = TaskCubit(
      getTasks: getTasks,
      addTask: addTask,
      updateTask: updateTask,
      deleteTask: deleteTask,
    );
  }

  TaskCubit getTaskCubit() => taskCubit;
}

final sl = InjectionContainer();