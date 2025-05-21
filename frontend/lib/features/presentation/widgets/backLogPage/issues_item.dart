import 'package:doan/features/presentation/widgets/backLogPage/component/detail_issue_overlay.dart';
import 'package:flutter/material.dart';
import 'package:doan/features/domain/entities/issue.dart';
import './component/issues_item_components.dart';

class IssueItem extends StatefulWidget {
  final int id;
  final int projectId;
  final String title;
  final String sprint;
  final String status;
  final String description;
  final String assignee;
  final String priority;
  final String created;
  final String endTime;
  final bool isDraggable;
  final Function(String)? onStatusChanged;
  final Function(String)? onDescriptionChanged;
  final Function(String)? onPriorityChanged;
  final Function(String)? onEndTimeChanged;
  final Function(String)? onAssigneChange;

  const IssueItem({
    Key? key,
    required this.id,
    required this.projectId,
    required this.title,
    this.sprint = 'Backlog',
    this.status = 'To Do',
    this.description = 'Description...',
    this.assignee = 'Unassigned',
    this.priority = 'Medium',
    this.created = 'Unknown',
    this.endTime = '',
    this.isDraggable = false,
    this.onStatusChanged,
    this.onDescriptionChanged,
    this.onPriorityChanged,
    this.onEndTimeChanged,
    this.onAssigneChange,
  }) : super(key: key);

  @override
  State<IssueItem> createState() => _IssueItemState();
}

class _IssueItemState extends State<IssueItem> {
  OverlayEntry? _statusOverlayEntry;
  OverlayEntry? _detailOverlayEntry;
  final LayerLink _layerLink = LayerLink();

  void _toggleStatusOverlay(BuildContext context) {
    if (_statusOverlayEntry == null) {
      _showStatusOverlay(context);
    } else {
      _hideStatusOverlay();
    }
  }

  void _showStatusOverlay(BuildContext context) {
    _statusOverlayEntry = createStatusOverlayEntry(
      context,
      _layerLink,
      (status) {
        print('IssueItem: Status changed to $status for issue ${widget.id}');
        widget.onStatusChanged?.call(status);
        _hideStatusOverlay();
      },
    );
    Overlay.of(context).insert(_statusOverlayEntry!);
  }

  void _hideStatusOverlay() {
    _statusOverlayEntry?.remove();
    _statusOverlayEntry = null;
  }

  void _showDetailOverlay(BuildContext context) {
    _detailOverlayEntry = createDetailOverlayEntry(
      context,
      widget.title,
      widget.status,
      widget.description,
      widget.assignee,
      widget.priority,
      widget.sprint,
      widget.created,
      widget.endTime,
      (status) {
        if (widget.isDraggable) {
          print(
              'IssueItem: Status changed in detail to $status for issue ${widget.id}');
          widget.onStatusChanged?.call(status);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Chỉ quản lý mới có thể thay đổi trạng thái.')),
          );
        }
      },
      (description) {
        print(
            'IssueItem: Description changed to $description for issue ${widget.id}');
        widget.onDescriptionChanged?.call(description);
      },
      (priority) {
        if (widget.isDraggable) {
          print(
              'IssueItem: Priority changed to $priority for issue ${widget.id}');
          widget.onPriorityChanged?.call(priority);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Chỉ quản lý mới có thể thay đổi ưu tiên.')),
          );
        }
      },
      (endTime) {
        if (widget.isDraggable) {
          print(
              'IssueItem: End time changed to $endTime for issue ${widget.id}');
          widget.onEndTimeChanged?.call(endTime);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Chỉ quản lý mới có thể thay đổi thời gian kết thúc.')),
          );
        }
      },
      (Assigne) {
        print('IssueItem: Assigne changed to $Assigne for issue ${widget.id}');
        widget.onAssigneChange?.call(Assigne);
      },
      _hideDetailOverlay,
    );
    Overlay.of(context).insert(_detailOverlayEntry!);
  }

  void _hideDetailOverlay() {
    _detailOverlayEntry?.remove();
    _detailOverlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final displayStatus = widget.status;

    Widget content = Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Icon(
            Icons.bug_report,
            size: 20,
            color: Colors.green,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              widget.title,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(width: 8),
          CompositedTransformTarget(
            link: _layerLink,
            child: GestureDetector(
              onTap: () => _toggleStatusOverlay(context),
              child: Text(
                displayStatus,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.person,
            size: 20,
            color: Colors.grey,
          ),
        ],
      ),
    );

    return GestureDetector(
      onTap: () => _showDetailOverlay(context),
      child: widget.isDraggable
          ? Draggable<Issue>(
              data: Issue(
                issueId: widget.id, // Sử dụng id thực
                projectId: widget.projectId,
                title: widget.title,
                description: widget.description,
                status: widget.status,
                priority: widget.priority,
                assigneeId: int.tryParse(widget.assignee),
                created: DateTime.tryParse(widget.created) ?? DateTime.now(),
                endTime: widget.endTime.isEmpty
                    ? null
                    : DateTime.tryParse(widget.endTime),
                sprintId: null,
              ),
              feedback: Material(
                elevation: 4.0,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 16,
                  child: content,
                ),
              ),
              childWhenDragging: Opacity(
                opacity: 0.3,
                child: content,
              ),
              onDragStarted: () {
                print('IssueItem: Dragging issue ${widget.id}');
              },
              child: content,
            )
          : content,
    );
  }

  @override
  void dispose() {
    _hideStatusOverlay();
    _hideDetailOverlay();
    super.dispose();
  }
}
