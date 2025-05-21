import 'package:doan/features/domain/usecases/backlog_usecase.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/sprint.dart';
import '../../domain/entities/issue.dart';

class BacklogProvider with ChangeNotifier {
  final GetSprints getSprintsUseCase;
  final GetIssues getIssuesUseCase;
  final CreateSprint createSprintUseCase;
  final CreateIssue createIssueUseCase;
  final UpdateIssue updateIssueUseCase;
  final UpdateSprint updateSprintUseCase;
  final DeleteSprint deleteSprintUseCase;
  final DeleteIssue deleteIssueUseCase;

  List<Sprint> _sprints = [];
  List<Issue> _backlogIssues = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  String _listPageSearchQuery = '';

  List<Sprint> get sprints => _sprints;
  List<Issue> get backlogIssues => _backlogIssues;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get listPageSearchQuery => _listPageSearchQuery;

  BacklogProvider({
    required this.getSprintsUseCase,
    required this.getIssuesUseCase,
    required this.createSprintUseCase,
    required this.createIssueUseCase,
    required this.updateIssueUseCase,
    required this.updateSprintUseCase,
    required this.deleteSprintUseCase,
    required this.deleteIssueUseCase,
  });

  void setSearchQuery(String query) {
    _searchQuery = query.trim().toLowerCase();
    notifyListeners();
  }

  void setListPageSearchQuery(String query) {
    _listPageSearchQuery = query.trim().toLowerCase();
    notifyListeners();
  }

  // Lấy danh sách sprint dựa trên searchQuery
  List<Sprint> get filteredSprints {
    if (_searchQuery.isEmpty) {
      return _sprints;
    }
    return _sprints.map((sprint) {
      final filteredIssues = sprint.issues
          .where((issue) => issue.title.toLowerCase().contains(_searchQuery))
          .toList();
      return Sprint(
        id: sprint.id,
        projectId: sprint.projectId,
        name: sprint.name,
        description: sprint.description,
        created: sprint.created,
        endTime: sprint.endTime,
        status: sprint.status,
        priority: sprint.priority,
        issues: filteredIssues,
      );
    }).toList();
  }

  // Lấy danh sách backlog issues dựa trên searchQuery
  List<Issue> get filteredBacklogIssues {
    if (_searchQuery.isEmpty) {
      return _backlogIssues;
    }
    return _backlogIssues
        .where((issue) => issue.title.toLowerCase().contains(_searchQuery))
        .toList();
  }


  //Lấy danh sách sprint cho listPage
  List<Sprint> get filteredSprintsForListPage {
    if (_listPageSearchQuery.isEmpty) {
      return _sprints;
    }
    return _sprints.map((sprint) {
      final filteredIssues = sprint.issues
          .where((issue) =>
              issue.title.toLowerCase().contains(_listPageSearchQuery))
          .toList();
      return Sprint(
        id: sprint.id,
        projectId: sprint.projectId,
        name: sprint.name,
        description: sprint.description,
        created: sprint.created,
        endTime: sprint.endTime,
        status: sprint.status,
        priority: sprint.priority,
        issues: filteredIssues,
      );
    }).toList();
  }

  //Lấy danh sách backlog cho listpage
  List<Issue> get filteredBacklogIssuesForListPage {
    if (_listPageSearchQuery.isEmpty) {
      return _backlogIssues;
    }
    return _backlogIssues
        .where(
            (issue) => issue.title.toLowerCase().contains(_listPageSearchQuery))
        .toList();
  }

