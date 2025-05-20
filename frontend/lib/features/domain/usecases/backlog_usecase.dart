import '../entities/sprint.dart';
import '../entities/issue.dart';
import '../repositories/backlog_repository.dart';

abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

// UseCase: Lấy danh sách Sprint
class GetSprints implements UseCase<List<Sprint>, int> {
  final BacklogRepository repository;

  GetSprints(this.repository);

  @override
  Future<List<Sprint>> call(int projectId) async {
    return await repository.getSprints(projectId);
  }
}

// UseCase: Lấy danh sách Issue
class GetIssues implements UseCase<List<Issue>, int> {
  final BacklogRepository repository;

  GetIssues(this.repository);

  @override
  Future<List<Issue>> call(int projectId) async {
    return await repository.getIssues(projectId);
  }
}

// UseCase: Tạo Sprint
class CreateSprint implements UseCase<void, Sprint> {
  final BacklogRepository repository;

  CreateSprint(this.repository);

  @override
  Future<void> call(Sprint sprint) async {
    return await repository.createSprint(sprint);
  }
}

// UseCase: Tạo Issue
class CreateIssue implements UseCase<void, Issue> {
  final BacklogRepository repository;

  CreateIssue(this.repository);

  @override
  Future<void> call(Issue issue) async {
    return await repository.createIssue(issue);
  }
}

// UseCase: Cập nhật Issue
class UpdateIssue implements UseCase<void, Issue> {
  final BacklogRepository repository;

  UpdateIssue(this.repository);

  @override
  Future<void> call(Issue issue) async {
    return await repository.updateIssue(issue);
  }
}

// UseCase: Cập nhật Sprint
class UpdateSprint implements UseCase<void, Sprint> {
  final BacklogRepository repository;

  UpdateSprint(this.repository);

  @override
  Future<void> call(Sprint sprint) async {
    return await repository.updateSprint(sprint);
  }
}

// UseCase: Xóa Sprint
class DeleteSprint implements UseCase<void, int> {
  final BacklogRepository repository;

  DeleteSprint(this.repository);

  @override
  Future<void> call(int sprintId) async {
    return await repository.deleteSprint(sprintId);
  }
}

// UseCase: Xóa Issue
class DeleteIssue implements UseCase<void, int> {
  final BacklogRepository repository;

  DeleteIssue(this.repository);

  @override
  Future<void> call(int issueId) async {
    return await repository.deleteIssue(issueId);
  }
}