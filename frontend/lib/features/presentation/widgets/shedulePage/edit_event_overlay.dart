import 'package:doan/features/presentation/widgets/shedulePage/event_overlay_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doan/features/domain/entities/event.dart';
import 'package:doan/features/presentation/blocs/user_project_bloc.dart';
import 'package:intl/intl.dart';

OverlayEntry editEventOverlayEntry(
  BuildContext context,
  Event event,
  Function(Event) onSave,
  VoidCallback onCancel,
) {
  OverlayEntry? createdDateOverlayEntry;
  OverlayEntry? endDateOverlayEntry;
  OverlayEntry? colorOverlayEntry;
  OverlayEntry? attendeesOverlayEntry;
  OverlayEntry? mainOverlayEntry; // Lưu trữ OverlayEntry chính của form
  final LayerLink createdDateLayerLink = LayerLink();
  final LayerLink endDateLayerLink = LayerLink();
  final LayerLink colorLayerLink = LayerLink();
  final LayerLink attendeesLayerLink = LayerLink();
  final ValueNotifier<String> currentTitle = ValueNotifier(event.title!);
  final ValueNotifier<String> currentDescription = ValueNotifier(event.description ?? '');
  final ValueNotifier<String> currentLocation = ValueNotifier(event.location ?? '');
  final ValueNotifier<bool> currentIsAllDay = ValueNotifier(event.isAllDay!);
  final ValueNotifier<Color> currentColor = ValueNotifier(
    event.color != null && event.color!.isNotEmpty
        ? Color(int.parse('FF${event.color!.replaceFirst("#", "")}', radix: 16))
        : Colors.red,
  );
  final ValueNotifier<String> currentCreated = ValueNotifier(event.startTime!.toIso8601String());
  final ValueNotifier<String> currentEndTime = ValueNotifier(event.endTime!.toIso8601String());
  final ValueNotifier<DateTime> selectedCreatedDate = ValueNotifier(event.startTime!);
  final ValueNotifier<DateTime> selectedEndDate = ValueNotifier(event.endTime!);
  final ValueNotifier<List<int>> currentUserIds = ValueNotifier(event.userIds!);

  // Khởi tạo TextEditingController
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();

  // Đồng bộ giá trị ban đầu
  titleController.text = currentTitle.value;
  descriptionController.text = currentDescription.value;
  locationController.text = currentLocation.value;

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CalendarDatePicker(
                    initialDate: selectedCreatedDate.value,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    onDateChanged: (newDate) async {
                      // Lưu ngày được chọn
                      final tempDate = DateTime(
                        newDate.year,
                        newDate.month,
                        newDate.day,
                        selectedCreatedDate.value.hour,
                        selectedCreatedDate.value.minute,
                      );

                      // Ẩn overlay chính để TimePicker hiển thị phía trên
                      mainOverlayEntry?.remove();

                      // Hiển thị TimePicker để chọn giờ
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(selectedCreatedDate.value),
                      );

                      // Hiển thị lại overlay chính sau khi TimePicker đóng
                      if (mainOverlayEntry != null) {
                        Overlay.of(context).insert(mainOverlayEntry);
                      }

                      if (pickedTime != null) {
                        // Cập nhật ngày và giờ
                        selectedCreatedDate.value = DateTime(
                          tempDate.year,
                          tempDate.month,
                          tempDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                        currentCreated.value = selectedCreatedDate.value.toIso8601String();
                      } else {
                        // Nếu không chọn giờ, chỉ cập nhật ngày
                        selectedCreatedDate.value = tempDate;
                        currentCreated.value = tempDate.toIso8601String();
                      }

                      createdDateOverlayEntry?.remove();
                      createdDateOverlayEntry = null;
                    },
                  ),
                ],
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CalendarDatePicker(
                    initialDate: selectedEndDate.value,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                    onDateChanged: (newDate) async {
                      // Lưu ngày được chọn
                      final tempDate = DateTime(
                        newDate.year,
                        newDate.month,
                        newDate.day,
                        selectedEndDate.value.hour,
                        selectedEndDate.value.minute,
                      );

                      // Ẩn overlay chính để TimePicker hiển thị phía trên
                      mainOverlayEntry?.remove();

                      // Hiển thị TimePicker để chọn giờ
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(selectedEndDate.value),
                      );

                      // Hiển thị lại overlay chính sau khi TimePicker đóng
                      if (mainOverlayEntry != null) {
                        Overlay.of(context).insert(mainOverlayEntry);
                      }

                      if (pickedTime != null) {
                        // Cập nhật ngày và giờ
                        selectedEndDate.value = DateTime(
                          tempDate.year,
                          tempDate.month,
                          tempDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                        currentEndTime.value = selectedEndDate.value.toIso8601String();
                      } else {
                        // Nếu không chọn giờ, chỉ cập nhật ngày
                        selectedEndDate.value = tempDate;
                        currentEndTime.value = tempDate.toIso8601String();
                      }

                      endDateOverlayEntry?.remove();
                      endDateOverlayEntry = null;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      Overlay.of(context).insert(endDateOverlayEntry!);
    }
  }

  void toggleColorOverlay() {
    if (colorOverlayEntry != null) {
      colorOverlayEntry?.remove();
      colorOverlayEntry = null;
    } else {
      colorOverlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          width: 300,
          child: CompositedTransformFollower(
            link: colorLayerLink,
            showWhenUnlinked: false,
            offset: const Offset(0, 24),
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(4.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ColorPicker(
                    pickerColor: currentColor.value,
                    onColorChanged: (color) {
                      currentColor.value = color;
                    },
                    showLabel: false,
                    pickerAreaHeightPercent: 0.8,
                    enableAlpha: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        colorOverlayEntry?.remove();
                        colorOverlayEntry = null;
                      },
                      child: const Text('Select'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      Overlay.of(context).insert(colorOverlayEntry!);
    }
  }

  void toggleAttendeesOverlay() {
    final blocContext = context;
    if (attendeesOverlayEntry != null) {
      attendeesOverlayEntry?.remove();
      attendeesOverlayEntry = null;
    } else {
      attendeesOverlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          width: 200,
          child: CompositedTransformFollower(
            link: attendeesLayerLink,
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
                        mainAxisSize: MainAxisSize.min,
                        children: state.userProjects.isEmpty
                            ? [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('No members'),
                                ),
                              ]
                            : [
                                ...state.userProjects.map((member) {
                                  return ValueListenableBuilder<List<int>>(
                                    valueListenable: currentUserIds,
                                    builder: (context, selectedIds, child) {
                                      final isSelected = selectedIds.contains(member.userId);
                                      return ListTile(
                                        title: Text('User ${member.userId}'),
                                        subtitle: Text(member.isManager ? 'Manager' : 'Member'),
                                        trailing: Checkbox(
                                          value: isSelected,
                                          onChanged: (value) {
                                            if (value == true) {
                                              currentUserIds.value = [...selectedIds, member.userId!];
                                            } else {
                                              currentUserIds.value = selectedIds.where((id) => id != member.userId).toList();
                                            }
                                          },
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      attendeesOverlayEntry?.remove();
                                      attendeesOverlayEntry = null;
                                    },
                                    child: const Text('Done'),
                                  ),
                                ),
                              ],
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
        ),
      );
      Overlay.of(context).insert(attendeesOverlayEntry!);
    }
  }

  mainOverlayEntry = OverlayEntry(
    builder: (context) => GestureDetector(
      onTap: () {
        createdDateOverlayEntry?.remove();
        endDateOverlayEntry?.remove();
        colorOverlayEntry?.remove();
        attendeesOverlayEntry?.remove();
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
                            'Edit Event',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            createdDateOverlayEntry?.remove();
                            endDateOverlayEntry?.remove();
                            colorOverlayEntry?.remove();
                            attendeesOverlayEntry?.remove();
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
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      ),
                      onChanged: (newValue) {
                        currentTitle.value = newValue;
                      },
                      maxLength: 16,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      ),
                      maxLines: 3,
                      onChanged: (newValue) {
                        currentDescription.value = newValue;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      ),
                      onChanged: (newValue) {
                        currentLocation.value = newValue;
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('All Day: '),
                        ValueListenableBuilder<bool>(
                          valueListenable: currentIsAllDay,
                          builder: (context, value, child) {
                            return Checkbox(
                              value: value,
                              onChanged: (newValue) {
                                currentIsAllDay.value = newValue ?? false;
                              },
                            );
                          },
                        ),
                      ],
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
                              'Start Time',
                              DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(value)),
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
                              DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(value)),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    CompositedTransformTarget(
                      link: colorLayerLink,
                      child: GestureDetector(
                        onTap: toggleColorOverlay,
                        child: ValueListenableBuilder<Color>(
                          valueListenable: currentColor,
                          builder: (context, value, child) {
                            return buildDetailRow(
                              'Color',
                              '#${value.value.toRadixString(16).padLeft(8, '0').substring(2)}',
                              color: value,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    CompositedTransformTarget(
                      link: attendeesLayerLink,
                      child: GestureDetector(
                        onTap: toggleAttendeesOverlay,
                        child: ValueListenableBuilder<List<int>>(
                          valueListenable: currentUserIds,
                          builder: (context, value, child) {
                            return buildDetailRow(
                              'Attendees',
                              value.isEmpty ? 'Select Attendees' : value.join(', '),
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
                            createdDateOverlayEntry?.remove();
                            endDateOverlayEntry?.remove();
                            colorOverlayEntry?.remove();
                            attendeesOverlayEntry?.remove();
                            onCancel();
                          },
                          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
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
                            final updatedEvent = Event(
                              eventId: event.eventId,
                              title: currentTitle.value,
                              description: currentDescription.value.isEmpty ? null : currentDescription.value,
                              startTime: DateTime.parse(currentCreated.value),
                              endTime: DateTime.parse(currentEndTime.value),
                              location: currentLocation.value.isEmpty ? null : currentLocation.value,
                              isAllDay: currentIsAllDay.value,
                              color: '#${currentColor.value.value.toRadixString(16).padLeft(8, '0').substring(2)}',
                              projectId: event.projectId,
                              createdBy: event.createdBy,
                              createdAt: event.createdAt,
                              userIds: currentUserIds.value,
                            );
                            onSave(updatedEvent);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Save'),
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

  return mainOverlayEntry;
}