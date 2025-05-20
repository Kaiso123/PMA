import 'package:doan/features/core/enums.dart';
import 'package:doan/features/domain/entities/project.dart';

class ProjectModel {
  final int? projectId;
  final int? ManagerId;
  final String? name;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<int>? memberIds;
  final ProjectStatus status;
  final double budget; 
  final double progress; 
  final String? inviteCode;
  final bool? isManager;

  const ProjectModel({
    this.projectId,
    this.ManagerId,
    this.name,
    this.description,
    this.startDate,
    this.endDate,
    this.memberIds,
    this.status = ProjectStatus.pending,
    this.budget = 0.0,
    this.progress = 0.0,
    this.inviteCode,
    this.isManager
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      projectId: json['projectId'] as int?,
      ManagerId: json['managerId'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'] as String)
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'] as String)
          : null,
      memberIds: json['memberIds'] != null
          ? (json['memberIds'] as List<dynamic>).map((e) => e as int).toList()
          : null,
      status: _parseProjectStatus(json['status']),
      budget: (json['budget'] as num?)?.toDouble() ?? 0.0,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      inviteCode:  (json['inviteCode'] as String?),
      isManager: (json['isManager'] as bool?)
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (projectId != null) 'projectId': projectId,
      if (ManagerId != null) 'managerId': ManagerId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (startDate != null) 'startDate': startDate!.toIso8601String(),
      if (endDate != null) 'endDate': endDate!.toIso8601String(),
      if (memberIds != null) 'memberIds': memberIds,
      'status': status.name, 
      'budget': budget,
      'progress': progress,
      if (inviteCode != null) "inviteCode" : inviteCode
    };
  }

  Project toEntity() => Project(
        projectId: projectId,
        managerId: ManagerId,
        name: name,
        description: description,
        startDate: startDate,
        endDate: endDate,
        memberIds: memberIds,
        status: status,
        budget: budget,
        progress: progress,
        inviteCode: inviteCode,
        isManager: isManager,
      );

  // Helper method để parse ProjectStatus
  static ProjectStatus _parseProjectStatus(dynamic status) {
    if (status == null) return ProjectStatus.pending;
    return ProjectStatus.values.firstWhere(
      (e) => e.name == status.toString(),
      orElse: () => ProjectStatus.pending,
    );
  }
}
