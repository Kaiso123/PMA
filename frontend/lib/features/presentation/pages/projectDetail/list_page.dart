import 'package:doan/features/domain/entities/issue.dart';
import 'package:doan/features/domain/entities/project.dart';
import 'package:doan/features/domain/entities/sprint.dart';
import 'package:doan/features/presentation/widgets/backLogPage/component/creat_issue_overlay.dart';
import 'package:doan/features/presentation/widgets/listPage/issue_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../blocs/backlog_provider2.dart';

class ListPage extends StatefulWidget {
  final Project project;
  const ListPage({Key? key, required this.project}) : super(key: key);

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      Provider.of<BacklogProvider>(context, listen: false)
          .setListPageSearchQuery(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

          // Lấy tất cả issues từ sprints và backlog
          final List<Issue> allIssues = [];
          for (var sprint in provider.filteredSprintsForListPage) {
            allIssues.addAll(sprint.issues);
          }
          allIssues.addAll(provider.filteredBacklogIssuesForListPage);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thanh tìm kiếm
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search, size: 20, color: Colors.grey),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    hintText: 'Search issues...',
                                    border: InputBorder.none,
                                    suffixIcon:
                                        _searchController.text.isNotEmpty
                                            ? IconButton(
                                                icon: const Icon(Icons.clear,
                                                    size: 20,
                                                    color: Colors.grey),
                                                onPressed: () {
                                                  _searchController.clear();
                                                },
                                              )
                                            : null,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.filter_list, size: 20),
                        onPressed: () {
                          // TODO: Triển khai bộ lọc
                        },
                      ),
                    ],
                  ),
                ),
                // Breadcrumb
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Text(
                        'Projects / ${widget.project.name}',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'List',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                // Nút Create
                widget.project.isManager!
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            OverlayEntry? overlayEntry;
                            overlayEntry = createIssueOverlayEntry(
                              context,
                              (issue) {
                                Provider.of<BacklogProvider>(context,
                                        listen: false)
                                    .CreatIssueToBacklog(
                                        issue, widget.project.projectId!);
                                overlayEntry?.remove();
                              },
                              () {
                                overlayEntry?.remove();
                              },
                              widget.project.projectId!,
                              0,
                            );
                            Overlay.of(context).insert(overlayEntry);
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Create Issue'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
                if (allIssues.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        provider.listPageSearchQuery.isEmpty
                            ? 'No issues available'
                            : 'No issues found for "${provider.listPageSearchQuery}"',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  ),
                // Danh sách cards
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  itemCount: allIssues.length,
                  itemBuilder: (context, index) {
                    final issue = allIssues[index];
                    final sprintName = issue.sprintId != null
                        ? provider.sprints
                            .firstWhere(
                              (sprint) => sprint.id == issue.sprintId,
                              orElse: () => Sprint(
                                id: 0,
                                projectId: widget.project.projectId!,
                                name: 'Unknown',
                                description: '',
                                created: DateTime.now(),
                                endTime: null,
                                status: '',
                                priority: '',
                                issues: [],
                              ),
                            )
                            .name
                        : 'Backlog';
                    return IssueCard(
                      issue: issue,
                      sprintName: sprintName,
                      provider: provider,
                      isManager: widget.project.isManager!,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
