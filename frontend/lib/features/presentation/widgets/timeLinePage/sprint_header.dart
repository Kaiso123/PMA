import 'package:doan/features/domain/entities/sprint.dart';
import 'package:flutter/material.dart';

class SprintHeader extends StatelessWidget {
  final Sprint sprint;
  final int index;
  final double leftAxisWidth;
  final double columnWidth;
  final double headerHeight;

  const SprintHeader({
    Key? key,
    required this.sprint,
    required this.index,
    required this.leftAxisWidth,
    required this.columnWidth,
    required this.headerHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: leftAxisWidth + index * columnWidth,
      child: Container(
        width: columnWidth,
        height: headerHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border(
            right: BorderSide(color: Colors.grey.shade300),
            bottom: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Text(
          sprint.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}