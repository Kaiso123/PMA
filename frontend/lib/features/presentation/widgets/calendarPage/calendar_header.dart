import 'package:doan/features/presentation/pages/projectDetail/calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class CalendarHeader extends StatelessWidget {
  final DateTime currentDate;
  final CalendarView viewMode;
  final VoidCallback onPreviousPeriod;
  final VoidCallback onNextPeriod;
  final VoidCallback onToggleViewMode;
  final double screenWidth;
  final double screenHeight;

  const CalendarHeader({
    Key? key,
    required this.currentDate,
    required this.viewMode,
    required this.onPreviousPeriod,
    required this.onNextPeriod,
    required this.onToggleViewMode,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, size: 20),
                onPressed: onPreviousPeriod,
              ),
              Text(
                viewMode == CalendarView.daily
                    ? DateFormat('MMM yyyy').format(currentDate)
                    : DateFormat('yyyy').format(currentDate),
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, size: 20),
                onPressed: onNextPeriod,
              ),
            ],
          ),
          ElevatedButton(
            onPressed: onToggleViewMode,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02,
                vertical: screenHeight * 0.01,
              ),
            ),
            child: Text(
              viewMode == CalendarView.daily ? 'Month View' : 'Day View',
              style: TextStyle(fontSize: screenWidth * 0.035),
            ),
          ),
        ],
      ),
    );
  }
}