import 'package:doan/features/domain/entities/issue.dart';
import 'package:doan/features/presentation/blocs/user_project_bloc.dart';
import 'package:doan/features/presentation/widgets/backLogPage/component/issues_item_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

OverlayEntry createIssueOverlayEntry(
  BuildContext context,
  Function(Issue) onSave,
  VoidCallback onCancel,
  int projectId,
  int sprintId,
) {
  OverlayEntry? statusOverlayEntry;
  OverlayEntry? priorityOverlayEntry;
  OverlayEntry? dateOverlayEntry;
  OverlayEntry? assigneeOverlayEntry;
  final LayerLink statusLayerLink = LayerLink();
  final LayerLink priorityLayerLink = LayerLink();
  final LayerLink dateLayerLink = LayerLink();
  final LayerLink assigneeLayerLink = LayerLink();
  final ValueNotifier<String> currentTitle = ValueNotifier('');
  final ValueNotifier<String> currentDescription = ValueNotifier('');
  final ValueNotifier<String> currentStatus = ValueNotifier('ToDo');
  final ValueNotifier<String> currentPriority = ValueNotifier('Medium');
  final ValueNotifier<String> currentEndTime = ValueNotifier('');
  final ValueNotifier<String> currentAssignee = ValueNotifier('');

  // Khởi tạo TextEditingController
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  // Đồng bộ giá trị ban đầu
  titleController.text = currentTitle.value;
  descriptionController.text = currentDescription.value;

  void toggleStatusOverlay() {
    if (statusOverlayEntry != null) {
      statusOverlayEntry?.remove();
      statusOverlayEntry = null;
    } else {
      statusOverlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          width: 120,
          child: CompositedTransformFollower(
            link: statusLayerLink,
            showWhenUnlinked: false,
            offset: const Offset(0, 24),
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(4.0),
              child: Column(
                children: [
                  buildStatusOption(context, 'ToDo', (selectedStatus) {
                    currentStatus.value = selectedStatus;
                    statusOverlayEntry?.remove();
                    statusOverlayEntry = null;
                  }),
                  buildStatusOption(context, 'InProgress', (selectedStatus) {
                    currentStatus.value = selectedStatus;
                    statusOverlayEntry?.remove();
                    statusOverlayEntry = null;
                  }),
                  buildStatusOption(context, 'Done', (selectedStatus) {
                    currentStatus.value = selectedStatus;
                    statusOverlayEntry?.remove();
                    statusOverlayEntry = null;
                  }),
                ],
              ),
            ),
          ),
        ),
      );
      Overlay.of(context).insert(statusOverlayEntry!);
    }
  }

  void togglePriorityOverlay() {
    if (priorityOverlayEntry != null) {
      priorityOverlayEntry?.remove();
      priorityOverlayEntry = null;
    } else {
      priorityOverlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          width: 120,
          child: CompositedTransformFollower(
            link: priorityLayerLink,
            showWhenUnlinked: false,
            offset: const Offset(0, 24),
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(4.0),
              child: Column(
                children: [
                  buildPriorityOption(context, 'Low', (selectedPriority) {
                    currentPriority.value = selectedPriority;
                    priorityOverlayEntry?.remove();
                    priorityOverlayEntry = null;
                  }),
                  buildPriorityOption(context, 'Medium', (selectedPriority) {
                    currentPriority.value = selectedPriority;
                    priorityOverlayEntry?.remove();
                    priorityOverlayEntry = null;
                  }),
                  buildPriorityOption(context, 'High', (selectedPriority) {
                    currentPriority.value = selectedPriority;
                    priorityOverlayEntry?.remove();
                    priorityOverlayEntry = null;
                  }),
                ],
              ),
            ),
          ),
        ),
      );
      Overlay.of(context).insert(priorityOverlayEntry!);
    }
  }

  void toggleDateOverlay() {
    if (dateOverlayEntry != null) {
      dateOverlayEntry?.remove();
      dateOverlayEntry = null;
    } else {
      dateOverlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          width: 300,
          child: CompositedTransformFollower(
            link: dateLayerLink,
            showWhenUnlinked: false,
            offset: const Offset(0, 24),
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(4.0),
              child: ValueListenableBuilder<DateTime>(
                valueListenable: ValueNotifier<DateTime>(DateTime.now()),
                builder: (context, value, child) {
                  return buildCalendar(context, value, (newDate) {
                    final formattedDate = newDate.toIso8601String();
                    currentEndTime.value = formattedDate;
                    dateOverlayEntry?.remove();
                    dateOverlayEntry = null;
                  });
                },
              ),
            ),
          ),
        ),
      );
      Overlay.of(context).insert(dateOverlayEntry!);
    }
  }

  void toggleAssigneeOverlay() {
    final blocContext = context;
    if (assigneeOverlayEntry != null) {
      assigneeOverlayEntry?.remove();
      assigneeOverlayEntry = null;
    } else {
      assigneeOverlayEntry = OverlayEntry(
          builder: (context) => Positioned(
                width: 200,
                child: CompositedTransformFollower(
                  link: assigneeLayerLink,
                  showWhenUnlinked: false,
                  offset: const Offset(0, 24),
                  child: Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(4.0),
                    child: BlocProvider.value(
                      value: BlocProvider.of<UserProjectBloc>(blocContext),
                      child: BlocBuilder<UserProjectBloc, UserProjectState>(
                        builder: (context, state) {
                          if (state is UserProjectLoading) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          } else if (state is UserProjectsLoaded) {
                            return Column(
                              children: state.userProjects.isEmpty
                                  ? [
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('No members'),
                                      ),
                                    ]
                                  : state.userProjects.map((member) {
                                      return ListTile(
                                        title: Text('User ${member.userId}'),
                                        subtitle: Text(member.isManager
                                            ? 'Manager'
                                            : 'Member'),
                                        onTap: () {
                                          currentAssignee.value =
                                              member.userId.toString();
                                          assigneeOverlayEntry?.remove();
                                          assigneeOverlayEntry = null;
                                        },
                                      );
                                    }).toList(),
                            );
                          } else {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Failed to load members'),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ));
      Overlay.of(context).insert(assigneeOverlayEntry!);
    }
  }

  return OverlayEntry(
    builder: (context) => GestureDetector(
      onTap: () {
        statusOverlayEntry?.remove();
        priorityOverlayEntry?.remove();
        dateOverlayEntry?.remove();
        assigneeOverlayEntry?.remove();
        onCancel();
      },
      child: Material(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Create New Issue',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            statusOverlayEntry?.remove();
                            priorityOverlayEntry?.remove();
                            dateOverlayEntry?.remove();
                            assigneeOverlayEntry?.remove();
                            onCancel();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title *',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                      ),
                      maxLength: 16, // Limit to 16 characters
                      onChanged: (newValue) {
                        currentTitle.value = newValue;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                      ),
                      maxLines: 3,
                      onChanged: (newValue) {
                        currentDescription.value = newValue;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        CompositedTransformTarget(
                          link: statusLayerLink,
                          child: GestureDetector(
                            onTap: toggleStatusOverlay,
                            child: ValueListenableBuilder<String>(
                              valueListenable: currentStatus,
                              builder: (context, value, child) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey[400]!),
                                    borderRadius: BorderRadius.circular(4.0),
                                    color: Colors.grey[100],
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        value,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.arrow_drop_down,
                                        size: 20,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CompositedTransformTarget(
                      link: assigneeLayerLink,
                      child: GestureDetector(
                        onTap: toggleAssigneeOverlay,
                        child: ValueListenableBuilder<String>(
                          valueListenable: currentAssignee,
                          builder: (context, value, child) {
                            return buildDetailRow(
                              'Assignee',
                              value.isEmpty ? 'Select Assignee' : 'User $value',
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    CompositedTransformTarget(
                      link: priorityLayerLink,
                      child: GestureDetector(
                        onTap: togglePriorityOverlay,
                        child: ValueListenableBuilder<String>(
                          valueListenable: currentPriority,
                          builder: (context, value, child) {
                            return buildDetailRow('Priority', value);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    CompositedTransformTarget(
                      link: dateLayerLink,
                      child: GestureDetector(
                        onTap: toggleDateOverlay,
                        child: ValueListenableBuilder<String>(
                          valueListenable: currentEndTime,
                          builder: (context, value, child) {
                            return buildDetailRow(
                              'End Time',
                              value.isEmpty
                                  ? 'Select Date'
                                  : formatDisplayDate(value),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            statusOverlayEntry?.remove();
                            priorityOverlayEntry?.remove();
                            dateOverlayEntry?.remove();
                            assigneeOverlayEntry?.remove();
                            onCancel();
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            if (currentTitle.value.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Title is required'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            final issue = Issue(
                              issueId: 0,
                              projectId: projectId,
                              title: currentTitle.value,
                              description: currentDescription.value.isEmpty
                                  ? null
                                  : currentDescription.value,
                              status: currentStatus.value,
                              priority: currentPriority.value,
                              assigneeId: currentAssignee.value.isEmpty
                                  ? 0
                                  : int.parse(currentAssignee.value),
                              created: DateTime.now(),
                              endTime: currentEndTime.value.isEmpty
                                  ? null
                                  : DateTime.parse(currentEndTime.value),
                              sprintId: sprintId,
                            );
                            print('Creating issue: $issue');
                            onSave(issue);
                            statusOverlayEntry?.remove();
                            priorityOverlayEntry?.remove();
                            dateOverlayEntry?.remove();
                            assigneeOverlayEntry?.remove();
                            onCancel();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}