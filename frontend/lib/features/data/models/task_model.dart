import 'package:doan/features/core/enums.dart';
import 'package:doan/features/domain/entities/task.dart';

class TaskModel {
  final int? taskId;
  final String? title;
  final String? description;
  final DateTime? startDate;
  final DateTime? deadline;
  final Priority priority;
  final ProjectStatus status; 
  final int? projectId;
  final List<int>? assignedUserIds;

  const TaskModel({
    this.taskId,
    this.title,
    this.description,
    this.startDate,
    this.deadline,
    this.priority = Priority.medium,
    this.status = ProjectStatus.pending,
    this.projectId,
    this.assignedUserIds,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      taskId: json['taskId'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'] as String)
          : null,
      deadline: json['deadline'] != null
          ? DateTime.tryParse(json['deadline'] as String)
          : null,
      priority: _parsePriority(json['priority']),
      status: _parseProjectStatus(json['status']),
      projectId: json['projectId'] as int?,
      assignedUserIds: json['assignedUserIds'] != null
          ? (json['assignedUserIds'] as List<dynamic>)
              .map((e) => e as int)
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (taskId != null) 'taskId': taskId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (startDate != null) 'startDate': startDate!.toIso8601String(),
      if (deadline != null) 'deadline': deadline!.toIso8601String(),
      'priority': priority.name,
      'status': status.name,
      if (projectId != null) 'projectId': projectId,
      if (assignedUserIds != null) 'assignedUserIds': assignedUserIds,
    };
  }

  Task toEntity() => Task(
        taskId: taskId,
        title: title,
        description: description,
        startDate: startDate,
        deadline: deadline,
        priority: priority,
        status: status,
        projectId: projectId,
        assignedUserIds: assignedUserIds,
      );

  // Helper method để parse Priority
  static Priority _parsePriority(dynamic priority) {
    if (priority == null) return Priority.medium;
    return Priority.values.firstWhere(
      (e) => e.name == priority.toString(),
      orElse: () => Priority.medium,
    );
  }

  // Helper method để parse ProjectStatus
  static ProjectStatus _parseProjectStatus(dynamic status) {
    if (status == null) return ProjectStatus.pending;
    return ProjectStatus.values.firstWhere(
      (e) => e.name == status.toString(),
      orElse: () => ProjectStatus.pending,
    );
  }
}
