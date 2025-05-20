class Event {
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

  Event({
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
}
