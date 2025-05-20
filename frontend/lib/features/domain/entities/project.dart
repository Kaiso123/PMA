

import 'package:doan/features/core/enums.dart';

class Project {
  final int? projectId;
  final int? managerId;
  final String? name;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<int>? memberIds;
  final ProjectStatus status;
  final double budget;
  final double progress; // Tiến độ (0.0 - 1.0)
  final String? inviteCode;
  final bool? isManager;

  Project({
    this.projectId,
    this.managerId,
    this.name,
    this.description,
    this.startDate,
    this.endDate,
    this.memberIds,
    this.status = ProjectStatus.pending,
    this.budget = 0.0,
    this.progress = 0.0,
    this.inviteCode,
    this.isManager,
  });
}
