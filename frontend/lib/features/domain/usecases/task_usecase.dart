import 'package:doan/features/domain/entities/task.dart';
import 'package:doan/features/domain/repositories/task_repository.dart';

abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

// UseCase: Tạo Task
class CreateTask implements UseCase<Task, Task> {
  final TaskRepository repository;

  CreateTask(this.repository);

  @override
  Future<Task> call(Task task) async {
    return await repository.createTask(task);
  }
}

// UseCase: Cập nhật Task
class UpdateTask implements UseCase<Task, Task> {
  final TaskRepository repository;

  UpdateTask(this.repository);

  @override
  Future<Task> call(Task task) async {
    return await repository.updateTask(task);
  }
}

// UseCase: Xóa Task
class DeleteTask implements UseCase<void, int> {
  final TaskRepository repository;

  DeleteTask(this.repository);

  @override
  Future<void> call(int taskId) async {
    return await repository.deleteTask(taskId);
  }
}

// UseCase: Lấy danh sách Task theo Project
class GetTasksByProject implements UseCase<List<Task>, int> {
  final TaskRepository repository;

  GetTasksByProject(this.repository);

  @override
  Future<List<Task>> call(int projectId) async {
    return await repository.getTasksByProject(projectId);
  }
}

// UseCase: Lấy Task theo ID
class GetTaskById implements UseCase<Task, int> {
  final TaskRepository repository;

  GetTaskById(this.repository);

  @override
  Future<Task> call(int taskId) async {
    return await repository.getTaskById(taskId);
  }
}

// UseCase: Lấy toàn bộ Task
class GetAllTasks implements UseCase<List<Task>, void> {
  final TaskRepository repository;

  GetAllTasks(this.repository);

  @override
  Future<List<Task>> call(void params) async {
    return await repository.getAllTasks();
  }
}