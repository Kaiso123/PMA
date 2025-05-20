import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doan/features/domain/entities/event.dart';
import 'package:doan/features/domain/usecases/event_usecase.dart';

// Event Events
abstract class EventEvent {}

class FetchEventsByProjectEvent extends EventEvent {
  final int projectId;
  FetchEventsByProjectEvent(this.projectId);
}

class CreateEventEvent extends EventEvent {
  final Event event;
  CreateEventEvent(this.event);
}

class UpdateEventEvent extends EventEvent {
  final Event event;
  UpdateEventEvent(this.event);
}

class DeleteEventEvent extends EventEvent {
  final int eventId;
  final int projectId;
  DeleteEventEvent(this.eventId, this.projectId);
}

// Event States
abstract class EventState {}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventsLoaded extends EventState {
  final List<Event> events;
  EventsLoaded(this.events);
}

class EventError extends EventState {
  final String message;
  EventError(this.message);
}

// Event Bloc
class EventBloc extends Bloc<EventEvent, EventState> {
  final GetEventsByProject getEventsByProject;
  final CreateEvent createEvent;
  final UpdateEvent updateEvent;
  final DeleteEvent deleteEvent;

  EventBloc({
    required this.getEventsByProject,
    required this.createEvent,
    required this.updateEvent,
    required this.deleteEvent,
  }) : super(EventInitial()) {
    on<FetchEventsByProjectEvent>(_onFetchEventsByProject);
    on<CreateEventEvent>(_onCreateEvent);
    on<UpdateEventEvent>(_onUpdateEvent);
    on<DeleteEventEvent>(_onDeleteEvent);
  }

  Future<void> _onFetchEventsByProject(
      FetchEventsByProjectEvent event, Emitter<EventState> emit) async {
    emit(EventLoading());
    try {
      final events = await getEventsByProject(event.projectId);
      emit(EventsLoaded(events));
    } catch (e) {
      emit(EventError('Failed to fetch events: $e'));
    }
  }

  Future<void> _onCreateEvent(
      CreateEventEvent event, Emitter<EventState> emit) async {
    emit(EventLoading());
    try {
      await createEvent(event.event);
      final events = await getEventsByProject(event.event.projectId!);
      emit(EventsLoaded(events));
    } catch (e) {
      emit(EventError('Failed to create event: $e'));
    }
  }

  Future<void> _onUpdateEvent(
      UpdateEventEvent event, Emitter<EventState> emit) async {
    emit(EventLoading());
    try {
      await updateEvent(event.event);
      final events = await getEventsByProject(event.event.projectId!);
      emit(EventsLoaded(events));
    } catch (e) {
      emit(EventError('Failed to update event: $e'));
    }
  }

  Future<void> _onDeleteEvent(
      DeleteEventEvent event, Emitter<EventState> emit) async {
    emit(EventLoading());
    try {
      await deleteEvent(event.eventId);
      final events = await getEventsByProject(event.projectId);
      emit(EventsLoaded(events));
    } catch (e) {
      emit(EventError('Failed to delete event: $e'));
    }
  }
}
