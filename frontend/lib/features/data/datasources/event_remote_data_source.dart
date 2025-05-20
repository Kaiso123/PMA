import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:doan/features/data/models/event_model.dart';

class EventRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'http://192.168.170.200:7105/events';

  EventRemoteDataSource({required this.client});

  // Lấy danh sách sự kiện theo projectId
  Future<List<EventModel>> getEventsByProject(int projectId) async {
    final response = await client.get(
      Uri.parse('$baseUrl/project/$projectId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      // Kiểm tra xem 'data' có tồn tại và là một danh sách không
      if (jsonMap['data'] is List<dynamic>) {
        final List<dynamic> jsonList = jsonMap['data'];
        return jsonList.map((json) => EventModel.fromJson(json)).toList();
      } else if (jsonMap['data'] == "") {
        // Trả về một danh sách chứa một EventModel rỗng
        return [EventModel()];
      } else {
        // Nếu 'data' là một kiểu không mong muốn, trả về một danh sách chứa một EventModel rỗng
        return [EventModel()];
      }
    } else {
      throw Exception('Failed to get event: ${response.body}');
    }
  }

  // Tạo sự kiện mới
  Future<EventModel> createEvent(EventModel event) async {
    final response = await client.post(
      Uri.parse('$baseUrl/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(event.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      final jsonData = jsonMap['data'];

      // Kiểm tra kiểu của jsonData
      if (jsonData is int) {
        // Nếu server trả về một int (EventId), tạo EventModel mới với eventId được cập nhật
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
        // Nếu server trả về một Map, sử dụng EventModel.fromJson như bình thường
        return EventModel.fromJson(jsonData);
      } else {
        throw Exception('Unexpected data format in response: ${response.body}');
      }
    } else {
      throw Exception('Failed to create event: ${response.body}');
    }
  }

  // Cập nhật sự kiện
  // Cập nhật sự kiện
  Future<EventModel> updateEvent(EventModel event) async {
    final response = await client.put(
      Uri.parse('$baseUrl/update'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(event.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      final jsonData = jsonMap['data'];

      // Kiểm tra kiểu của jsonData
      if (jsonData is int) {
        // Nếu server trả về một int (EventId), tạo EventModel mới với các giá trị từ event đầu vào
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
        // Nếu server trả về một Map, sử dụng EventModel.fromJson như bình thường
        return EventModel.fromJson(jsonData);
      } else {
        throw Exception('Unexpected data format in response: ${response.body}');
      }
    } else {
      throw Exception('Failed to update event: ${response.body}');
    }
  }

  // Xóa sự kiện
  Future<void> deleteEvent(int eventId) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/$eventId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete event: ${response.body}');
    }
  }
}
