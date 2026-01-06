import '../repositories/task_repository.dart';

class UpdateTask {
  final TaskRepository repository;

  UpdateTask(this.repository);

  Future<void> call(String taskId, Map<String, dynamic> updates) {
    return repository.updateTask(taskId, updates);
  }
}