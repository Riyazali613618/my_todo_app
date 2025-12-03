
import 'package:my_todo_app/data/models/todo_task_model.dart';

abstract class TaskRepository {
  Stream<List<TodoTaskModel>> watchTasksForUser(String userEmail);
  Future<void> addTask(TodoTaskModel task);
  Future<void> updateTask(TodoTaskModel task);
  Future<void> toggleComplete(String taskId, bool value);
  Future<void> shareTask(String taskId, String emailToShare);
}
