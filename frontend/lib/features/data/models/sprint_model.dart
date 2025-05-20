import '../../domain/entities/sprint.dart';
import 'issue_model.dart';

class SprintModel {
  final int id;
  final int projectId;
  final String name;
  final String? description;
  final DateTime created;
  final DateTime? endTime;
  final String status;
  final String priority;
  final List<IssueModel> issues;

  SprintModel({
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

  factory SprintModel.fromJson(Map<String, dynamic> json) {
    return SprintModel(
      id: json['sprintId'] as int,
      projectId: json['projectId'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      created: DateTime.parse(json['created'] as String),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime'] as String) : null,
      status: json['status'] as String,
      priority: json['priority'] as String,
      issues: (json['issues'] as List<dynamic>?)
              ?.map((e) => IssueModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Sprint toEntity() {
    return Sprint(
      id: id,
      projectId: projectId,
      name: name,
      description: description,
      created: created,
      endTime: endTime,
      status: status,
      priority: priority,
      issues: issues.map((issue) => issue.toEntity()).toList(),
    );
  }
}