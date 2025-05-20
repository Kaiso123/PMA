import 'package:doan/features/presentation/widgets/backLogPage/component/issues_item_components.dart';
import 'package:flutter/material.dart';

OverlayEntry createDetailOverlayEntry(
  BuildContext context,
  String title,
  String status,
  String description,
  String assignee,
  String priority,
  String sprint,
  String created,
  String endTime,
  Function(String)? onStatusChanged,
  Function(String)? onDescriptionChanged,
  Function(String)? onPriorityChanged,
  Function(String)? onEndTimeChanged,
  VoidCallback onClose,
) {
  final normalizedStatus = normalizeStatus(status);
  OverlayEntry? statusOverlayEntry;
  OverlayEntry? priorityOverlayEntry;
  OverlayEntry? dateOverlayEntry;
  final LayerLink statusLayerLink = LayerLink();
  final LayerLink priorityLayerLink = LayerLink();
  final LayerLink dateLayerLink = LayerLink();
  final ValueNotifier<String> currentStatus = ValueNotifier(normalizedStatus);
  final ValueNotifier<String> currentDescription = ValueNotifier(description);
  final ValueNotifier<String> currentPriority = ValueNotifier(priority);
  final ValueNotifier<String> currentEndTime = ValueNotifier(endTime);
  final ValueNotifier<DateTime> selectedDate = ValueNotifier(
    endTime.isNotEmpty ? DateTime.tryParse(endTime) ?? DateTime.now() : DateTime.now(),
  );

  // Khởi tạo TextEditingController
  final descriptionController = TextEditingController();

  // Đồng bộ giá trị ban đầu
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
                    onStatusChanged?.call(selectedStatus);
                    statusOverlayEntry?.remove();
                    statusOverlayEntry = null;
                  }),
                  buildStatusOption(context, 'InProgress', (selectedStatus) {
                    currentStatus.value = selectedStatus;
                    onStatusChanged?.call(selectedStatus);
                    statusOverlayEntry?.remove();
                    statusOverlayEntry = null;
                  }),
                  buildStatusOption(context, 'Done', (selectedStatus) {
                    currentStatus.value = selectedStatus;
                    onStatusChanged?.call(selectedStatus);
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
                    onPriorityChanged?.call(selectedPriority);
                    priorityOverlayEntry?.remove();
                    priorityOverlayEntry = null;
                  }),
                  buildPriorityOption(context, 'Medium', (selectedPriority) {
                    currentPriority.value = selectedPriority;
                    onPriorityChanged?.call(selectedPriority);
                    priorityOverlayEntry?.remove();
                    priorityOverlayEntry = null;
                  }),
                  buildPriorityOption(context, 'High', (selectedPriority) {
                    currentPriority.value = selectedPriority;
                    onPriorityChanged?.call(selectedPriority);
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
            offset: const Offset(0, -100),
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(4.0),
              child: ValueListenableBuilder<DateTime>(
                valueListenable: selectedDate,
                builder: (context, value, child) {
                  return buildCalendar(context, value, (newDate) {
                    selectedDate.value = newDate;
                    final formattedDate = newDate.toIso8601String();
                    currentEndTime.value = formattedDate;
                    onEndTimeChanged?.call(formattedDate);
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

  return OverlayEntry(
    builder: (context) => GestureDetector(
      onTap: () {
        statusOverlayEntry?.remove();
        statusOverlayEntry = null;
        priorityOverlayEntry?.remove();
        priorityOverlayEntry = null;
        dateOverlayEntry?.remove();
        dateOverlayEntry = null;
        onClose();
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
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
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
                            onClose();
                          },
                        ),
                      ],
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
                        onDescriptionChanged?.call(newValue);
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
                    buildDetailRow('Assignee', assignee),
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
                    buildDetailRow('Sprint', sprint),
                    buildDetailRow('Created', created.split('T').first),
                    CompositedTransformTarget(
                      link: dateLayerLink,
                      child: GestureDetector(
                        onTap: toggleDateOverlay,
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
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          statusOverlayEntry?.remove();
                          priorityOverlayEntry?.remove();
                          dateOverlayEntry?.remove();
                          onClose();
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
                          'Close',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
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