import 'package:doan/features/domain/entities/issue.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatusOverview extends StatelessWidget {
  final List<Issue> issues;
  const StatusOverview({Key? key, required this.issues}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Đếm số lượng issues theo trạng thái
    final toDoCount = issues.where((issue) => issue.status == 'ToDo').length;
    final inProgressCount =
        issues.where((issue) => issue.status == 'InProgress').length;
    final doneCount = issues.where((issue) => issue.status == 'Done').length;
    final totalCount = toDoCount + inProgressCount + doneCount;

    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Status overview',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                  },
                  child: const Text(
                    'View all work items',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            const Text(
              'Get a snapshot of the status of your work items',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              value: toDoCount.toDouble(),
                              color: Colors.pinkAccent,
                              showTitle: false,
                              radius: 20,
                            ),
                            PieChartSectionData(
                              value: inProgressCount.toDouble(),
                              color: Colors.blue,
                              showTitle: false,
                              radius: 20,
                            ),
                            PieChartSectionData(
                              value: doneCount.toDouble(),
                              color: Colors.orange,
                              showTitle: false,
                              radius: 20,
                            ),
                          ],
                          centerSpaceRadius: 50,
                          sectionsSpace: 0,
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            totalCount.toString(),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Total work items',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem('To Do', toDoCount, Colors.pinkAccent),
                    _buildLegendItem('In Progress', inProgressCount, Colors.blue),
                    _buildLegendItem('Done', doneCount, Colors.orange),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Text('$label: $count'),
        ],
      ),
    );
  }
}