class Issue {
  final int issueId;
  final String title;
  final String? description;
  final String status;
  final String priority;
  final int? assigneeId;
  final DateTime created;
  final DateTime? endTime;
  final int projectId;
  final int? sprintId; // Thay sprintName bằng sprintId
  Issue({
    required this.issueId,
    this.description,
    required this.title,
    required this.status,
    required this.priority,
    this.assigneeId,
    required this.created,
    this.endTime,
    required this.projectId,
    this.sprintId,
  });
}