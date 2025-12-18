import 'package:cloud_firestore/cloud_firestore.dart';

abstract class TaskRemoteDataSource {
  Stream<QuerySnapshot> getTasks();
  Future<void> addTask(Map<String, dynamic> task);
  Future<void> updateTask(String taskId, Map<String, dynamic> updates);
  Future<void> deleteTask(String taskId);
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final FirebaseFirestore firestore;

  TaskRemoteDataSourceImpl(this.firestore);

  @override
  Stream<QuerySnapshot> getTasks() {
    return firestore
        .collection('tasks')
        .orderBy('dueDate')
        .snapshots();
  }

  @override
  Future<void> addTask(Map<String, dynamic> task) {
    return firestore.collection('tasks').add(task);
  }

  @override
  Future<void> updateTask(String taskId, Map<String, dynamic> updates) {
    return firestore.collection('tasks').doc(taskId).update(updates);
  }

  @override
  Future<void> deleteTask(String taskId) {
    return firestore.collection('tasks').doc(taskId).delete();
  }
}