import 'package:doan/features/domain/entities/event.dart';
import 'package:doan/features/domain/repositories/event_repository.dart';

abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

// UseCase: Lấy danh sách sự kiện theo project
class GetEventsByProject implements UseCase<List<Event>, int> {
  final EventRepository repository;

  GetEventsByProject(this.repository);

  @override
  Future<List<Event>> call(int projectId) async {
    return await repository.getEventsByProject(projectId);
  }
}

// UseCase: Tạo sự kiện mới
class CreateEvent implements UseCase<Event, Event> {
  final EventRepository repository;

  CreateEvent(this.repository);

  @override
  Future<Event> call(Event event) async {
    return await repository.createEvent(event);
  }
}

// UseCase: Cập nhật sự kiện
class UpdateEvent implements UseCase<Event, Event> {
  final EventRepository repository;

  UpdateEvent(this.repository);

  @override
  Future<Event> call(Event event) async {
    return await repository.updateEvent(event);
  }
}

// UseCase: Xóa sự kiện
class DeleteEvent implements UseCase<void, int> {
  final EventRepository repository;

  DeleteEvent(this.repository);

  @override
  Future<void> call(int eventId) async {
    return await repository.deleteEvent(eventId);
  }
}