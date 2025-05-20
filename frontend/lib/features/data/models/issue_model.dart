import '../../domain/entities/issue.dart';

class IssueModel {
  final int id;
  final String title;
  final String? description;
  final String status;
  final String priority;
  final int? assigneeId;
  final DateTime created;
  final DateTime? endTime;
  final int projectId;
  final int? sprintId;

  IssueModel({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    this.assigneeId,
    required this.created,
    this.endTime,
    required this.projectId,
    this.sprintId,
  });

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      id: json['issueId'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      status: json['status'] as String,
      priority: json['priority'] as String,
      assigneeId: json['assigneeId'] as int?,
      created: DateTime.parse(json['created'] as String),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime'] as String) : null,
      projectId: json['projectId'] as int,
      sprintId: json['sprintId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'issueId': id,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'assigneeId': assigneeId,
      'created': created.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'projectId': projectId,
      'sprintId': sprintId,
    };
  }

  Issue toEntity() {
    return Issue(
      issueId: id,
      title: title,
      description: description,
      status: status,
      priority: priority,
      assigneeId: assigneeId,
      created: created,
      endTime: endTime,
      projectId: projectId,
      sprintId: sprintId,
    );
  }
}