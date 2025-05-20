import 'package:doan/features/domain/entities/sprint.dart';
import 'package:doan/features/presentation/pages/projectDetail/calendar.dart';
import 'package:flutter/material.dart';

class SprintBar extends StatelessWidget {
  final Sprint sprint;
  final int index;
  final int sprintsLength;
  final CalendarView viewMode;
  final DateTime currentDate;
  final double columnWidth;
  final double rowHeight;
  final double headerHeight;
  final bool isManager;

  const SprintBar({
    Key? key,
    required this.sprint,
    required this.index,
    required this.sprintsLength,
    required this.viewMode,
    required this.currentDate,
    required this.columnWidth,
    required this.rowHeight,
    required this.headerHeight,
    required this.isManager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final end = sprint.endTime ?? sprint.created.add(const Duration(days: 7));

    if (viewMode == CalendarView.daily) {
      // Chế độ ngày
      final firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
      final lastDayOfMonth =
          DateTime(currentDate.year, currentDate.month + 1, 0);
      final firstDayOfWeek = firstDayOfMonth.weekday % 7;
      final totalDays = lastDayOfMonth.day;

      // Chỉ hiển thị nếu sprint nằm trong tháng hiện tại
      if (end.isAfter(lastDayOfMonth) || end.isBefore(firstDayOfMonth)) {
        return const SizedBox.shrink();
      }

      // Tính vị trí của ngày kết thúc
      final endDay = end.isAfter(lastDayOfMonth)
          ? totalDays - 1 + firstDayOfWeek
          : end.day - 1 + firstDayOfWeek;

      final leftOffset = (endDay % 7) * columnWidth;
      final topOffset = headerHeight +
          (endDay ~/ 7) * rowHeight * sprintsLength +
          index * rowHeight;

      // Nội dung chung cho cả Draggable và Container
      final sprintContent = Container(
        width: columnWidth,
        height: rowHeight - 4,
        color: Colors.transparent,
        child: Center(
          child: Text(
            sprint.name,
            style: TextStyle(
              color: Colors.black,
              fontSize: columnWidth * 0.25,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );

      return Positioned(
        left: leftOffset,
        top: topOffset,
        child: isManager
            ? Draggable<Map<String, dynamic>>(
                data: {'sprintIndex': index},
                feedback: Material(
                  child: Container(
                    width: columnWidth,
                    height: rowHeight - 4,
                    color: Colors.transparent,
                    child: Center(
                      child: Text(
                        sprint.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: columnWidth * 0.25,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                child: sprintContent,
              )
            : sprintContent,
      );
    } else {
      // Chế độ tháng
      final endMonth = (end.year == currentDate.year)
          ? end.month - 1
          : (end.isAfter(DateTime(currentDate.year, 12, 31)) ? 11 : 0);

      // Chỉ hiển thị nếu sprint nằm trong năm hiện tại
      if (end.year < currentDate.year) {
        return const SizedBox.shrink();
      }

      // Tính vị trí của tháng kết thúc
      final leftOffset = (endMonth % 4) * (columnWidth * 7 / 4);
      final topOffset = headerHeight +
          (endMonth ~/ 4) * rowHeight * sprintsLength +
          index * rowHeight;

      // Nội dung chung cho cả Draggable và Container
      final sprintContent = Container(
        width: columnWidth * 7 / 4,
        height: rowHeight - 4,
        color: Colors.transparent,
        child: Center(
          child: Text(
            sprint.name,
            style: TextStyle(
              color: Colors.black,
              fontSize: columnWidth * 0.25,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );

      return Positioned(
        left: leftOffset,
        top: topOffset,
        child: isManager
            ? Draggable<Map<String, dynamic>>(
                data: {'sprintIndex': index},
                feedback: Material(
                  child: Container(
                    width: columnWidth * 7 / 4,
                    height: rowHeight - 4,
                    color: Colors.transparent,
                    child: Center(
                      child: Text(
                        sprint.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: columnWidth * 0.25,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                child: sprintContent,
              )
            : sprintContent,
      );
    }
  }
}