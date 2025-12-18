import '../../domain/repositories/task_repository.dart';
import '../datasources/task_remote_datasource.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl(this.remoteDataSource);

  @override
  Stream<List<Map<String, dynamic>>> getTasks() {
    return remoteDataSource.getTasks().map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => {
        ...doc.data() as Map<String, dynamic>,
        'id': doc.id,
      })
          .toList();
    });
  }

  @override
  Future<void> addTask(Map<String, dynamic> task) {
    return remoteDataSource.addTask(task);
  }

  @override
  Future<void> updateTask(String taskId, Map<String, dynamic> updates) {
    return remoteDataSource.updateTask(taskId, updates);
  }

  @override
  Future<void> deleteTask(String taskId) {
    return remoteDataSource.deleteTask(taskId);
  }
}