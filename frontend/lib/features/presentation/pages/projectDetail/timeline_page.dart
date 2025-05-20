import 'package:doan/features/domain/entities/project.dart';
import 'package:doan/features/presentation/blocs/backlog_provider2.dart';
import 'package:doan/features/presentation/widgets/timeLinePage/sprint_bar.dart';
import 'package:doan/features/presentation/widgets/timeLinePage/sprint_header.dart';
import 'package:doan/features/presentation/widgets/timeLinePage/time_line_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimelinePage extends StatefulWidget {
  final Project project;
  const TimelinePage({Key? key, required this.project}) : super(key: key);

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  late DateTime _minStart;
  late DateTime _maxEnd;
  late DateTime _displayStart;
  late DateTime _displayEnd;

  @override
  Widget build(BuildContext context) {
    // Gọi fetchBacklogData khi vào trang
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BacklogProvider>(context, listen: false)
          .fetchBacklogData(widget.project.projectId!);
    });

    final screenWidth = MediaQuery.of(context).size.width;
    final leftAxisWidth = screenWidth * 0.25;
    final visibleSprintCount = 3;
    final columnWidth = (screenWidth - leftAxisWidth) / visibleSprintCount;
    final monthHeight = 90.0;
    final headerHeight = 50.0;

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

        // Determine overall date span
        final starts = sprints.map((s) => s.created).toList();
        final ends = sprints
            .map((s) => s.endTime ?? s.created.add(const Duration(days: 7)))
            .toList();
        _minStart = starts.reduce((a, b) => a.isBefore(b) ? a : b);
        _maxEnd = ends.reduce((a, b) => a.isAfter(b) ? a : b);

        // Tính _displayStart: ngày 1 của tháng, 3 tháng trước _minStart
        final startMonth = _minStart.month - 3;
        final startYear = _minStart.year + (startMonth <= 0 ? -1 : 0);
        final adjustedStartMonth =
            startMonth <= 0 ? startMonth + 12 : startMonth;
        _displayStart = DateTime(startYear, adjustedStartMonth, 1);

        // Tính _displayEnd: ngày cuối của tháng, 3 tháng sau _maxEnd
        final endMonth = _maxEnd.month + 3;
        final endYear = _maxEnd.year + (endMonth > 12 ? 1 : 0);
        final adjustedEndMonth = endMonth > 12 ? endMonth - 12 : endMonth;
        // Tính ngày cuối của tháng
        final nextMonth = DateTime(endYear, adjustedEndMonth + 1, 1);
        final lastDayOfMonth = nextMonth.subtract(const Duration(days: 1)).day;
        _displayEnd = DateTime(endYear, adjustedEndMonth, lastDayOfMonth);

        // Tính totalMonths dựa trên _displayStart và _displayEnd
        final totalMonths = (_displayEnd.year - _displayStart.year) * 12 +
            (_displayEnd.month - _displayStart.month) +
            1;

        final contentWidth = leftAxisWidth + sprints.length * columnWidth;
        final contentHeight = headerHeight + totalMonths * monthHeight;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SizedBox(
              width: contentWidth,
              height: contentHeight,
              child: Stack(
                children: [
                  // Lưới và nhãn tháng
                  TimelineGrid(
                    displayStart: _displayStart,
                    totalMonths: totalMonths,
                    leftAxisWidth: leftAxisWidth,
                    sprintCount: sprints.length,
                    columnWidth: columnWidth,
                    monthHeight: monthHeight,
                    headerHeight: headerHeight,
                  ),
                  // Tiêu đề của các sprint
                  for (int i = 0; i < sprints.length; i++)
                    SprintHeader(
                      sprint: sprints[i],
                      index: i,
                      leftAxisWidth: leftAxisWidth,
                      columnWidth: columnWidth,
                      headerHeight: headerHeight,
                    ),
                  // Thanh biểu diễn các sprint
                  for (int i = 0; i < sprints.length; i++)
                    SprintBar(
                      sprint: sprints[i],
                      index: i,
                      displayStart: _displayStart,
                      displayEnd: _displayEnd,
                      leftAxisWidth: leftAxisWidth,
                      columnWidth: columnWidth,
                      headerHeight: headerHeight,
                      monthHeight: monthHeight,
                      isManager: widget.project.isManager!,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
