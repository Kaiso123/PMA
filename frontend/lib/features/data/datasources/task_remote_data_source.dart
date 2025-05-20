import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:doan/features/data/models/task_model.dart';

class TaskRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'https://api.example.com/tasks'; 

  TaskRemoteDataSource({required this.client});

  // Tạo task mới
  Future<TaskModel> createTask(TaskModel task) async {
    final response = await client.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode == 200) {
      return TaskModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create task');
    }
  }

  // Cập nhật task
  Future<TaskModel> updateTask(TaskModel task) async {
    final response = await client.put(
      Uri.parse('$baseUrl/${task.taskId}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode == 200) {
      return TaskModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update task');
    }
  }

  // Xóa task
  Future<void> deleteTask(int taskId) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/$taskId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }

  // Lấy danh sách task theo projectId
  Future<List<TaskModel>> getTasksByProject(int projectId) async {
    final response = await client.get(
      Uri.parse('$baseUrl?projectId=$projectId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => TaskModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tasks by project');
    }
  }

  // Lấy task theo ID
  Future<TaskModel> getTaskById(int taskId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/$taskId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return TaskModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load task');
    }
  }

  // Lấy toàn bộ danh sách task
  Future<List<TaskModel>> getAllTasks() async {
    final response = await client.get(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => TaskModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load all tasks');
    }
  }
}