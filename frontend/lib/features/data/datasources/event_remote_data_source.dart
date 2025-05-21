import 'package:doan/features/core/api_client.dart';
import 'package:doan/features/data/models/event_model.dart';
import 'package:doan/features/data/models/project_response_dto.dart';

class EventRemoteDataSource {
  static const String baseUrl = 'http://192.168.170.200:7105/events';
  final ApiClient apiClient;
  EventRemoteDataSource({required this.apiClient});

  // Lấy danh sách sự kiện theo projectId
  Future<List<EventModel>> getEventsByProject(int projectId) async {
    final response = await apiClient.get('events/project/$projectId');
    final projectResponse = ProjectResponseDto.fromJson(response);
    if (projectResponse.errorCode != 0) {
      throw Exception(projectResponse.errorMessage);
    }
    if (projectResponse.data is List<dynamic>) {
      return (projectResponse.data as List<dynamic>)
          .map((json) => EventModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else if (projectResponse.data == "") {
      return [EventModel()];
    } else {
      return [EventModel()];
    }
  }

  // Tạo sự kiện mới
  Future<EventModel> createEvent(EventModel event) async {
    final response = await apiClient.post('events/create', event.toJson());
    final projectResponse = ProjectResponseDto.fromJson(response);
    if (projectResponse.errorCode != 0) {
      throw Exception(projectResponse.errorMessage);
    }
    final jsonData = projectResponse.data;
    if (jsonData is int) {
      return EventModel(
        eventId: jsonData,
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
      );
    } else if (jsonData is Map<String, dynamic>) {
      return EventModel.fromJson(jsonData);
    } else {
      throw Exception(
          'Unexpected data format in response: ${response.toString()}');
    }
  }

  // Cập nhật sự kiện
  Future<EventModel> updateEvent(EventModel event) async {
    final response = await apiClient.put('events/update', event.toJson());
    final projectResponse = ProjectResponseDto.fromJson(response);
    if (projectResponse.errorCode != 0) {
      throw Exception(projectResponse.errorMessage);
    }
    final jsonData = projectResponse.data;
    if (jsonData is int) {
      return EventModel(
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
      );
    } else if (jsonData is Map<String, dynamic>) {
      return EventModel.fromJson(jsonData);
    } else {
      throw Exception(
          'Unexpected data format in response: ${response.toString()}');
    }
  }

  // Xóa sự kiện
  Future<void> deleteEvent(int eventId) async {
    final response = await apiClient.delete('events/$eventId');
    final projectResponse = ProjectResponseDto.fromJson(response);
    if (projectResponse.errorCode != 0) {
      throw Exception(projectResponse.errorMessage);
    }
  }
}
