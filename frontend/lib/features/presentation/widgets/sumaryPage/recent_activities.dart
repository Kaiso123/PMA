import 'package:doan/features/domain/entities/issue.dart';
import 'package:flutter/material.dart';


class RecentActivity extends StatelessWidget {
  final List<Issue> issues;
  const RecentActivity({Key? key, required this.issues}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Xác định khoảng thời gian 7 ngày gần nhất
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    // Hàm kiểm tra ngày có nằm trong 7 ngày gần nhất không
    bool isWithinLast7Days(DateTime? date) {
      if (date == null) return false;
      return date.isAfter(sevenDaysAgo) || date.isAtSameMomentAs(sevenDaysAgo);
    }

    // Đếm số lượng "Completed" và "Created" trong 7 ngày gần nhất
    final completedCount = issues
        .where((issue) =>
            issue.status == 'Done' && isWithinLast7Days(issue.endTime))
        .length;
    final createdCount =
        issues.where((issue) => isWithinLast7Days(issue.created)).length;

    // Lấy chiều rộng màn hình
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.4; // 40% chiều rộng màn hình

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: cardWidth,
          child: _buildActivityCard('Completed in the last 7 days', completedCount),
        ),
        SizedBox(
          width: cardWidth,
          child: _buildActivityCard('Created in the last 7 days', createdCount),
        ),
      ],
    );
  }

  Widget _buildActivityCard(String label, int count) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count.toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}