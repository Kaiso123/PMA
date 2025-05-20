import 'package:doan/features/domain/entities/project.dart';
import 'package:doan/features/domain/entities/task.dart';
import 'package:doan/features/domain/repositories/project_repository.dart';

abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

// UseCase: Tạo Project
class CreateProject implements UseCase<Project, Project> {
  final ProjectRepository repository;

  CreateProject(this.repository);

  @override
  Future<Project> call(Project project) async {
    return await repository.createProject(project);
  }
}

// UseCase: Lấy danh sách Project theo User
class GetProjectsByUser implements UseCase<List<Project>, int> {
  final ProjectRepository repository;

  GetProjectsByUser(this.repository);

  @override
  Future<List<Project>> call(int userId) async {
    return await repository.getProjectsByUser(userId);
  }
}

// UseCase: Gán Task vào Project
class AssignTaskToProject implements UseCase<void, AssignTaskParams> {
  final ProjectRepository repository;

  AssignTaskToProject(this.repository);

  @override
  Future<void> call(AssignTaskParams params) async {
    return await repository.assignTaskToProject(params.projectId, params.task);
  }
}

// Params cho AssignTaskToProject
class AssignTaskParams {
  final int projectId;
  final Task task;

  AssignTaskParams({required this.projectId, required this.task});
}