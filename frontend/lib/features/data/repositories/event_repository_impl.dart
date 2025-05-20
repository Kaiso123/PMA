import 'package:doan/features/data/datasources/event_remote_data_source.dart';
import 'package:doan/features/data/models/event_model.dart';
import 'package:doan/features/domain/entities/event.dart';
import 'package:doan/features/domain/repositories/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;

  EventRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Event>> getEventsByProject(int projectId) async {
    try {
      final eventModels = await remoteDataSource.getEventsByProject(projectId);
      return eventModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Error fetching events by project: $e');
    }
  }

  @override
  Future<Event> createEvent(Event event) async {
    try {
      final eventModel = await remoteDataSource.createEvent(
        EventModel(
          eventId: event.eventId,
          title: event.title,
          description: event.description,
          startTime: event.startTime,
          endTime: event.endTime,
          location: event.location,
          isAllDay: event.isAllDay,
          color: event.color,
          projectId: event.projectId,
          createdBy: event.createdBy,
          createdAt: event.createdAt,
          userIds: event.userIds,
        ),
      );
      return eventModel.toEntity();
    } catch (e) {
      throw Exception('Error creating event: $e');
    }
  }

  @override
  Future<Event> updateEvent(Event event) async {
    try {
      final eventModel = await remoteDataSource.updateEvent(
        EventModel(
          eventId: event.eventId,
          title: event.title,
          description: event.description,
          startTime: event.startTime,
          endTime: event.endTime,
          location: event.location,
          isAllDay: event.isAllDay,
          color: event.color,
          projectId: event.projectId,
          createdBy: event.createdBy,
          createdAt: event.createdAt,
          userIds: event.userIds,
        ),
      );
      return eventModel.toEntity();
    } catch (e) {
      throw Exception('Error updating event: $e');
    }
  }

  @override
  Future<void> deleteEvent(int eventId) async {
    try {
      await remoteDataSource.deleteEvent(eventId);
    } catch (e) {
      throw Exception('Error deleting event: $e');
    }
  }
}