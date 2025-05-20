import 'package:doan/features/presentation/widgets/shedulePage/creat_event_overlay.dart';
import 'package:doan/features/presentation/widgets/shedulePage/delete_event_overlay.dart';
import 'package:doan/features/presentation/widgets/shedulePage/edit_event_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:doan/features/domain/entities/event.dart';
import 'package:doan/features/domain/entities/project.dart';
import 'package:doan/features/presentation/blocs/event_bloc.dart';
import 'package:intl/intl.dart';

class SchedulePage extends StatelessWidget {
  final Project project;
  const SchedulePage({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<EventBloc, EventState>(
        builder: (context, state) {
          if (state is EventLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is EventError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is EventsLoaded) {
            final validEvents = state.events
                .where((event) => event.startTime != null && event.endTime != null)
                .toList();

            return SfCalendar(
              backgroundColor: Colors.white,
              view: CalendarView.month,
              dataSource: validEvents.isEmpty ? null : EventDataSource(validEvents),
              scheduleViewSettings: ScheduleViewSettings(
                appointmentItemHeight: 70,
                monthHeaderSettings: MonthHeaderSettings(
                  monthFormat: 'MMMM, yyyy',
                  height: 100,
                  textAlign: TextAlign.left,
                ),
              ),
              monthViewSettings: const MonthViewSettings(
                agendaItemHeight: 70,
                appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                showAgenda: true,
                dayFormat: 'EEE',
              ),
              appointmentBuilder: (context, calendarAppointmentDetails) {
                final event =
                    calendarAppointmentDetails.appointments.first as Event;
                Color color;
                final hexColor = event.color;
                if (hexColor == null || hexColor.isEmpty) {
                  color = Colors.blue;
                } else {
                  try {
                    color = Color(int.parse(
                        'FF${hexColor.replaceFirst("#", "")}',
                        radix: 16));
                  } catch (e) {
                    color = Colors.blue;
                  }
                }
                final startTime =
                    DateFormat('hh:mm a').format(event.startTime!);
                final endTime = DateFormat('hh:mm a').format(event.endTime!);

                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '$startTime - $endTime',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              onTap: (calendarTapDetails) {
                if (calendarTapDetails.appointments != null &&
                    calendarTapDetails.appointments!.isNotEmpty) {
                  final event = calendarTapDetails.appointments!.first as Event;
                  _showEventDetails(context, event);
                }
              },
              allowedViews: const [
                CalendarView.month,
                CalendarView.schedule,
              ],
              timeSlotViewSettings: const TimeSlotViewSettings(
                timeInterval: Duration(minutes: 30),
                timeFormat: 'HH:mm',
              ),
            );
          }
          return const Center(child: Text('Please wait...'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (project.isManager!) {
            _showCreateEventOverlay(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Chỉ quản lý mới có thể tạo sự kiện.')),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateEventOverlay(BuildContext context) {
    OverlayEntry? overlayEntry;
    overlayEntry = createEventOverlayEntry(
      context,
      project,
      (newEvent) {
        context.read<EventBloc>().add(CreateEventEvent(newEvent));
        overlayEntry?.remove();
      },
      () {
        overlayEntry?.remove();
      },
    );
    Overlay.of(context).insert(overlayEntry);
  }

  void _showEventDetails(BuildContext parentContext, Event event) {
    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.black.withOpacity(0.5),
        child: Center(
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(event.title!,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => overlayEntry?.remove(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Description: ${event.description ?? "N/A"}'),
                Text('Location: ${event.location ?? "N/A"}'),
                Text(
                    'Start: ${DateFormat('yyyy-MM-dd HH:mm').format(event.startTime!)}'),
                Text(
                    'End: ${DateFormat('yyyy-MM-dd HH:mm').format(event.endTime!)}'),
                Text('All Day: ${event.isAllDay! ? "Yes" : "No"}'),
                Text('Attendees: ${event.userIds!.join(", ")}'),
                Text('Created By: ${event.createdBy}'),
                Text(
                    'Created At: ${DateFormat('yyyy-MM-dd HH:mm').format(event.createdAt!)}'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(width: 8),
                    project.isManager!
                        ? ElevatedButton(
                            onPressed: () {
                              overlayEntry?.remove();
                              _showEditEventOverlay(parentContext, event);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Edit'),
                          )
                        : SizedBox.shrink(),
                    const SizedBox(width: 8),
                    project.isManager!
                        ? ElevatedButton(
                            onPressed: () {
                              overlayEntry?.remove();
                              _showDeleteEventOverlay(parentContext, event);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Delete'),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    Overlay.of(parentContext).insert(overlayEntry);
  }

  void _showEditEventOverlay(BuildContext parentContext, Event event) {
    OverlayEntry? overlayEntry;
    overlayEntry = editEventOverlayEntry(
      parentContext,
      event,
      (updatedEvent) {
        parentContext.read<EventBloc>().add(UpdateEventEvent(updatedEvent));
        overlayEntry?.remove();
      },
      () {
        overlayEntry?.remove();
      },
    );
    Overlay.of(parentContext).insert(overlayEntry);
  }

  void _showDeleteEventOverlay(BuildContext parentContext, Event event) {
    OverlayEntry? overlayEntry;
    overlayEntry = deleteEventOverlayEntry(
      parentContext,
      event,
      () {
        parentContext
            .read<EventBloc>()
            .add(DeleteEventEvent(event.eventId!, project.projectId!));
        overlayEntry?.remove();
      },
      () {
        overlayEntry?.remove();
      },
    );
    Overlay.of(parentContext).insert(overlayEntry);
  }
}

// DataSource cho SfCalendar
class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> events) {
    appointments = events;
  }

  @override
  DateTime getStartTime(int index) => appointments![index].startTime;

  @override
  DateTime getEndTime(int index) => appointments![index].endTime;

  @override
  String getSubject(int index) => appointments![index].title;

  @override
  Color getColor(int index) {
    final hexColor = appointments![index].color;
    if (hexColor == null || hexColor.isEmpty) {
      return Colors.blue;
    }
    try {
      return Color(int.parse('FF${hexColor.replaceFirst("#", "")}', radix: 16));
    } catch (e) {
      return Colors.blue;
    }
  }

  @override
  bool isAllDay(int index) => appointments![index].isAllDay;
}
