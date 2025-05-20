import 'package:flutter/material.dart';

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'todo':
      return Colors.grey;
    case 'inprogress':
      return Colors.blue;
    case 'done':
      return Colors.green;
    default:
      return Colors.grey;
  }
}

Color getPriorityColor(String priority) {
  switch (priority.toLowerCase()) {
    case 'high':
      return Colors.red;
    case 'medium':
      return Colors.orange;
    case 'low':
      return Colors.green;
    default:
      return Colors.grey;
  }
}

bool isOverdue(DateTime? endTime) {
  if (endTime == null) return false;
  final now = DateTime.now();
  return endTime.isBefore(now);
}

String formatDisplayDate(String isoDate) {
  if (isoDate.isEmpty) return 'Select Date';
  try {
    final date = DateTime.parse(isoDate);
    return '${date.day}/${date.month}/${date.year}';
  } catch (e) {
    return isoDate;
  }
}