import 'package:doan/features/domain/entities/project.dart';
import 'package:doan/features/presentation/blocs/backlog_provider2.dart';
import 'package:doan/features/presentation/widgets/backLogPage/backlog_section.dart';
import 'package:doan/features/presentation/widgets/backLogPage/component/creat_sprint_overlay.dart';
import 'package:doan/features/presentation/widgets/backLogPage/sprint_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BacklogPage extends StatelessWidget {
  final Project project;

  const BacklogPage({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Search bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.search, size: 20, color: Colors.grey),
                            SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  border: InputBorder.none,
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
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // Breadcrumb
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(8,8,8,0),
                child: Row(
                  children: [
                    Text(
                      'Projects / ${project.name ?? 'Unnamed Project'}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Backlog',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    project.isManager!
                        ? TextButton(
                            onPressed: () {
                              OverlayEntry? overlayEntry;
                              overlayEntry = createSprintOverlayEntry(
                                context,
                                (newSprint) {
                                  Provider.of<BacklogProvider>(context,
                                          listen: false)
                                      .createSprint(newSprint, project.projectId!);
                                  overlayEntry?.remove();
                                  overlayEntry = null;
                                },
                                () {
                                  overlayEntry?.remove();
                                  overlayEntry = null;
                                },
                                project.projectId!,
                              );
                              Overlay.of(context).insert(overlayEntry!);
                            },
                            child: const Text(
                              'Create Sprint',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.blue),
                            ),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),

              // Sprint list
              Expanded(
                child: Consumer<BacklogProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (provider.errorMessage != null) {
                      return Center(
                          child: Text('Error: ${provider.errorMessage}'));
                    }
                    return ListView(
                      children: [
                        ...provider.sprints.asMap().entries.map((entry) {
                          final index = entry.key;
                          final sprint = entry.value;
                          return SprintSection(
                            sprintName: sprint.name,
                            issueCount: sprint.issues.length,
                            issues: sprint.issues,
                            sprintIndex: index,
                            projectId: project.projectId!,
                            sprintId: sprint.id,
                            isManager: project.isManager!,
                          );
                        }),
                        const SizedBox(height: 80), 
                      ],
                    );
                  },
                ),
              ),
            ],
          ),

          // Draggable BacklogSection từ dưới lên
          DraggableScrollableSheet(
            initialChildSize: 0.12,
            minChildSize: 0.1,
            maxChildSize: 0.4,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(blurRadius: 10, color: Colors.black26),
                  ],
                ),
                child: BacklogSection(
                  scrollController: scrollController,
                  projectId: project.projectId!,
                  isManager: project.isManager!,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
