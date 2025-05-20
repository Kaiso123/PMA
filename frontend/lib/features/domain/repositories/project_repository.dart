import 'package:doan/features/domain/entities/project.dart';
import 'package:doan/features/domain/entities/task.dart';
import 'package:doan/features/domain/entities/userProject.dart';

abstract class ProjectRepository {
  Future<Project> createProject(Project project);
  Future<List<Project>> getProjectsByUser(int userId);
  Future<void> assignTaskToProject(int projectId, Task task);
  Future<UserProject> createUserProject(UserProject userProject);
  Future<List<UserProject>> getAllUserProjects();
  Future<void> deleteUserProject(int userProjectId);
  Future<int> inviteUserToProject(String inviteCode, int userId, bool isManager);
  Future<List<UserProject>> getUserProjectByProjectId(int projectId);
}