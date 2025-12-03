import 'package:my_todo_app/data/models/todo_task_model.dart';

import '../../data/repositories/task_repository.dart';

class AddTaskUseCase {
  final TaskRepository repository;
  AddTaskUseCase(this.repository);

  Future<void> call(TodoTaskModel task) => repository.addTask(task);
}
