import '../repositories/task_repository.dart';

class AddTask {
  final TaskRepository repository;

  AddTask(this.repository);

  Future<void> call(Map<String, dynamic> task) {
    return repository.addTask(task);
  }
}
