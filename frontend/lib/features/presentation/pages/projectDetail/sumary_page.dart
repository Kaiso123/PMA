import 'package:doan/features/domain/entities/issue.dart';
import 'package:doan/features/domain/entities/project.dart';
import 'package:doan/features/presentation/blocs/backlog_provider2.dart';
import 'package:doan/features/presentation/widgets/sumaryPage/priority_breakdown.dart';
import 'package:doan/features/presentation/widgets/sumaryPage/recent_activities.dart';
import 'package:doan/features/presentation/widgets/sumaryPage/status_overview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SummaryPage extends StatelessWidget {
  final Project project;
  const SummaryPage({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<BacklogProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return Center(child: Text('Error: ${provider.errorMessage}'));
          }

          // Gộp tất cả issues từ sprints và backlog
          final allIssues = <Issue>[];
          for (var sprint in provider.sprints) {
            allIssues.addAll(sprint.issues);
          }
          allIssues.addAll(provider.backlogIssues);

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Breadcrumb
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Row(
                      children: [
                        Text(
                          'Projects / ${project.name}',
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Summary',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RecentActivity(issues: allIssues),
                  const SizedBox(height: 30),
                  StatusOverview(issues: allIssues),
                  const SizedBox(height: 30),
                  PriorityBreakdown(issues: allIssues),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}