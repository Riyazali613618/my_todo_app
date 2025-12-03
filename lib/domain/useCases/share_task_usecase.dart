import '../../data/repositories/task_repository.dart';

class ShareTaskUseCase {
  final TaskRepository repository;
  ShareTaskUseCase(this.repository);

  Future<void> call(String taskId, String email) =>
      repository.shareTask(taskId, email);
}
