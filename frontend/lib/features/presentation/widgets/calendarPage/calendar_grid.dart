import 'package:doan/features/domain/entities/sprint.dart';
import 'package:doan/features/presentation/pages/projectDetail/calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../blocs/backlog_provider2.dart';


class CalendarGrid extends StatelessWidget {
  final double columnWidth;
  final double rowHeight;
  final double headerHeight;
  final List<Sprint> sprints;
  final CalendarView viewMode;
  final DateTime currentDate;

  const CalendarGrid({
    Key? key,
    required this.columnWidth,
    required this.rowHeight,
    required this.headerHeight,
    required this.sprints,
    required this.viewMode,
    required this.currentDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (viewMode == CalendarView.daily) {
      // Chế độ ngày
      final firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
      final lastDayOfMonth = DateTime(currentDate.year, currentDate.month + 1, 0);
      final firstDayOfWeek = firstDayOfMonth.weekday % 7; // 0 = Sun, 1 = Mon, ..., 6 = Sat
      final daysInMonth = lastDayOfMonth.day;
      final totalSlots = (daysInMonth + firstDayOfWeek + 6) ~/ 7 * 7; 

      return Column(
        children: [
          // Tiêu đề ngày (Sun, Mon, ...)
          Container(
            height: headerHeight,
            child: Row(
              children: List.generate(7, (index) {
                return Container(
                  width: columnWidth,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                      right: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Text(
                    ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][index],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: columnWidth * 0.3,
                    ),
                  ),
                );
              }),
            ),
          ),
          // Lưới ngày
          for (int week = 0; week < totalSlots / 7; week++)
            Container(
              height: rowHeight * (sprints.length > 0 ? sprints.length : 1),
              child: Row(
                children: List.generate(7, (dayIndex) {
                  final slotIndex = week * 7 + dayIndex;
                  final day = slotIndex - firstDayOfWeek + 1;
                  final isInMonth = day >= 1 && day <= daysInMonth;
                  final targetDate = isInMonth
                      ? DateTime(currentDate.year, currentDate.month, day)
                      : null;

                  return Container(
                    width: columnWidth,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                        right: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: isInMonth
                        ? DragTarget<Map<String, dynamic>>(
                            onAccept: (data) {
                              final sprintIndex = data['sprintIndex'] as int;
                              final newDate = targetDate!;

                              if (sprintIndex >= sprints.length) return;

                              final sprint = sprints[sprintIndex];
                              // Kéo để đổi endTime
                              if (newDate.isBefore(sprint.created)) {
                                return;
                              }
                              Provider.of<BacklogProvider>(context, listen: false)
                                  .updateSprintEndTime(sprintIndex, newDate,
                                      updateApi: true);
                            },
                            builder: (context, candidateData, rejectedData) {
                              return Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.all(columnWidth * 0.1),
                                color: isInMonth &&
                                        day == DateTime.now().day &&
                                        currentDate.month == DateTime.now().month &&
                                        currentDate.year == DateTime.now().year
                                    ? Colors.blue.shade100
                                    : null,
                                child: Text(
                                  isInMonth ? day.toString() : '',
                                  style: TextStyle(
                                    color: isInMonth ? Colors.black : Colors.grey.shade300,
                                    fontSize: columnWidth * 0.2,
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(),
                  );
                }),
              ),
            ),
        ],
      );
    } else {
      // Chế độ tháng
      return Column(
        children: [
          // Tiêu đề tháng 
          Container(
            height: headerHeight,
            child: Row(
              children: List.generate(7, (index) => Container(width: columnWidth)),
            ),
          ),
          // Lưới tháng
          for (int row = 0; row < 3; row++)
            Container(
              height: rowHeight * (sprints.length > 0 ? sprints.length : 1),
              child: Row(
                children: List.generate(4, (col) {
                  final monthIndex = row * 4 + col;
                  final targetDate = DateTime(currentDate.year, monthIndex + 1, 1);

                  return Container(
                    width: columnWidth * 7 / 4,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                        right: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: DragTarget<Map<String, dynamic>>(
                      onAccept: (data) {
                        final sprintIndex = data['sprintIndex'] as int;
                        final newDate = targetDate;

                        if (sprintIndex >= sprints.length) return;

                        final sprint = sprints[sprintIndex];
                        // Kéo để đổi endTime
                        if (newDate.isBefore(sprint.created)) {
                          return;
                        }
                        Provider.of<BacklogProvider>(context, listen: false)
                            .updateSprintEndTime(sprintIndex, newDate, updateApi: true);
                      },
                      builder: (context, candidateData, rejectedData) {
                        return Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.all(columnWidth * 0.1),
                          child: Text(
                            DateFormat('MMM').format(
                                DateTime(currentDate.year, monthIndex + 1)),
                            style: TextStyle(fontSize: columnWidth * 0.2),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            ),
        ],
      );
    }
  }
}