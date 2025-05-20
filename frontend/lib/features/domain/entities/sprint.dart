import 'package:doan/features/domain/entities/issue.dart';

class Sprint {
  final int id;
  final int projectId;
  final String name;
  final String? description;
  final DateTime created;
  final DateTime? endTime;
  final String status;
  final String priority;
  final List<Issue> issues;

  Sprint({
    required this.id,
    required this.projectId,
    required this.name,
    this.description,
    required this.created,
    this.endTime,
    required this.status,
    required this.priority,
    required this.issues,
  });
}