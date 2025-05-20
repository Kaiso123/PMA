import 'dart:convert';
import 'package:doan/features/data/models/invite_user_to_project_model.dart';
import 'package:doan/features/data/models/project_model.dart';
import 'package:doan/features/data/models/userProject_model.dart';
import 'package:http/http.dart' as http;
import 'package:doan/features/data/models/task_model.dart';

class ProjectRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'http://192.168.170.200:7105/project';
  static const String baseUrl2 = 'http://192.168.170.200:7105/userProject'; // URL API

  ProjectRemoteDataSource({required this.client});

  // Tạo project mới
  Future<ProjectModel> createProject(ProjectModel project) async {
    final response = await client.post(
      Uri.parse("$baseUrl/create"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(project.toJson()),
    );
    if (response.statusCode == 200) {
      return ProjectModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create project');
    }
  }

  // Lấy danh sách project theo userId
  Future<List<ProjectModel>> getProjectsByUser(int userId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/user/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      final List<dynamic> jsonList = jsonMap['data'];
      return jsonList.map((json) => ProjectModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load projects by user');
    }
  }

  // Gán task vào project
  Future<void> assignTaskToProject(int projectId, TaskModel task) async {
    final response = await client.post(
      Uri.parse('$baseUrl/$projectId/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to assign task to project');
    }
  }

  // Tạo UserProject
  Future<UserProjectModel> createUserProject(UserProjectModel userProject) async {
    final response = await client.post(
      Uri.parse('$baseUrl2/creat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userProject.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      return UserProjectModel(userProjectId: jsonMap['data'] as int);
    } else {
      throw Exception('Failed to create user project: ${response.body}');
    }
  }

  // Lấy tất cả UserProject
  Future<List<UserProjectModel>> getAllUserProjects() async {
    final response = await client.get(
      Uri.parse('$baseUrl2/getall'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      final List<dynamic> jsonList = jsonMap['data'];
      return jsonList.map((json) => UserProjectModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load user projects: ${response.body}');
    }
  }

  // Xóa UserProject
  Future<void> deleteUserProject(int userProjectId) async {
    final response = await client.delete(
      Uri.parse('$baseUrl2/delete/$userProjectId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user project: ${response.body}');
    }
  }

  // Mời user vào project bằng mã mời
  Future<int> inviteUserToProject(InviteUserToProjectModel invite) async {
    final response = await client.post(
      Uri.parse('$baseUrl2/invite'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(invite.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      return jsonMap['data'] as int;
    } else {
      throw Exception('Failed to invite user to project: ${response.body}');
    }
  }

  // Lấy danh sách user trong project
  Future<List<UserProjectModel>> getUserProjectByProjectId(int projectId) async {
    final response = await client.get(
      Uri.parse('$baseUrl2/$projectId/users'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      final List<dynamic> jsonList = jsonMap['data'];
      return jsonList.map((json) => UserProjectModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load user projects by project ID: ${response.body}');
    }
  }
}
