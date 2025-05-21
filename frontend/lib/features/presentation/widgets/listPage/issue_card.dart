import 'package:doan/features/domain/entities/issue.dart';
import 'package:doan/features/presentation/blocs/backlog_provider2.dart';
import 'package:doan/features/presentation/widgets/backLogPage/component/detail_issue_overlay.dart';
import 'package:doan/features/presentation/widgets/listPage/info_chip.dart';
import 'package:doan/features/presentation/widgets/listPage/list_page_utils.dart';
import 'package:flutter/material.dart';

class IssueCard extends StatelessWidget {
  final Issue issue;
  final String sprintName;
  final BacklogProvider provider;
  final bool isManager;

  const IssueCard({
    Key? key,
    required this.issue,
    required this.sprintName,
    required this.provider,
    required this.isManager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor(issue.status);
    final priorityColor = getPriorityColor(issue.priority);

    return GestureDetector(
      onTap: () {
        OverlayEntry? detailOverlayEntry;
        detailOverlayEntry = createDetailOverlayEntry(
          context,
          issue.title,
          issue.status,
          issue.description ?? '',
          issue.assigneeId?.toString() ?? 'Unassigned',
          issue.priority,
          sprintName,
          issue.created.toIso8601String(),
          issue.endTime?.toIso8601String() ?? '',
          (newStatus) {
            if (isManager) {
              if (issue.sprintId == null) {
                provider.updateBacklogIssueStatus(
                    issue.issueId.toString(), newStatus);
              } else {
                final sprintIndex = provider.sprints
                    .indexWhere((sprint) => sprint.id == issue.sprintId);
                if (sprintIndex != -1) {
                  provider.updateIssueStatus(
                      sprintIndex, issue.issueId.toString(), newStatus);
                }
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Chỉ quản lý mới có thể thay đổi trạng thái.')),
              );
            }
          },
          (newDescription) {
            if (isManager) {
              if (issue.sprintId == null) {
                provider.updateBacklogIssueDescription(
                    issue.issueId.toString(), newDescription);
              } else {
                final sprintIndex = provider.sprints
                    .indexWhere((sprint) => sprint.id == issue.sprintId);
                if (sprintIndex != -1) {
                  provider.updateIssueDescription(
                      sprintIndex, issue.issueId.toString(), newDescription);
                }
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Chỉ quản lý mới có thể thay đổi mô tả.')),
              );
            }
          },
          (newPriority) {
            if (isManager) {
              if (issue.sprintId == null) {
                provider.updateBacklogIssuePriority(
                    issue.issueId.toString(), newPriority);
              } else {
                final sprintIndex = provider.sprints
                    .indexWhere((sprint) => sprint.id == issue.sprintId);
                if (sprintIndex != -1) {
                  provider.updateIssuePriority(
                      sprintIndex, issue.issueId.toString(), newPriority);
                }
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Chỉ quản lý mới có thể thay đổi ưu tiên.')),
              );
            }
          },
          (newEndTime) {
            if (isManager) {
              if (issue.sprintId == null) {
                provider.updateBacklogIssueEndTime(
                    issue.issueId.toString(), newEndTime);
              } else {
                final sprintIndex = provider.sprints
                    .indexWhere((sprint) => sprint.id == issue.sprintId);
                if (sprintIndex != -1) {
                  provider.updateIssueEndTime(
                      sprintIndex, issue.issueId.toString(), newEndTime);
                }
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'Chỉ quản lý mới có thể thay đổi thời gian kết thúc.')),
              );
            }
          },
          (newAssigneeId) {
            if (isManager) {
              if (issue.sprintId == null) {
                provider.updateBacklogIssueAssignee(
                    issue.issueId.toString(), int.parse(newAssigneeId));
              } else {
                final sprintIndex = provider.sprints
                    .indexWhere((sprint) => sprint.id == issue.sprintId);
                if (sprintIndex != -1) {
                  provider.updateIssueAssignee(sprintIndex,
                      issue.issueId.toString(), int.parse(newAssigneeId));
                }
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'Chỉ quản lý mới có thể thay đổi thời gian kết thúc.')),
              );
            }
          },
          () {
            detailOverlayEntry?.remove();
          },
        );
        Overlay.of(context).insert(detailOverlayEntry);
      },
      child: Card(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: const Color.fromARGB(26, 0, 0, 0),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tiêu đề
              Text(
                issue.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              // Thông tin phụ
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // Status
                  InfoChip(
                    label: issue.status,
                    icon: Icons.circle,
                    color: statusColor,
                  ),
                  // Priority
                  InfoChip(
                    label: issue.priority,
                    icon: Icons.flag,
                    color: priorityColor,
                  ),
                  // Assignee
                  InfoChip(
                    label: issue.assigneeId?.toString() ?? 'Unassigned',
                    icon: Icons.person,
                    color: Colors.grey[600]!,
                  ),
                  // Due Date
                  InfoChip(
                    label: issue.endTime != null
                        ? formatDisplayDate(issue.endTime!.toIso8601String())
                        : 'No Due Date',
                    icon: Icons.calendar_today,
                    color: isOverdue(issue.endTime)
                        ? Colors.red
                        : Colors.grey[600]!,
                  ),
                  // Sprint
                  InfoChip(
                    label: sprintName,
                    icon: Icons.fire_extinguisher,
                    color: Colors.blueGrey[600]!,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