  Future<void> fetchBacklogData(int projectId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      // Lấy danh sách sprint
      final sprints = await getSprintsUseCase.call(projectId);
      // Lấy danh sách issue
      final allIssues = await getIssuesUseCase.call(projectId);
      // Tạo map để gán issue vào sprint
      final Map<int, List<Issue>> sprintIssuesMap = {};
      for (var sprint in sprints) {
        sprintIssuesMap[sprint.id] = [];
      }

      // Phân loại issue
      _backlogIssues = [];
      for (var issue in allIssues) {
        if (issue.sprintId == null) {
          _backlogIssues.add(issue);
        } else if (sprintIssuesMap.containsKey(issue.sprintId)) {
          sprintIssuesMap[issue.sprintId]!.add(issue);
        }
      }

      // Cập nhật sprints với issues tương ứng
      _sprints = sprints.map((sprint) {
        return Sprint(
          id: sprint.id,
          projectId: sprint.projectId,
          name: sprint.name,
          description: sprint.description,
          created: sprint.created,
          endTime: sprint.endTime,
          status: sprint.status,
          priority: sprint.priority,
          issues: sprintIssuesMap[sprint.id] ?? [],
        );
      }).toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> addIssueToSprint(int sprintIndex, Issue issue) async {
    try {
      final sprint = _sprints[sprintIndex];
      final updatedIssue = Issue(
        issueId: issue.issueId,
        projectId: issue.projectId,
        title: issue.title,
        description: issue.description,
        status: issue.status,
        priority: issue.priority,
        assigneeId: issue.assigneeId,
        created: issue.created,
        endTime: issue.endTime,
        sprintId: sprint.id,
      );

      // Kiểm tra nếu issue đã thuộc về sprint này
      if (sprint.issues.any((i) => i.issueId == issue.issueId)) {
        print("Issue already exists in this sprint.");
        return;
      }
      // Xóa issue khỏi các sprint khác
      for (var s in _sprints) {
        if (s.id != sprint.id) {
          s.issues.removeWhere((i) => i.issueId == issue.issueId);
        }
      }

      // Cập nhật issue qua API
      await updateIssueUseCase.call(updatedIssue);

      // Cập nhật local state
      _sprints[sprintIndex] = Sprint(
        id: sprint.id,
        projectId: sprint.projectId,
        name: sprint.name,
        description: sprint.description,
        created: sprint.created,
        endTime: sprint.endTime,
        status: sprint.status,
        priority: sprint.priority,
        issues: [...sprint.issues, updatedIssue],
      );

      _backlogIssues.removeWhere((i) => i.issueId == issue.issueId);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to add issue to sprint: $e';
      notifyListeners();
    }
  }

  Future<void> addIssueToBacklog(Issue issue) async {
    try {
      final updatedIssue = Issue(
        issueId: issue.issueId,
        projectId: issue.projectId,
        title: issue.title,
        description: issue.description,
        status: issue.status,
        priority: issue.priority,
        assigneeId: issue.assigneeId,
        created: issue.created,
        endTime: issue.endTime,
        sprintId: null,
      );

      // Kiểm tra nếu issue đã thuộc về backlog này
      if (_backlogIssues.any((i) => i.issueId == issue.issueId)) {
        print("Issue already exists in the backlog.");
        return;
      }

      // Cập nhật issue qua API
      await updateIssueUseCase.call(updatedIssue);

      // Cập nhật local state
      _backlogIssues.add(updatedIssue);
      for (var sprint in _sprints) {
        sprint.issues.removeWhere((i) => i.issueId == issue.issueId);
      }
      _sprints = [..._sprints];
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to add issue to backlog: $e';
      notifyListeners();
    }
  }

  Future<void> updateIssueStatus(
      int sprintIndex, String issueId, String newStatus) async {
    try {
      final sprint = _sprints[sprintIndex];
      final issue =
          sprint.issues.firstWhere((i) => i.issueId.toString() == issueId);
      final updatedIssue = Issue(
        issueId: issue.issueId,
        projectId: issue.projectId,
        title: issue.title,
        description: issue.description,
        status: newStatus,
        priority: issue.priority,
        assigneeId: issue.assigneeId,
        created: issue.created,
        endTime: issue.endTime,
        sprintId: issue.sprintId,
      );

      // Cập nhật issue qua API
      await updateIssueUseCase.call(updatedIssue);

      // Cập nhật local state
      final updatedIssues = sprint.issues
          .map((i) => i.issueId == issue.issueId ? updatedIssue : i)
          .toList();
      _sprints[sprintIndex] = Sprint(
        id: sprint.id,
        projectId: sprint.projectId,
        name: sprint.name,
        description: sprint.description,
        created: sprint.created,
        endTime: sprint.endTime,
        status: sprint.status,
        priority: sprint.priority,
        issues: updatedIssues,
      );
      _sprints = [..._sprints];
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update issue status: $e';
      notifyListeners();
    }
  }

  Future<void> updateBacklogIssueStatus(
      String issueId, String newStatus) async {
    try {
      final issue =
          _backlogIssues.firstWhere((i) => i.issueId.toString() == issueId);
      final updatedIssue = Issue(
        issueId: issue.issueId,
        projectId: issue.projectId,
        title: issue.title,
        description: issue.description,
        status: newStatus,
        priority: issue.priority,
        assigneeId: issue.assigneeId,
        created: issue.created,
        endTime: issue.endTime,
        sprintId: null,
      );

      // Cập nhật issue qua API
      await updateIssueUseCase.call(updatedIssue);

      // Cập nhật local state
      _backlogIssues = _backlogIssues
          .map((i) => i.issueId == issue.issueId ? updatedIssue : i)
          .toList();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update backlog issue status: $e';
      notifyListeners();
    }
  }

  Future<void> updateIssueDescription(
      int sprintIndex, String issueId, String newDescription) async {
    try {
      final sprint = _sprints[sprintIndex];
      final issue =
          sprint.issues.firstWhere((i) => i.issueId.toString() == issueId);
      final updatedIssue = Issue(
        issueId: issue.issueId,
        projectId: issue.projectId,
        title: issue.title,
        description: newDescription,
        status: issue.status,
        priority: issue.priority,
        assigneeId: issue.assigneeId,
        created: issue.created,
        endTime: issue.endTime,
        sprintId: issue.sprintId,
      );

      // Cập nhật issue qua API
      await updateIssueUseCase.call(updatedIssue);

      // Cập nhật local state
      final updatedIssues = sprint.issues
          .map((i) => i.issueId == issue.issueId ? updatedIssue : i)
          .toList();
      _sprints[sprintIndex] = Sprint(
        id: sprint.id,
        projectId: sprint.projectId,
        name: sprint.name,
        description: sprint.description,
        created: sprint.created,
        endTime: sprint.endTime,
        status: sprint.status,
        priority: sprint.priority,
        issues: updatedIssues,
      );
      _sprints = [..._sprints];
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update issue description: $e';
      notifyListeners();
    }
  }

  Future<void> updateBacklogIssueDescription(
      String issueId, String newDescription) async {
    try {
      final issue =
          _backlogIssues.firstWhere((i) => i.issueId.toString() == issueId);
      final updatedIssue = Issue(
        issueId: issue.issueId,
        projectId: issue.projectId,
        title: issue.title,
        description: newDescription,
        status: issue.status,
        priority: issue.priority,
        assigneeId: issue.assigneeId,
        created: issue.created,
        endTime: issue.endTime,
        sprintId: null,
      );

      // Cập nhật issue qua API
      await updateIssueUseCase.call(updatedIssue);

      // Cập nhật local state
      _backlogIssues = _backlogIssues
          .map((i) => i.issueId == issue.issueId ? updatedIssue : i)
          .toList();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update backlog issue description: $e';
      notifyListeners();
    }
  }

  Future<void> updateIssueAssignee(
      int sprintIndex, String issueId, int? newAssigneeId) async {
    try {
      final sprint = _sprints[sprintIndex];
      final issue =
          sprint.issues.firstWhere((i) => i.issueId.toString() == issueId);
      final updatedIssue = Issue(
        issueId: issue.issueId,
        projectId: issue.projectId,
        title: issue.title,
        description: issue.description,
        status: issue.status,
        priority: issue.priority,
        assigneeId: newAssigneeId,
        created: issue.created,
        endTime: issue.endTime,
        sprintId: issue.sprintId,
      );

      // Cập nhật issue qua API
      await updateIssueUseCase.call(updatedIssue);

      // Cập nhật local state
      final updatedIssues = sprint.issues
          .map((i) => i.issueId == issue.issueId ? updatedIssue : i)
          .toList();
      _sprints[sprintIndex] = Sprint(
        id: sprint.id,
        projectId: sprint.projectId,
        name: sprint.name,
        description: sprint.description,
        created: sprint.created,
        endTime: sprint.endTime,
        status: sprint.status,
        priority: sprint.priority,
        issues: updatedIssues,
      );
      _sprints = [..._sprints];
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update issue assignee: $e';
      notifyListeners();
    }
  }

  Future<void> updateBacklogIssueAssignee(
      String issueId, int? newAssigneeId) async {
    try {
      final issue =
          _backlogIssues.firstWhere((i) => i.issueId.toString() == issueId);
      final updatedIssue = Issue(
        issueId: issue.issueId,
        projectId: issue.projectId,
        title: issue.title,
        description: issue.description,
        status: issue.status,
        priority: issue.priority,
        assigneeId: newAssigneeId,
        created: issue.created,
        endTime: issue.endTime,
        sprintId: null,
      );

      // Cập nhật issue qua API
      await updateIssueUseCase.call(updatedIssue);

      // Cập nhật local state
      _backlogIssues = _backlogIssues
          .map((i) => i.issueId == issue.issueId ? updatedIssue : i)
          .toList();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update backlog issue assignee: $e';
      notifyListeners();
    }
  }

  Future<void> updateIssuePriority(
      int sprintIndex, String issueId, String newPriority) async {
    try {
      final sprint = _sprints[sprintIndex];
      final issue =
          sprint.issues.firstWhere((i) => i.issueId.toString() == issueId);
      final updatedIssue = Issue(
        issueId: issue.issueId,
        projectId: issue.projectId,
        title: issue.title,
        description: issue.description,
        status: issue.status,
        priority: newPriority,
        assigneeId: issue.assigneeId,
        created: issue.created,
        endTime: issue.endTime,
        sprintId: issue.sprintId,
      );

      // Cập nhật issue qua API
      await updateIssueUseCase.call(updatedIssue);

      // Cập nhật local state
      final updatedIssues = sprint.issues
          .map((i) => i.issueId == issue.issueId ? updatedIssue : i)
          .toList();
      _sprints[sprintIndex] = Sprint(
        id: sprint.id,
        projectId: sprint.projectId,
        name: sprint.name,
        description: sprint.description,
        created: sprint.created,
        endTime: sprint.endTime,
        status: sprint.status,
        priority: sprint.priority,
        issues: updatedIssues,
      );
      _sprints = [..._sprints];
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update issue priority: $e';
      notifyListeners();
    }
  }

  Future<void> updateBacklogIssuePriority(
      String issueId, String newPriority) async {
    try {
      final issue =
          _backlogIssues.firstWhere((i) => i.issueId.toString() == issueId);
      final updatedIssue = Issue(
        projectId: issue.projectId,
        issueId: issue.issueId,
        title: issue.title,
        description: issue.description,
        status: issue.status,
        priority: newPriority,
        assigneeId: issue.assigneeId,
        created: issue.created,
        endTime: issue.endTime,
        sprintId: null,
      );

      // Cập nhật issue qua API
      await updateIssueUseCase.call(updatedIssue);

      // Cập nhật local state
      _backlogIssues = _backlogIssues
          .map((i) => i.issueId == issue.issueId ? updatedIssue : i)
          .toList();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update backlog issue priority: $e';
      notifyListeners();
    }
  }

  Future<void> updateIssueEndTime(
      int sprintIndex, String issueId, String newEndTime) async {
    try {
      final sprint = _sprints[sprintIndex];
      final issue =
          sprint.issues.firstWhere((i) => i.issueId.toString() == issueId);
      final updatedIssue = Issue(
        issueId: issue.issueId,
        projectId: issue.projectId,
        title: issue.title,
        description: issue.description,
        status: issue.status,
        priority: issue.priority,
        assigneeId: issue.assigneeId,
        created: issue.created,
        endTime: newEndTime.isEmpty ? null : DateTime.parse(newEndTime),
        sprintId: issue.sprintId,
      );

      // Cập nhật issue qua API
      await updateIssueUseCase.call(updatedIssue);

      // Cập nhật local state
      final updatedIssues = sprint.issues
          .map((i) => i.issueId == issue.issueId ? updatedIssue : i)
          .toList();
      _sprints[sprintIndex] = Sprint(
        id: sprint.id,
        projectId: sprint.projectId,
        name: sprint.name,
        description: sprint.description,
        created: sprint.created,
        endTime: sprint.endTime,
        status: sprint.status,
        priority: sprint.priority,
        issues: updatedIssues,
      );
      _sprints = [..._sprints];
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update issue end time: $e';
      notifyListeners();
    }
  }

  Future<void> updateBacklogIssueEndTime(
      String issueId, String newEndTime) async {
    try {
      final issue =
          _backlogIssues.firstWhere((i) => i.issueId.toString() == issueId);
      final updatedIssue = Issue(
        projectId: issue.projectId,
        issueId: issue.issueId,
        title: issue.title,
        description: issue.description,
        status: issue.status,
        priority: issue.priority,
        assigneeId: issue.assigneeId,
        created: issue.created,
        endTime: newEndTime.isEmpty ? null : DateTime.parse(newEndTime),
        sprintId: null,
      );

      // Cập nhật issue qua API
      await updateIssueUseCase.call(updatedIssue);

      // Cập nhật local state
      _backlogIssues = _backlogIssues
          .map((i) => i.issueId == issue.issueId ? updatedIssue : i)
          .toList();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update backlog issue end time: $e';
      notifyListeners();
    }
  }

  Future<void> CreatIssueToBacklog(Issue issue, int projectId) async {
    try {
      // Tạo issue qua API
      await createIssueUseCase.call(issue);

      // Cập nhật local state
      _backlogIssues.add(issue);
      print('BacklogProvider: Added issue to backlog: $issue');
      fetchBacklogData(projectId);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to create new issue: $e';
      notifyListeners();
    }
  }

  Future<void> creatIssueToSprint(
      int sprintIndex, Issue issue, int ProjectId) async {
    try {
      // Kiểm tra sprintIndex hợp lệ
      if (sprintIndex < 0 || sprintIndex >= _sprints.length) {
        throw Exception('Invalid sprint index: $sprintIndex');
      }

      // Tạo issue qua API
      await createIssueUseCase.call(issue);
      fetchBacklogData(ProjectId);

      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to add issue to sprint: $e';
      notifyListeners();
    }
  }

  Future<void> updateSprintCreated(int sprintIndex, DateTime newCreated,
      {bool updateApi = true}) async {
    try {
      if (sprintIndex < 0 || sprintIndex >= _sprints.length) {
        throw Exception('Invalid sprint index: $sprintIndex');
      }
      final sprint = _sprints[sprintIndex];
      final updatedSprint = Sprint(
        id: sprint.id,
        projectId: sprint.projectId,
        name: sprint.name,
        description: sprint.description,
        created: newCreated,
        endTime: sprint.endTime,
        status: sprint.status,
        priority: sprint.priority,
        issues: sprint.issues,
      );

      if (updateApi) {
        await updateSprintUseCase.call(updatedSprint);
      }
      _sprints[sprintIndex] = updatedSprint;

      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update sprint created time: $e';

      notifyListeners();
    }
  }

  Future<void> updateSprintEndTime(int sprintIndex, DateTime? newEndTime,
      {bool updateApi = true}) async {
    try {
      if (sprintIndex < 0 || sprintIndex >= _sprints.length) {
        throw Exception('Invalid sprint index: $sprintIndex');
      }
      final sprint = _sprints[sprintIndex];
      final updatedSprint = Sprint(
        id: sprint.id,
        projectId: sprint.projectId,
        name: sprint.name,
        description: sprint.description,
        created: sprint.created,
        endTime: newEndTime,
        status: sprint.status,
        priority: sprint.priority,
        issues: sprint.issues,
      );

      if (updateApi) {
        await updateSprintUseCase.call(updatedSprint);
      }
      _sprints[sprintIndex] = updatedSprint;

      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update sprint end time: $e';

      notifyListeners();
    }
  }

  Future<void> updateSprint(Sprint sprint) async {
    try {
      await updateSprintUseCase.call(sprint);
      _sprints = _sprints.map((s) => s.id == sprint.id ? sprint : s).toList();

      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update sprint: $e';

      notifyListeners();
    }
  }

  Future<void> createSprint(Sprint sprint, int ProjectId) async {
    try {
      // Tạo sprint qua API
      await createSprintUseCase.call(sprint);

      // Cập nhật local state
      fetchBacklogData(ProjectId);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to create new sprint: $e';
      notifyListeners();
    }
  }
}
