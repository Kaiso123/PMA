import 'package:doan/features/domain/entities/sprint.dart';
import 'package:doan/features/presentation/widgets/backLogPage/component/issues_item_components.dart';
import 'package:flutter/material.dart';

OverlayEntry createSprintOverlayEntry(
  BuildContext context,
  Function(Sprint) onSave,
  VoidCallback onCancel,
  int projectId,
) {
  OverlayEntry? statusOverlayEntry;
  OverlayEntry? priorityOverlayEntry;
  OverlayEntry? createdDateOverlayEntry;
  OverlayEntry? endDateOverlayEntry;
  final LayerLink statusLayerLink = LayerLink();
  final LayerLink priorityLayerLink = LayerLink();
  final LayerLink createdDateLayerLink = LayerLink();
  final LayerLink endDateLayerLink = LayerLink();
  final ValueNotifier<String> currentName = ValueNotifier('');
  final ValueNotifier<String> currentDescription = ValueNotifier('');
  final ValueNotifier<String> currentStatus = ValueNotifier('ToDo');
  final ValueNotifier<String> currentPriority = ValueNotifier('Medium');
  final ValueNotifier<String> currentCreated = ValueNotifier(DateTime.now().toIso8601String());
  final ValueNotifier<String> currentEndTime = ValueNotifier('');
  final ValueNotifier<DateTime> selectedCreatedDate = ValueNotifier(DateTime.now());
  final ValueNotifier<DateTime> selectedEndDate = ValueNotifier(DateTime.now());

  // Khởi tạo TextEditingController
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  // Đồng bộ giá trị ban đầu
  nameController.text = currentName.value;
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

  void toggleCreatedDateOverlay() {
    if (createdDateOverlayEntry != null) {
      createdDateOverlayEntry?.remove();
      createdDateOverlayEntry = null;
    } else {
      createdDateOverlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          width: 300,
          child: CompositedTransformFollower(
            link: createdDateLayerLink,
            showWhenUnlinked: false,
            offset: const Offset(0, 24),
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(4.0),
              child: ValueListenableBuilder<DateTime>(
                valueListenable: selectedCreatedDate,
                builder: (context, value, child) {
                  return buildCalendar(context, value, (newDate) {
                    selectedCreatedDate.value = newDate;
                    currentCreated.value = newDate.toIso8601String();
                    createdDateOverlayEntry?.remove();
                    createdDateOverlayEntry = null;
                  });
                },
              ),
            ),
          ),
        ),
      );
      Overlay.of(context).insert(createdDateOverlayEntry!);
    }
  }

  void toggleEndDateOverlay() {
    if (endDateOverlayEntry != null) {
      endDateOverlayEntry?.remove();
      endDateOverlayEntry = null;
    } else {
      endDateOverlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          width: 300,
          child: CompositedTransformFollower(
            link: endDateLayerLink,
            showWhenUnlinked: false,
            offset: const Offset(0, 24),
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(4.0),
              child: ValueListenableBuilder<DateTime>(
                valueListenable: selectedEndDate,
                builder: (context, value, child) {
                  return buildCalendar(context, value, (newDate) {
                    selectedEndDate.value = newDate;
                    currentEndTime.value = newDate.toIso8601String();
                    endDateOverlayEntry?.remove();
                    endDateOverlayEntry = null;
                  });
                },
              ),
            ),
          ),
        ),
      );
      Overlay.of(context).insert(endDateOverlayEntry!);
    }
  }

  return OverlayEntry(
    builder: (context) => GestureDetector(
      onTap: () {
        statusOverlayEntry?.remove();
        priorityOverlayEntry?.remove();
        createdDateOverlayEntry?.remove();
        endDateOverlayEntry?.remove();
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
                            'Create New Sprint',
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
                            createdDateOverlayEntry?.remove();
                            endDateOverlayEntry?.remove();
                            onCancel();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Sprint Name *',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                      ),
                      maxLength: 16,
                      onChanged: (newValue) {
                        currentName.value = newValue;
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
                                    border: Border.all(color: Colors.grey[400]!),
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
                      link: createdDateLayerLink,
                      child: GestureDetector(
                        onTap: toggleCreatedDateOverlay,
                        child: ValueListenableBuilder<String>(
                          valueListenable: currentCreated,
                          builder: (context, value, child) {
                            return buildDetailRow(
                              'Created',
                              formatDisplayDate(value),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    CompositedTransformTarget(
                      link: endDateLayerLink,
                      child: GestureDetector(
                        onTap: toggleEndDateOverlay,
                        child: ValueListenableBuilder<String>(
                          valueListenable: currentEndTime,
                          builder: (context, value, child) {
                            return buildDetailRow(
                              'End Time',
                              value.isEmpty ? 'Select Date' : formatDisplayDate(value),
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
                            createdDateOverlayEntry?.remove();
                            endDateOverlayEntry?.remove();
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
                            if (currentName.value.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Sprint name is required'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            final newSprint = Sprint(
                              id: 0, // ID will be assigned by backend
                              projectId: projectId,
                              name: currentName.value,
                              description: currentDescription.value.isEmpty
                                  ? null
                                  : currentDescription.value,
                              created: DateTime.parse(currentCreated.value),
                              endTime: currentEndTime.value.isEmpty
                                  ? null
                                  : DateTime.parse(currentEndTime.value),
                              status: currentStatus.value,
                              priority: currentPriority.value,
                              issues: [],
                            );
                            print(projectId);
                            print('Creating sprint: $newSprint');
                            onSave(newSprint);
                            statusOverlayEntry?.remove();
                            priorityOverlayEntry?.remove();
                            createdDateOverlayEntry?.remove();
                            endDateOverlayEntry?.remove();
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