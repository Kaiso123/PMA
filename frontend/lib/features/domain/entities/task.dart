import 'package:doan/features/core/enums.dart';

class Task {
  final int? taskId;
  final String? title;
  final String? description;
  final DateTime? startDate;
  final DateTime? deadline;
  final Priority priority;
  final ProjectStatus status;
  final int? projectId;
  final List<int>? assignedUserIds;

  Task({
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
}
