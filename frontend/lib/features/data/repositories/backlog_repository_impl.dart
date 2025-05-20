import 'package:doan/features/data/datasources/backlog_remote_data_source.dart';
import '../../domain/entities/sprint.dart';
import '../../domain/entities/issue.dart';
import '../../domain/repositories/backlog_repository.dart';
import '../models/sprint_model.dart';
import '../models/issue_model.dart';

class BacklogRepositoryImpl implements BacklogRepository {
  final BacklogRemoteDataSource remoteDataSource;

  BacklogRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Sprint>> getSprints(int projectId) async {
    final sprintModels = await remoteDataSource.getSprints(projectId);
    return sprintModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<Issue>> getIssues(int projectId) async {
    final issueModels = await remoteDataSource.getIssues(projectId);
    return issueModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> createSprint(Sprint sprint) async {
    await remoteDataSource.createSprint(SprintModel(
      id: sprint.id,
      projectId: sprint.projectId,
      name: sprint.name,
      description: sprint.description,
      created: sprint.created,
      endTime: sprint.endTime,
      status: sprint.status,
      priority: sprint.priority,
      issues: sprint.issues
          .map((issue) => IssueModel(
                id: issue.issueId,
                projectId: issue.projectId,
                title: issue.title,
                description: issue.description,
                status: issue.status,
                priority: issue.priority,
                assigneeId: issue.assigneeId,
                created: issue.created,
                endTime: issue.endTime,
                sprintId: issue.sprintId,
              ))
          .toList(),
    ));
  }

  @override
  Future<void> createIssue(Issue issue) async {
    await remoteDataSource.createIssue(IssueModel(
      id: issue.issueId,
      title: issue.title,
      description: issue.description,
      status: issue.status,
      priority: issue.priority,
      assigneeId: issue.assigneeId,
      created: issue.created,
      endTime: issue.endTime,
      projectId: issue.projectId,
      sprintId: issue.sprintId,
    ));
  }

  @override
  Future<void> updateIssue(Issue issue) async {
    await remoteDataSource.updateIssue(IssueModel(
      id: issue.issueId,
      title: issue.title,
      description: issue.description,
      status: issue.status,
      priority: issue.priority,
      assigneeId: issue.assigneeId,
      created: issue.created,
      endTime: issue.endTime,
      projectId: issue.projectId,
      sprintId: issue.sprintId,
    ));
  }

  @override
  Future<void> updateSprint(Sprint sprint) async {
    await remoteDataSource.updateSprint(SprintModel(
      id: sprint.id,
      projectId: sprint.projectId,
      name: sprint.name,
      description: sprint.description,
      created: sprint.created,
      endTime: sprint.endTime,
      status: sprint.status,
      priority: sprint.priority,
      issues: sprint.issues
          .map((issue) => IssueModel(
                id: issue.issueId,
                projectId: issue.projectId,
                title: issue.title,
                description: issue.description,
                status: issue.status,
                priority: issue.priority,
                assigneeId: issue.assigneeId,
                created: issue.created,
                endTime: issue.endTime,
                sprintId: issue.sprintId,
              ))
          .toList(),
    ));
  }

  @override
  Future<void> deleteSprint(int sprintId) async {
    await remoteDataSource.deleteSprint(sprintId);
  }

  @override
  Future<void> deleteIssue(int issueId) async {
    await remoteDataSource.deleteIssue(issueId);
  }
}
