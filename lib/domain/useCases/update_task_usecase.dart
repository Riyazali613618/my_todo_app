import 'package:my_todo_app/data/models/todo_task_model.dart';
import '../../data/repositories/task_repository.dart';

class UpdateTaskUseCase {
  final TaskRepository repository;
  UpdateTaskUseCase(this.repository);

  Future<void> call(TodoTaskModel task) => repository.updateTask(task);
}
