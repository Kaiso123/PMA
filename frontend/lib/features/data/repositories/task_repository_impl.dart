import 'package:doan/features/domain/entities/task.dart';
import 'package:doan/features/domain/repositories/task_repository.dart';
import 'package:doan/features/data/datasources/task_remote_data_source.dart';
import 'package:doan/features/data/models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Task> createTask(Task task) async {
    try {
      final taskModel = TaskModel(
        taskId: task.taskId,
        title: task.title,
        description: task.description,
        startDate: task.startDate,
        deadline: task.deadline,
        priority: task.priority,
        status: task.status,
        projectId: task.projectId,
        assignedUserIds: task.assignedUserIds,
      );
      final createdTask = await remoteDataSource.createTask(taskModel);
      return createdTask.toEntity();
    } catch (e) {
      throw Exception('Error creating task: $e');
    }
  }

  @override
  Future<Task> updateTask(Task task) async {
    try {
      final taskModel = TaskModel(
        taskId: task.taskId,
        title: task.title,
        description: task.description,
        startDate: task.startDate,
        deadline: task.deadline,
        priority: task.priority,
        status: task.status,
        projectId: task.projectId,
        assignedUserIds: task.assignedUserIds,
      );
      final updatedTask = await remoteDataSource.updateTask(taskModel);
      return updatedTask.toEntity();
    } catch (e) {
      throw Exception('Error updating task: $e');
    }
  }

  @override
  Future<void> deleteTask(int taskId) async {
    try {
      await remoteDataSource.deleteTask(taskId);
    } catch (e) {
      throw Exception('Error deleting task: $e');
    }
  }

  @override
  Future<List<Task>> getTasksByProject(int projectId) async {
    try {
      final taskModels = await remoteDataSource.getTasksByProject(projectId);
      return taskModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error fetching tasks by project: $e');
    }
  }

  @override
  Future<Task> getTaskById(int taskId) async {
    try {
      final taskModel = await remoteDataSource.getTaskById(taskId);
      return taskModel.toEntity();
    } catch (e) {
      throw Exception('Error fetching task by ID: $e');
    }
  }

  @override
  Future<List<Task>> getAllTasks() async {
    try {
      final taskModels = await remoteDataSource.getAllTasks();
      return taskModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error fetching all tasks: $e');
    }
  }
}