import 'package:doan/features/data/models/invite_user_to_project_model.dart';
import 'package:doan/features/data/models/project_model.dart';
import 'package:doan/features/data/models/userProject_model.dart';
import 'package:doan/features/domain/entities/project.dart';
import 'package:doan/features/domain/entities/task.dart';
import 'package:doan/features/domain/entities/userProject.dart';
import 'package:doan/features/domain/repositories/project_repository.dart';
import 'package:doan/features/data/datasources/project_remote_data_source.dart';
import 'package:doan/features/data/models/task_model.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource remoteDataSource;

  ProjectRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Project> createProject(Project project) async {
    try {
      final projectModel = ProjectModel(
        projectId: project.projectId,
        ManagerId: project.managerId,
        name: project.name,
        description: project.description,
        startDate: project.startDate,
        endDate: project.endDate,
        memberIds: project.memberIds,
        status: project.status,
        budget: project.budget,
        progress: project.progress,
      );
      final createdProject = await remoteDataSource.createProject(projectModel);
      return createdProject.toEntity();
    } catch (e) {
      throw Exception('Error creating project: $e');
    }
  }

  @override
  Future<List<Project>> getProjectsByUser(int userId) async {
    try {
      final projectModels = await remoteDataSource.getProjectsByUser(userId);
      return projectModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error fetching projects by user: $e');
    }
  }

  @override
  Future<void> assignTaskToProject(int projectId, Task task) async {
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
      await remoteDataSource.assignTaskToProject(projectId, taskModel);
    } catch (e) {
      throw Exception('Error assigning task to project: $e');
    }
  }

   @override
  Future<UserProject> createUserProject(UserProject userProject) async {
    try {
      final userProjectModel = UserProjectModel(
        userId: userProject.userId,
        projectId: userProject.projectId,
        isManager: userProject.isManager,
      );
      final createdUserProject =
          await remoteDataSource.createUserProject(userProjectModel);
      return createdUserProject.toEntity();
    } catch (e) {
      throw Exception('Error creating user project: $e');
    }
  }

  @override
  Future<List<UserProject>> getAllUserProjects() async {
    try {
      final userProjectModels = await remoteDataSource.getAllUserProjects();
      return userProjectModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error fetching all user projects: $e');
    }
  }

  @override
  Future<void> deleteUserProject(int userProjectId) async {
    try {
      await remoteDataSource.deleteUserProject(userProjectId);
    } catch (e) {
      throw Exception('Error deleting user project: $e');
    }
  }

  @override
  Future<int> inviteUserToProject(String inviteCode, int userId, bool isManager) async {
    try {
      final inviteModel = InviteUserToProjectModel(
        inviteCode: inviteCode,
        userId: userId,
        isManager: isManager,
      );
      return await remoteDataSource.inviteUserToProject(inviteModel);
    } catch (e) {
      throw Exception('Error inviting user to project: $e');
    }
  }

  @override
  Future<List<UserProject>> getUserProjectByProjectId(int projectId) async {
    try {
      final userProjectModels =
          await remoteDataSource.getUserProjectByProjectId(projectId);
      return userProjectModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error fetching user projects by project ID: $e');
    }
  }
}