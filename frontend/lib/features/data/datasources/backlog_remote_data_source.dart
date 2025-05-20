import 'package:doan/features/core/api_client.dart';
import '../models/project_response_dto.dart';
import '../models/sprint_model.dart';
import '../models/issue_model.dart';

class BacklogRemoteDataSource {
  final ApiClient apiClient;

  BacklogRemoteDataSource({required this.apiClient});

  Future<List<SprintModel>> getSprints(int projectId) async {
    final response = await apiClient.get('sprint/project/$projectId');
    final projectResponse = ProjectResponseDto.fromJson(response);
    if (projectResponse.errorCode != 0) {
      throw Exception(projectResponse.errorMessage);
    }
    return (projectResponse.data as List<dynamic>)
        .map((json) => SprintModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<IssueModel>> getIssues(int projectId) async {
    final response = await apiClient.get('issue/project/$projectId');
    final projectResponse = ProjectResponseDto.fromJson(response);
    if (projectResponse.errorCode != 0) {
      throw Exception(projectResponse.errorMessage);
    }
    return (projectResponse.data as List<dynamic>)
        .map((json) => IssueModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> createSprint(SprintModel sprint) async {
    final response = await apiClient.post('sprint/create', {
      'projectId': sprint.projectId,
      'name': sprint.name,
      'description': sprint.description,
      'created': sprint.created.toIso8601String(),
      'endTime': sprint.endTime?.toIso8601String(),
      'status': sprint.status,
      'priority': sprint.priority,
    });
    final projectResponse = ProjectResponseDto.fromJson(response);
    if (projectResponse.errorCode != 0) {
      throw Exception(projectResponse.errorMessage);
    }
  }

  Future<void> createIssue(IssueModel issue) async {
    final response = await apiClient.post('issue/create', {
      'projectId': issue.projectId,
      'sprintId': issue.sprintId,
      'title': issue.title,
      'description': issue.description,
      'status': issue.status,
      'priority': issue.priority,
      'assigneeId': issue.assigneeId,
      'created': issue.created.toIso8601String(),
      'endTime': issue.endTime?.toIso8601String(),
    });
    final projectResponse = ProjectResponseDto.fromJson(response);
    if (projectResponse.errorCode != 0) {
      throw Exception(projectResponse.errorMessage);
    }
  }

  Future<void> updateIssue(IssueModel issue) async {
    final response = await apiClient.put('issue/${issue.id}', issue.toJson());
    final projectResponse = ProjectResponseDto.fromJson(response);
    if (projectResponse.errorCode != 0) {
      throw Exception(projectResponse.errorMessage);
    }
  }

  Future<void> updateSprint(SprintModel sprint) async {
    final response = await apiClient.put('sprint/${sprint.id}', {
      'projectId': sprint.projectId,
      'name': sprint.name,
      'description': sprint.description,
      'created': sprint.created.toIso8601String(),
      'endTime': sprint.endTime?.toIso8601String(),
      'status': sprint.status,
      'priority': sprint.priority,
    });
    final projectResponse = ProjectResponseDto.fromJson(response);
    if (projectResponse.errorCode != 0) {
      throw Exception(projectResponse.errorMessage);
    }
  }

  Future<void> deleteSprint(int sprintId) async {
    final response = await apiClient.delete('sprint/delete/$sprintId');
    final projectResponse = ProjectResponseDto.fromJson(response);
    if (projectResponse.errorCode != 0) {
      throw Exception(projectResponse.errorMessage);
    }
  }

  Future<void> deleteIssue(int issueId) async {
    final response = await apiClient.delete('issue/$issueId');
    final projectResponse = ProjectResponseDto.fromJson(response);
    if (projectResponse.errorCode != 0) {
      throw Exception(projectResponse.errorMessage);
    }
  }
}
