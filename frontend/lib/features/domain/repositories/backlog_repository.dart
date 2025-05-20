import '../entities/sprint.dart';
import '../entities/issue.dart';

abstract class BacklogRepository {
  Future<List<Sprint>> getSprints(int projectId);
  Future<List<Issue>> getIssues(int projectId);
  Future<void> createSprint(Sprint sprint);
  Future<void> createIssue(Issue issue);
  Future<void> updateIssue(Issue issue);
  Future<void> updateSprint(Sprint sprint);
  Future<void> deleteSprint(int sprintId);
  Future<void> deleteIssue(int issueId);
}