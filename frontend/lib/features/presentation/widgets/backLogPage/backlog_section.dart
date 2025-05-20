import 'package:doan/features/domain/entities/issue.dart';
import 'package:doan/features/presentation/widgets/backLogPage/component/creat_issue_overlay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../blocs/backlog_provider2.dart';
import '../backLogPage/issues_item.dart';

class BacklogSection extends StatelessWidget {
  final ScrollController scrollController;
  final int projectId;
  final bool isManager;
  const BacklogSection(
      {Key? key,
      required this.scrollController,
      required this.projectId,
      required this.isManager})
      : super(key: key);
  void _showCreateIssueOverlay(BuildContext context, int projectId) {
    OverlayEntry? overlayEntry;
    overlayEntry = createIssueOverlayEntry(context, (issueData) {
      Provider.of<BacklogProvider>(context, listen: false)
          .CreatIssueToBacklog(issueData, projectId);
    }, () {
      overlayEntry?.remove();
      overlayEntry = null;
    }, projectId, 0);
    Overlay.of(context).insert(overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BacklogProvider>(
      builder: (context, provider, child) {
        print('BacklogSection Consumer rebuilt');
        print('Backlog issues in BacklogSection: ${provider.backlogIssues}');
        final backlogIssues = provider.backlogIssues;
        return DragTarget<Issue>(
          onAccept: (issue) {
            Provider.of<BacklogProvider>(context, listen: false)
                .addIssueToBacklog(issue);
          },
          builder: (context, candidateData, rejectedData) {
            return ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(12.0),
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Text(
                  'Backlog (${backlogIssues.length} work item${backlogIssues.length != 1 ? "s" : ""})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...backlogIssues.map((issue) => IssueItem(
                      id: issue.issueId, // Truyền id
                      projectId: issue.projectId,
                      title: issue.title,
                      status: issue.status,
                      description: issue.description ?? 'Description...',
                      assignee: issue.assigneeId?.toString() ?? 'Unassigned',
                      priority: issue.priority,
                      created: issue.created.toIso8601String(),
                      endTime: issue.endTime?.toIso8601String() ?? '',
                      isDraggable: isManager,
                      onStatusChanged: (newStatus) {
                        final provider = Provider.of<BacklogProvider>(context,
                            listen: false);
                        provider.updateBacklogIssueStatus(
                            issue.issueId.toString(), newStatus);
                      },
                      onDescriptionChanged: (newDescription) {
                        final provider = Provider.of<BacklogProvider>(context,
                            listen: false);
                        provider.updateBacklogIssueDescription(
                            issue.issueId.toString(), newDescription);
                      },
                      onPriorityChanged: (newPriority) {
                        final provider = Provider.of<BacklogProvider>(context,
                            listen: false);
                        provider.updateBacklogIssuePriority(
                            issue.issueId.toString(), newPriority);
                      },
                      onEndTimeChanged: (newEndTime) {
                        final provider = Provider.of<BacklogProvider>(context,
                            listen: false);
                        provider.updateBacklogIssueEndTime(
                            issue.issueId.toString(), newEndTime);
                      },
                    )),
                const SizedBox(height: 12),
                isManager
                    ? TextButton(
                        onPressed: () =>
                            _showCreateIssueOverlay(context, projectId),
                        child: const Row(
                          children: [
                            Icon(Icons.add, size: 20, color: Colors.blue),
                            SizedBox(width: 4),
                            Text(
                              'Create work item or create from Confluence page',
                              style:
                                  TextStyle(fontSize: 13, color: Colors.blue),
                            ),
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            );
          },
        );
      },
    );
  }
}
