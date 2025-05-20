import 'package:doan/features/domain/entities/event.dart';

class EventModel {
  final int? eventId;
  final String? title;
  final String? description;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? location;
  final bool? isAllDay;
  final String? color; 
  final int? projectId;
  final int? createdBy;
  final DateTime? createdAt;
  final List<int>? userIds;

  EventModel({
    this.eventId,
    this.title,
    this.description,
    this.startTime,
    this.endTime,
    this.location,
    this.isAllDay,
    this.color,
    this.projectId,
    this.createdBy,
    this.createdAt,
    this.userIds,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventId: json['eventId'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime'] as String) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime'] as String) : null,
      location: json['location'] as String?,
      isAllDay: json['isAllDay'] as bool?,
      color: json['color'] as String?,
      projectId: json['projectId'] as int?,
      createdBy: json['createdBy'] as int?,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : null,
      userIds: (json['userIds'] as List<dynamic>?)?.cast<int>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'title': title,
      'description': description,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'location': location,
      'isAllDay': isAllDay,
      'color': color,
      'projectId': projectId,
      'createdBy': createdBy,
      'createdAt': createdAt?.toIso8601String(),
      'userIds': userIds,
    };
  }

  Event toEntity() => Event(
        eventId: eventId,
        title: title,
        description: description,
        startTime: startTime,
        endTime: endTime,
        location: location,
        isAllDay: isAllDay,
        color: color,
        projectId: projectId,
        createdBy: createdBy,
        createdAt: createdAt,
        userIds: userIds,
      );
}