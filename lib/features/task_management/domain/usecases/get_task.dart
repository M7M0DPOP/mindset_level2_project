
import '../repositories/task_repository.dart';

class GetTasks {
  final TaskRepository repository;

  GetTasks(this.repository);

  Stream<List<Map<String, dynamic>>> call() {
    return repository.getTasks();
  }
}
