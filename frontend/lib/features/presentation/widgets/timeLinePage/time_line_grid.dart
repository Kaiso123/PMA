import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimelineGrid extends StatelessWidget {
  final DateTime displayStart;
  final int totalMonths;
  final double leftAxisWidth;
  final int sprintCount;
  final double columnWidth;
  final double monthHeight;
  final double headerHeight;

  const TimelineGrid({
    Key? key,
    required this.displayStart,
    required this.totalMonths,
    required this.leftAxisWidth,
    required this.sprintCount,
    required this.columnWidth,
    required this.monthHeight,
    required this.headerHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Month labels and grid lines
        for (int m = 0; m <= totalMonths; m++) ...[
          // Month label
          Positioned(
            top: headerHeight + m * monthHeight,
            left: 0,
            child: Container(
              width: leftAxisWidth,
              height: monthHeight,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300),
                  right: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Text(
                DateFormat('MMM').format(
                  DateTime(displayStart.year, displayStart.month + m),
                ),
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          // Grid rows across sprints
          for (int i = 0; i < sprintCount; i++)
            Positioned(
              top: headerHeight + m * monthHeight,
              left: leftAxisWidth + i * columnWidth,
              child: Container(
                width: columnWidth,
                height: monthHeight,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                    right: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }
}
