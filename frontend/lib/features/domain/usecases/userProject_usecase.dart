import 'package:doan/features/domain/entities/userProject.dart';
import 'package:doan/features/domain/repositories/project_repository.dart';

abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

// UseCase: Tạo UserProject
class CreateUserProject implements UseCase<UserProject, UserProject> {
  final ProjectRepository repository;

  CreateUserProject(this.repository);

  @override
  Future<UserProject> call(UserProject userProject) async {
    return await repository.createUserProject(userProject);
  }
}

// UseCase: Lấy tất cả UserProject
class GetAllUserProjects implements UseCase<List<UserProject>, void> {
  final ProjectRepository repository;

  GetAllUserProjects(this.repository);

  @override
  Future<List<UserProject>> call(void _) async {
    return await repository.getAllUserProjects();
  }
}

// UseCase: Xóa UserProject
class DeleteUserProject implements UseCase<void, int> {
  final ProjectRepository repository;

  DeleteUserProject(this.repository);

  @override
  Future<void> call(int userProjectId) async {
    return await repository.deleteUserProject(userProjectId);
  }
}

// UseCase: Mời user vào project
class InviteUserToProject implements UseCase<int, InviteUserParams> {
  final ProjectRepository repository;

  InviteUserToProject(this.repository);

  @override
  Future<int> call(InviteUserParams params) async {
    return await repository.inviteUserToProject(
      params.inviteCode,
      params.userId,
      params.isManager,
    );
  }
}

// Params cho InviteUserToProject
class InviteUserParams {
  final String inviteCode;
  final int userId;
  final bool isManager;

  InviteUserParams({
    required this.inviteCode,
    required this.userId,
    this.isManager = false,
  });
}

// UseCase: Lấy danh sách user trong project
class GetUserProjectByProjectId implements UseCase<List<UserProject>, int> {
  final ProjectRepository repository;

  GetUserProjectByProjectId(this.repository);

  @override
  Future<List<UserProject>> call(int projectId) async {
    return await repository.getUserProjectByProjectId(projectId);
  }
}