import 'package:doan/features/domain/entities/issue.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PriorityBreakdown extends StatelessWidget {
  final List<Issue> issues;
  const PriorityBreakdown({Key? key, required this.issues}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Đếm số lượng issues theo mức độ ưu tiên
    final highestCount = issues.where((issue) => issue.priority == 'Highest').length;
    final highCount = issues.where((issue) => issue.priority == 'High').length;
    final mediumCount = issues.where((issue) => issue.priority == 'Medium').length;
    final lowCount = issues.where((issue) => issue.priority == 'Low').length;
    final lowestCount = issues.where((issue) => issue.priority == 'Lowest').length;

    // Tính maxY động
    final maxCount = [
      highestCount,
      highCount,
      mediumCount,
      lowCount,
      lowestCount,
    ].reduce((a, b) => a > b ? a : b);
    final maxY = maxCount > 0 ? (maxCount.toDouble() + 1) : 5.0;

    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Priority breakdown',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Get a holistic view of how work is being prioritized. See what your team's been focusing on",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) => Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text('Highest', style: TextStyle(color: Colors.red));
                            case 1:
                              return const Text('High', style: TextStyle(color: Colors.orange));
                            case 2:
                              return const Text('Medium', style: TextStyle(color: Colors.yellow));
                            case 3:
                              return const Text('Low', style: TextStyle(color: Colors.blue));
                            case 4:
                              return const Text('Lowest', style: TextStyle(color: Colors.lightBlue));
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: highestCount.toDouble(),
                          color: Colors.grey,
                          width: 16,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: highCount.toDouble(),
                          color: Colors.grey,
                          width: 16,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: mediumCount.toDouble(),
                          color: Colors.grey,
                          width: 16,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 3,
                      barRods: [
                        BarChartRodData(
                          toY: lowCount.toDouble(),
                          color: Colors.grey,
                          width: 16,
                        ),
                      ],
                    ),
                    BarChartGroupData(
                      x: 4,
                      barRods: [
                        BarChartRodData(
                          toY: lowestCount.toDouble(),
                          color: Colors.grey,
                          width: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}