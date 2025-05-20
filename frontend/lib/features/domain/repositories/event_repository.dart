import 'package:doan/features/domain/entities/event.dart';

abstract class EventRepository {
  Future<List<Event>> getEventsByProject(int projectId);
  Future<Event> createEvent(Event event);
  Future<Event> updateEvent(Event event);
  Future<void> deleteEvent(int eventId);
}