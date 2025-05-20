import 'package:doan/features/core/enums.dart';

class UserProject {
  final int? userProjectId;
  final int? userId;
  final int? projectId;
  final bool isManager;
  final String? projectName;
  final String? projectDescription;
  final DateTime? projectStartDate;
  final DateTime? projectEndDate;
  final ProjectStatus? projectStatus;

  UserProject({
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
}