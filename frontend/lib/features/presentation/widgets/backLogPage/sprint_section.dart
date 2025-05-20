import 'package:doan/features/domain/entities/issue.dart';
import 'package:doan/features/presentation/widgets/backLogPage/component/creat_issue_overlay.dart';
import 'package:doan/features/presentation/widgets/backLogPage/component/edit_sprint_overlay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../blocs/backlog_provider2.dart';
import '../backLogPage/issues_item.dart';

class SprintSection extends StatefulWidget {
  final String sprintName;
  final int issueCount;
  final List<Issue> issues;
  final int sprintIndex;
  final int projectId;
  final int sprintId;
  final bool isManager;

  const SprintSection({
    Key? key,
    required this.sprintName,
    required this.issueCount,
    required this.issues,
    required this.sprintIndex,
    required this.projectId,
    required this.sprintId,
    required this.isManager,
  }) : super(key: key);

  @override
  State<SprintSection> createState() => _SprintSectionState();
}

class _SprintSectionState extends State<SprintSection> {
  bool isExpanded = false;

  void toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  void _showCreateIssueOverlay(BuildContext context) {
    OverlayEntry? overlayEntry;
    overlayEntry = createIssueOverlayEntry(
      context,
      (issue) {
        Provider.of<BacklogProvider>(context, listen: false)
            .creatIssueToSprint(widget.sprintIndex, issue, widget.projectId);
      },
      () {
        overlayEntry?.remove();
        overlayEntry = null;
      },
      widget.projectId,
      widget.sprintId,
    );
    Overlay.of(context).insert(overlayEntry!);
  }

  void _showEditSprintOverlay(BuildContext context) {
    OverlayEntry? overlayEntry;
    final sprint = Provider.of<BacklogProvider>(context, listen: false)
        .sprints[widget.sprintIndex];
    overlayEntry = createEditSprintOverlayEntry(
      context,
      sprint,
      (updatedSprint) {
        Provider.of<BacklogProvider>(context, listen: false)
            .updateSprint(updatedSprint);
      },
      () {
        overlayEntry?.remove();
        overlayEntry = null;
      },
    );
    Overlay.of(context).insert(overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<Issue>(
      onAccept: (issue) {
        Provider.of<BacklogProvider>(context, listen: false)
            .addIssueToSprint(widget.sprintIndex, issue);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          margin: const EdgeInsets.fromLTRB(0,0,0,16),
          decoration: BoxDecoration(
            border: candidateData.isNotEmpty
                ? Border.all(color: Colors.blue, width: 2)
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: toggleExpand,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.grey[100],
                  child: Row(
                    children: [
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.sprintName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '(${widget.issues.length} issue${widget.issues.length != 1 ? "s" : ""})',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      widget.isManager
                          ? ElevatedButton(
                              onPressed: () => _showEditSprintOverlay(context),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: const Text(
                                'Edit sprint',
                                style: TextStyle(fontSize: 14),
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
              if (isExpanded)
                Column(
                  children: [
                    ...widget.issues.map(
                      (issue) => IssueItem(
                        id: issue.issueId,
                        projectId: issue.projectId,
                        title: issue.title,
                        status: issue.status,
                        description: issue.description ?? 'Description...',
                        assignee: issue.assigneeId?.toString() ?? 'Unassigned',
                        priority: issue.priority,
                        created: issue.created.toIso8601String(),
                        endTime: issue.endTime?.toIso8601String() ?? '',
                        isDraggable: widget.isManager,
                        onStatusChanged: (newStatus) {
                          final provider = Provider.of<BacklogProvider>(context,
                              listen: false);
                          provider.updateIssueStatus(widget.sprintIndex,
                              issue.issueId.toString(), newStatus);
                        },
                        onDescriptionChanged: (newDescription) {
                          final provider = Provider.of<BacklogProvider>(context,
                              listen: false);
                          provider.updateIssueDescription(widget.sprintIndex,
                              issue.issueId.toString(), newDescription);
                        },
                        onPriorityChanged: (newPriority) {
                          final provider = Provider.of<BacklogProvider>(context,
                              listen: false);
                          provider.updateIssuePriority(widget.sprintIndex,
                              issue.issueId.toString(), newPriority);
                        },
                        onEndTimeChanged: (newEndTime) {
                          final provider = Provider.of<BacklogProvider>(context,
                              listen: false);
                          provider.updateIssueEndTime(widget.sprintIndex,
                              issue.issueId.toString(), newEndTime);
                        },
                      ),
                    ),
                    widget.isManager
                        ? TextButton(
                            onPressed: () => _showCreateIssueOverlay(context),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.add, size: 20, color: Colors.blue),
                                SizedBox(width: 4),
                                Text(
                                  'Create issue',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.blue),
                                ),
                              ],
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
