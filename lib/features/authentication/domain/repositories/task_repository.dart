
abstract class TaskRepository {
  Stream<List<Map<String, dynamic>>> getTasks();
  Future<void> addTask(Map<String, dynamic> task);
  Future<void> deleteTask(String taskId);
  Future<void> updateTask(String taskId, Map<String, dynamic> updatedTask);
}
