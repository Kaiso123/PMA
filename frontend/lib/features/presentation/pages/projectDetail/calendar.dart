import 'package:doan/features/presentation/widgets/calendarPage/calendar_grid.dart';
import 'package:doan/features/presentation/widgets/calendarPage/calendar_header.dart';
import 'package:doan/features/presentation/widgets/calendarPage/sprint_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doan/features/domain/entities/project.dart';
import 'package:doan/features/presentation/blocs/backlog_provider2.dart';

enum CalendarView { daily, monthly }

class CalendarPage extends StatefulWidget {
  final Project project;
  const CalendarPage({Key? key, required this.project}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late DateTime _currentDate;
  CalendarView _viewMode = CalendarView.daily;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
  }

  void _previousPeriod() {
    setState(() {
      if (_viewMode == CalendarView.daily) {
        _currentDate = DateTime(_currentDate.year, _currentDate.month - 1, 1);
      } else {
        _currentDate = DateTime(_currentDate.year - 1, _currentDate.month, 1);
      }
    });
  }

  void _nextPeriod() {
    setState(() {
      if (_viewMode == CalendarView.daily) {
        _currentDate = DateTime(_currentDate.year, _currentDate.month + 1, 1);
      } else {
        _currentDate = DateTime(_currentDate.year + 1, _currentDate.month, 1);
      }
    });
  }

  void _toggleViewMode() {
    setState(() {
      _viewMode = _viewMode == CalendarView.daily
          ? CalendarView.monthly
          : CalendarView.daily;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final columnWidth = screenWidth / 7; // 7 cột fit với cạnh màn hình
    final rowHeight = screenHeight * 0.08; // Chiều cao mỗi hàng
    final headerHeight = screenHeight * 0.05; // Chiều cao tiêu đề

    return Consumer<BacklogProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.errorMessage != null) {
          return Center(child: Text('Error: ${provider.errorMessage}'));
        }
        final sprints = provider.sprints;
        if (sprints.isEmpty) {
          return const Center(child: Text('No sprints available'));
        }

        return Column(
          children: [
            // Header
            CalendarHeader(
              currentDate: _currentDate,
              viewMode: _viewMode,
              onPreviousPeriod: _previousPeriod,
              onNextPeriod: _nextPeriod,
              onToggleViewMode: _toggleViewMode,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
            // Lịch
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Lưới ngày/tháng
                    Container(
                      width: screenWidth,
                      child: Stack(
                        children: [
                          CalendarGrid(
                            columnWidth: columnWidth,
                            rowHeight: rowHeight,
                            headerHeight: headerHeight,
                            sprints: sprints,
                            viewMode: _viewMode,
                            currentDate: _currentDate,
                          ),
                          // Khối ngày kết thúc của sprint
                          for (int i = 0; i < sprints.length; i++)
                            SprintBar(
                              sprint: sprints[i],
                              index: i,
                              sprintsLength: sprints.length,
                              viewMode: _viewMode,
                              currentDate: _currentDate,
                              columnWidth: columnWidth,
                              rowHeight: rowHeight,
                              headerHeight: headerHeight,
                              isManager: widget.project.isManager!,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
