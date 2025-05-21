import 'package:doan/features/core/api_client.dart';
import 'package:doan/features/data/models/invite_user_to_project_model.dart';
import 'package:doan/features/data/models/project_model.dart';
import 'package:doan/features/data/models/project_response_dto.dart';
import 'package:doan/features/data/models/userProject_model.dart';
import 'package:doan/features/data/models/task_model.dart';

class ProjectRemoteDataSource {
  final ApiClient apiClient;

  ProjectRemoteDataSource({required this.apiClient});

  // Tạo project mới
  Future<ProjectModel> createProject(ProjectModel project) async {
    final response = await apiClient.post('project/create', project.toJson());
    final projectResponse = ProjectResponseDto.fromJson(response);
    if (projectResponse.errorCode != 0) {
      throw Exception(projectResponse.errorMessage);
    }
     ProjectModel projectR = new ProjectModel(
        projectId: projectResponse.data
     );
    return projectR;
  }

  // Lấy danh sách project theo userId
  Future<List<ProjectModel>> getProjectsByUser(int userId) async {
    final response = await apiClient.get('project/user/$userId');
    final projectResponse = ProjectResponseDto.fromJson(response);
    if (projectResponse.errorCode != 0) {
      throw Exception(projectResponse.errorMessage);
    }
    return (projectResponse.data as List<dynamic>)
        .map((json) => ProjectModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // Gán task vào project
  Future<void> assignTaskToProject(int projectId, TaskModel task) async {
    final response =
        await apiClient.post('project/$projectId/tasks', task.toJson());
    final projectResponse = ProjectResponseDto.fromJson(response);
    if (projectResponse.errorCode != 0) {
      throw Exception(projectResponse.errorMessage);
    }
  }

  // Tạo UserProject
  Future<UserProjectModel> createUserProject(
      UserProjectModel userProject) async {
    final response =
        await apiClient.post('userProject/creat', userProject.toJson());
    final projectResponse = ProjectResponseDto.fromJson(response);
    if (projectResponse.errorCode != 0) {
      throw Exception(projectResponse.errorMessage);
    }
    return UserProjectModel(userProjectId: projectResponse.data as int);
  }

  // Lấy tất cả UserProject
  Future<List<UserProjectModel>> getAllUserProjects() async {
    final response = await apiClient.get('userProject/getall');
    final projectResponse = ProjectResponseDto.fromJson(response);
    if (projectResponse.errorCode != 0) {
      throw Exception(projectResponse.errorMessage);
    }
    return (projectResponse.data as List<dynamic>)
        .map((json) => UserProjectModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // Xóa UserProject
  Future<void> deleteUserProject(int userProjectId) async {
    final response =
        await apiClient.delete('userProject/delete/$userProjectId');
    final projectResponse = ProjectResponseDto.fromJson(response);
    if (projectResponse.errorCode != 0) {
      throw Exception(projectResponse.errorMessage);
    }
  }

  // Mời user vào project bằng mã mời
  Future<int> inviteUserToProject(InviteUserToProjectModel invite) async {
    final response =
        await apiClient.post('userProject/invite', invite.toJson());
    final projectResponse = ProjectResponseDto.fromJson(response);
    if (projectResponse.errorCode != 0) {
      throw Exception(projectResponse.errorMessage);
    }
    return projectResponse.data as int;
  }

  // Lấy danh sách user trong project
  Future<List<UserProjectModel>> getUserProjectByProjectId(
      int projectId) async {
    final response = await apiClient.get('userProject/$projectId/users');
    final projectResponse = ProjectResponseDto.fromJson(response);
    if (projectResponse.errorCode != 0) {
      throw Exception(projectResponse.errorMessage);
    }
    return (projectResponse.data as List<dynamic>)
        .map((json) => UserProjectModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
