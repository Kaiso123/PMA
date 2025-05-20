import 'package:doan/features/domain/entities/task.dart';

abstract class TaskRepository {
  Future<Task> createTask(Task task);
  Future<Task> updateTask(Task task);
  Future<void> deleteTask(int taskId);
  Future<List<Task>> getTasksByProject(int projectId);
  Future<Task> getTaskById(int taskId);
  Future<List<Task>> getAllTasks();
}