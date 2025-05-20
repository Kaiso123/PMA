import 'package:doan/features/core/enums.dart';
import 'package:doan/features/domain/entities/userProject.dart';


class UserProjectModel {
  final int? userProjectId;
  final int? userId;
  final int? projectId;
  final bool isManager;
  final String? projectName;
  final String? projectDescription;
  final DateTime? projectStartDate;
  final DateTime? projectEndDate;
  final ProjectStatus? projectStatus;

  const UserProjectModel({
    this.userProjectId,
    this.userId,
    this.projectId,
    this.isManager = false,
    this.projectName,
    this.projectDescription,
    this.projectStartDate,
    this.projectEndDate,
    this.projectStatus,
  });

  factory UserProjectModel.fromJson(Map<String, dynamic> json) {
    return UserProjectModel(
      userProjectId: json['userProjectId'] as int?,
      userId: json['userId'] as int?,
      projectId: json['projectId'] as int?,
      isManager: json['isManager'] as bool? ?? false,
      projectName: json['projectName'] as String?,
      projectDescription: json['projectDescription'] as String?,
      projectStartDate: json['projectStartDate'] != null
          ? DateTime.tryParse(json['projectStartDate'] as String)
          : null,
      projectEndDate: json['projectEndDate'] != null
          ? DateTime.tryParse(json['projectEndDate'] as String)
          : null,
      projectStatus: _parseProjectStatus(json['projectStatus']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (userProjectId != null) 'userProjectId': userProjectId,
      if (userId != null) 'userId': userId,
      if (projectId != null) 'projectId': projectId,
      'isManager': isManager,
      if (projectName != null) 'projectName': projectName,
      if (projectDescription != null) 'projectDescription': projectDescription,
      if (projectStartDate != null)
        'projectStartDate': projectStartDate!.toIso8601String(),
      if (projectEndDate != null)
        'projectEndDate': projectEndDate!.toIso8601String(),
      if (projectStatus != null) 'projectStatus': projectStatus!.name,
    };
  }

  UserProject toEntity() => UserProject(
        userProjectId: userProjectId,
        userId: userId,
        projectId: projectId,
        isManager: isManager,
        projectName: projectName,
        projectDescription: projectDescription,
        projectStartDate: projectStartDate,
        projectEndDate: projectEndDate,
        projectStatus: projectStatus,
      );

  // Helper method để parse ProjectStatus
  static ProjectStatus? _parseProjectStatus(dynamic status) {
    if (status == null) return null;
    return ProjectStatus.values.firstWhere(
      (e) => e.name == status.toString(),
      orElse: () => ProjectStatus.pending,
    );
  }
}