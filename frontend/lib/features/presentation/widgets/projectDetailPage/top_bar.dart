import 'package:doan/features/presentation/blocs/backlog_provider2.dart';
import 'package:doan/features/presentation/pages/projects_pages.dart';
import 'package:doan/features/presentation/widgets/projectDetailPage/components/your_work_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doan/features/domain/entities/project.dart';
import 'package:doan/features/presentation/blocs/user_project_bloc.dart';
import 'top_bar_item.dart';

class TopBar extends StatelessWidget {
  final Project project;
  final BuildContext fatherContext;

  const TopBar({Key? key, required this.project, required this.fatherContext})
      : super(key: key);

  void _showProjectOverlay(BuildContext context) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    final blocContext = context;

    overlayEntry = OverlayEntry(
      builder: (overlayContext) => GestureDetector(
        onTap: () {},
        child: Material(
          color: Colors.black54,
          child: Center(
            child: Container(
              width: 400,
              height: 500,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: BlocProvider.value(
                value: BlocProvider.of<UserProjectBloc>(blocContext),
                child: BlocBuilder<UserProjectBloc, UserProjectState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Project Details',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                overlayEntry.remove();
                              },
                            ),
                          ],
                        ),
                        const Divider(),
                        const Text(
                          'Invite Code',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              // Sao chép inviteCode vào clipboard
                              Clipboard.setData(
                                  ClipboardData(text: project.inviteCode!));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Đã sao chép mã: ${project.inviteCode}')),
                              );
                            },
                            child: Text(
                              '${project.inviteCode}.',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Members',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: state is UserProjectLoading
                              ? const Center(child: CircularProgressIndicator())
                              : state is UserProjectsLoaded
                                  ? state.userProjects.isEmpty
                                      ? const Center(child: Text('No members'))
                                      : ListView.builder(
                                          itemCount: state.userProjects.length,
                                          itemBuilder: (context, index) {
                                            final member =
                                                state.userProjects[index];
                                            return ListTile(
                                              leading: const Icon(Icons.person),
                                              title:
                                                  Text('User ${member.userId}'),
                                              subtitle: Text(member.isManager
                                                  ? 'Manager'
                                                  : 'Member'),
                                            );
                                          },
                                        )
                                  : const Center(
                                      child: Text('Failed to load members')),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
    overlay.insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 16, left: 0, right: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          TopBarItem(
            icon: Icons.rocket_launch_rounded,
            iconColor: Colors.blue,
            iconSize: 24,
          ),
          TopBarItem(
            title: 'Your work',
            onTap: () {
              final backlogProvider = context
                  .read<BacklogProvider>(); 
              final overlayEntry = createYourWorkOverlayEntry(
                context,
                project,
                () {},
                backlogProvider, 
              );
              Overlay.of(context).insert(overlayEntry);
            },
          ),
          TopBarItem(
            title: 'Project',
            onTap: () => _showProjectOverlay(context),
          ),
          const Spacer(),
          TopBarItem(
            icon: Icons.exit_to_app,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProjectPage()),
              );
            },
          )
        ],
      ),
    );
  }
}
