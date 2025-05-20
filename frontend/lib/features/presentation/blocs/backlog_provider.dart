import 'package:flutter/material.dart';

class BacklogProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _sprints = [
    {
      'name': 'SCRUM Sprint 1',
      'issueCount': 1,
      'created': '01/01/2025',
      'end_time': '31/03/2025',
      'status': 'To Do',
      'priority': 'Medium',
      'issues': [
        {
          'title': 'SCRUM-3 đásd',
          'status': 'Done',
          'description': 'Description...',
          'assignee': 'Unassigned',
          'priority': 'Medium',
          'sprint': 'SCRUM Sprint 1',
          'created': 'Apr 19, 2025',
          'end_time': '',
        },
      ],
    },
    {
      'name': 'SCRUM Sprint 2',
      'issueCount': 1,
      'created': '01/04/2025',
      'end_time': '30/06/2025',
      'status': 'To Do',
      'priority': 'High',
      'issues': [
        {
          'title': 'SCRUM-4 sđasdasd',
          'status': 'To Do',
          'description': 'Description...',
          'assignee': 'Unassigned',
          'priority': 'High',
          'sprint': 'SCRUM Sprint 2',
          'created': 'Apr 19, 2025',
          'end_time': '',
        },
      ],
    },
    {
      'name': 'SCRUM Sprint 3',
      'issueCount': 1,
      'created': '01/04/2025',
      'end_time': '30/06/2025',
      'status': 'To Do',
      'priority': 'High',
      'issues': [
        {
          'title': 'SCRUM-5 sđasdasd',
          'status': 'To Do',
          'description': 'Description...',
          'assignee': 'Unassigned',
          'priority': 'High',
          'sprint': 'SCRUM Sprint 2',
          'created': 'Apr 19, 2025',
          'end_time': '',
        },
      ],
    },
    {
      'name': 'SCRUM Sprint 4',
      'issueCount': 1,
      'created': '01/04/2025',
      'end_time': '30/06/2025',
      'status': 'To Do',
      'priority': 'Medium',
      'issues': [
        {
          'title': 'SCRUM-10 sđasdasd',
          'status': 'To Do',
          'description': 'Description...',
          'assignee': 'Unassigned',
          'priority': 'Medium',
          'sprint': 'SCRUM Sprint 2',
          'created': 'Apr 19, 2025',
          'end_time': '',
        },
      ],
    },
  ];

  final List<Map<String, String>> _backlogIssues = [
    {
      'title': 'SCRUM-6 asdasasd',
      'status': 'To Do',
      'description': 'Description...',
      'assignee': 'Unassigned',
      'priority': 'Medium',
      'sprint': 'Backlog',
      'created': 'Apr 19, 2025',
      'end_time': '',
    },
  ];

  List<Map<String, dynamic>> get sprints => _sprints;
  List<Map<String, String>> get backlogIssues => _backlogIssues;

  void addIssueToSprint(int sprintIndex, Map<String, String> issue) {
    final newIssue = Map<String, String>.from(issue);

    final currentSprintIssues =
        List<Map<String, String>>.from(_sprints[sprintIndex]['issues']);
    if (currentSprintIssues.any((i) => _isSameIssue(i, issue))) return;

    for (int i = 0; i < _sprints.length; i++) {
      _sprints[i]['issues'].removeWhere((i) => _isSameIssue(i, issue));
      _sprints[i]['issueCount'] = _sprints[i]['issues'].length;
    }

    _backlogIssues.removeWhere((i) => _isSameIssue(i, issue));

    newIssue['sprint'] = _sprints[sprintIndex]['name'];

    _sprints[sprintIndex]['issues'].add(newIssue);
    _sprints[sprintIndex]['issueCount'] =
        _sprints[sprintIndex]['issues'].length;

    notifyListeners();
  }

  void addIssueToBacklog(Map<String, String> issue) {
    final newIssue = Map<String, String>.from(issue);

    if (_backlogIssues.any((i) => _isSameIssue(i, issue))) return;

    for (var sprint in _sprints) {
      sprint['issues'].removeWhere((i) => _isSameIssue(i, issue));
      sprint['issueCount'] = sprint['issues'].length;
    }

    newIssue['sprint'] = 'Backlog';
    newIssue['end_time'] = newIssue['end_time'] ?? '';
    _backlogIssues.add(newIssue);

    notifyListeners();
  }

  void updateIssueStatus(int sprintIndex, String title, String newStatus) {
    final issues = _sprints[sprintIndex]['issues'] as List<Map<String, String>>;
    final issueIndex = issues.indexWhere((i) => i['title'] == title);
    if (issueIndex != -1) {
      issues[issueIndex]['status'] = newStatus;
      notifyListeners();
    }
  }

  void updateBacklogIssueStatus(String title, String newStatus) {
    final issueIndex = _backlogIssues.indexWhere((i) => i['title'] == title);
    if (issueIndex != -1) {
      _backlogIssues[issueIndex]['status'] = newStatus;
      notifyListeners();
    }
  }

  void updateIssueDescription(
      int sprintIndex, String title, String newDescription) {
    final issues = _sprints[sprintIndex]['issues'] as List<Map<String, String>>;
    final issueIndex = issues.indexWhere((i) => i['title'] == title);
    if (issueIndex != -1) {
      issues[issueIndex]['description'] = newDescription;
      notifyListeners();
    }
  }

  void updateBacklogIssueDescription(String title, String newDescription) {
    final issueIndex = _backlogIssues.indexWhere((i) => i['title'] == title);
    if (issueIndex != -1) {
      _backlogIssues[issueIndex]['description'] = newDescription;
      notifyListeners();
    }
  }

  void updateIssuePriority(int sprintIndex, String title, String newPriority) {
    final issues = _sprints[sprintIndex]['issues'] as List<Map<String, String>>;
    final issueIndex = issues.indexWhere((i) => i['title'] == title);
    if (issueIndex != -1) {
      issues[issueIndex]['priority'] = newPriority;
      notifyListeners();
    }
  }

  void updateBacklogIssuePriority(String title, String newPriority) {
    final issueIndex = _backlogIssues.indexWhere((i) => i['title'] == title);
    if (issueIndex != -1) {
      _backlogIssues[issueIndex]['priority'] = newPriority;
      notifyListeners();
    }
  }

  void updateIssueEndTime(int sprintIndex, String title, String newEndTime) {
    final issues = _sprints[sprintIndex]['issues'] as List<Map<String, String>>;
    final issueIndex = issues.indexWhere((i) => i['title'] == title);
    if (issueIndex != -1) {
      issues[issueIndex]['end_time'] = newEndTime;
      notifyListeners();
    }
  }

  void updateBacklogIssueEndTime(String title, String newEndTime) {
    final issueIndex = _backlogIssues.indexWhere((i) => i['title'] == title);
    if (issueIndex != -1) {
      _backlogIssues[issueIndex]['end_time'] = newEndTime;
      notifyListeners();
    }
  }

  void updateSprintCreated(int sprintIndex, String newCreated) {
    _sprints[sprintIndex]['created'] = newCreated;
    notifyListeners();
  }

  void updateSprintEndTime(int sprintIndex, String newEndTime) {
    _sprints[sprintIndex]['end_time'] = newEndTime;
    notifyListeners();
  }

  void updateSprintStatus(int sprintIndex, String newStatus) {
    _sprints[sprintIndex]['status'] = newStatus;
    notifyListeners();
  }

  void updateSprintPriority(int sprintIndex, String newPriority) {
    _sprints[sprintIndex]['priority'] = newPriority;
    notifyListeners();
  }

  bool _isSameIssue(Map<String, String> issue1, Map<String, String> issue2) {
    return issue1['title'] == issue2['title'];
  }
}