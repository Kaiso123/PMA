import 'package:doan/features/domain/entities/sprint.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../blocs/backlog_provider2.dart';

class SprintBar extends StatelessWidget {
  final Sprint sprint;
  final int index;
  final DateTime displayStart;
  final DateTime displayEnd;
  final double leftAxisWidth;
  final double columnWidth;
  final double headerHeight;
  final double monthHeight;
  final bool isManager;

  const SprintBar({
    Key? key,
    required this.sprint,
    required this.index,
    required this.displayStart,
    required this.displayEnd,
    required this.leftAxisWidth,
    required this.columnWidth,
    required this.headerHeight,
    required this.monthHeight,
    required this.isManager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final start = sprint.created;
    final end = sprint.endTime ?? start.add(const Duration(days: 7));

    // Tính tổng số ngày từ displayStart đến displayEnd
    final totalDays = displayEnd.difference(displayStart).inDays;
    // Tính số pixel mỗi ngày dựa trên tổng chiều cao của lưới (totalMonths * monthHeight)
    final totalMonths = ((displayEnd.year - displayStart.year) * 12 +
            displayEnd.month -
            displayStart.month) +
        1;
    final totalHeight = totalMonths * monthHeight;
    final pixelsPerDay = totalHeight / totalDays;

    // Tính vị trí topOffset dựa trên số ngày từ displayStart đến start
    final startDaysOffset = start.difference(displayStart).inDays;
    final topOffset = headerHeight + startDaysOffset * pixelsPerDay;

    // Tính chiều cao thanh dựa trên số ngày từ start đến end
    final durationDays = end.difference(start).inDays + 1;
    final barHeight = durationDays * pixelsPerDay;

    bool isDraggingStart = false;
    bool isDraggingEnd = false;
    bool isDraggingWhole = false;

    const handleHeight = 16.0;
    final dragAreaHeight = (barHeight - 2 * handleHeight) > 0
        ? (barHeight - 2 * handleHeight)
        : 0.0;

    return StatefulBuilder(
      builder: (context, setState) {
        DateTime? newStart = start;
        DateTime? newEnd = end;

        return Positioned(
          left: leftAxisWidth + index * columnWidth + columnWidth * 0.1,
          top: topOffset,
          child: Stack(
            children: [
              Container(
                width: columnWidth * 0.8,
                height: barHeight,
                decoration: BoxDecoration(
                  color: isDraggingWhole
                      ? Colors.blueAccent.withOpacity(0.9)
                      : Colors.blueAccent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        dateFormat.format(newStart),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        '${newEnd.difference(newStart).inDays}d',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        dateFormat.format(newEnd),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              //Kéo giữa
              isManager
                  ? Positioned(
                      top: handleHeight,
                      left: 0,
                      child: GestureDetector(
                        onVerticalDragStart: (details) {
                          setState(() {
                            isDraggingWhole = true;
                            newStart = start;
                            newEnd = end;
                          });
                        },
                        onVerticalDragUpdate: (details) {
                          final deltaDays =
                              (details.delta.dy / pixelsPerDay).round();
                          if (deltaDays != 0) {
                            final tempStart =
                                newStart!.add(Duration(days: deltaDays));
                            if (tempStart.isBefore(displayStart)) return;

                            final tempEnd =
                                newEnd!.add(Duration(days: deltaDays));
                            if (tempEnd.isAfter(displayEnd)) return;

                            setState(() {
                              newStart = tempStart;
                              newEnd = tempEnd;
                            });

                            Provider.of<BacklogProvider>(context, listen: false)
                                .updateSprintCreated(index, newStart!,
                                    updateApi: false);
                            Provider.of<BacklogProvider>(context, listen: false)
                                .updateSprintEndTime(index, newEnd,
                                    updateApi: false);
                          }
                        },
                        onVerticalDragEnd: (details) {
                          Provider.of<BacklogProvider>(context, listen: false)
                              .updateSprintCreated(index, newStart!,
                                  updateApi: true);
                          Provider.of<BacklogProvider>(context, listen: false)
                              .updateSprintEndTime(index, newEnd,
                                  updateApi: true);
                          setState(() {
                            isDraggingWhole = false;
                          });
                        },
                        child: Container(
                          width: columnWidth * 0.8,
                          height: dragAreaHeight,
                          color: Colors.transparent,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              //kéo phía trên
              isManager
                  ? Positioned(
                      top: 0,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onVerticalDragStart: (details) {
                          setState(() {
                            isDraggingStart = true;
                            newStart = start;
                          });
                        },
                        onVerticalDragUpdate: (details) {
                          final deltaDays =
                              (details.delta.dy / pixelsPerDay).round();
                          if (deltaDays != 0) {
                            final tempStart =
                                newStart!.add(Duration(days: deltaDays));
                            if (tempStart.isBefore(displayStart) ||
                                tempStart.isAfter(newEnd!)) return;

                            setState(() {
                              newStart = tempStart;
                            });

                            Provider.of<BacklogProvider>(context, listen: false)
                                .updateSprintCreated(index, newStart!,
                                    updateApi: false);
                          }
                        },
                        onVerticalDragEnd: (details) {
                          Provider.of<BacklogProvider>(context, listen: false)
                              .updateSprintCreated(index, newStart!,
                                  updateApi: true);
                          setState(() {
                            isDraggingStart = false;
                          });
                        },
                        child: Container(
                          width: columnWidth * 0.8,
                          height: handleHeight,
                          decoration: BoxDecoration(
                            color: isDraggingStart
                                ? Colors.blueAccent
                                : Colors.blueAccent,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(6),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.arrow_drop_up,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              //kéo phía dưới
              isManager
                  ? Positioned(
                      bottom: 0,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onVerticalDragStart: (details) {
                          setState(() {
                            isDraggingEnd = true;
                            newEnd = end;
                          });
                        },
                        onVerticalDragUpdate: (details) {
                          final deltaDays =
                              (details.delta.dy / pixelsPerDay).round();
                          if (deltaDays != 0) {
                            final tempEnd =
                                newEnd!.add(Duration(days: deltaDays));
                            if (tempEnd.isBefore(newStart!) ||
                                tempEnd.isAfter(displayEnd)) return;

                            setState(() {
                              newEnd = tempEnd;
                            });

                            Provider.of<BacklogProvider>(context, listen: false)
                                .updateSprintEndTime(index, newEnd,
                                    updateApi: false);
                          }
                        },
                        onVerticalDragEnd: (details) {
                          Provider.of<BacklogProvider>(context, listen: false)
                              .updateSprintEndTime(index, newEnd,
                                  updateApi: true);
                          setState(() {
                            isDraggingEnd = false;
                          });
                        },
                        child: Container(
                          width: columnWidth * 0.8,
                          height: handleHeight,
                          decoration: BoxDecoration(
                            color: isDraggingEnd
                                ? Colors.blueAccent
                                : Colors.blueAccent,
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(6),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.arrow_drop_down,
                            size: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        );
      },
    );
  }
}
