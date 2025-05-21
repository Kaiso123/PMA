import 'package:doan/features/domain/entities/issue.dart';
import 'package:doan/features/domain/entities/project.dart';
import 'package:doan/features/domain/entities/sprint.dart';
import 'package:doan/features/presentation/blocs/auth_bloc.dart';
import 'package:doan/features/presentation/blocs/backlog_provider2.dart';
import 'package:doan/features/presentation/blocs/event_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

OverlayEntry createYourWorkOverlayEntry(
  BuildContext context,
  Project project,
  VoidCallback onClose,
  BacklogProvider backlogProvider, 
) {
  OverlayEntry? overlayEntry;

  // ValueNotifier để theo dõi trạng thái AuthBloc và EventBloc
  final ValueNotifier<AuthState> authStateNotifier =
      ValueNotifier(context.read<AuthBloc>().state);
  final ValueNotifier<EventState> eventStateNotifier =
      ValueNotifier(context.read<EventBloc>().state);

  // Lắng nghe thay đổi từ AuthBloc và EventBloc
  void updateAuthState(AuthState state) {
    authStateNotifier.value = state;
  }

  void updateEventState(EventState state) {
    eventStateNotifier.value = state;
  }

  context.read<AuthBloc>().stream.listen(updateAuthState);
  context.read<EventBloc>().stream.listen(updateEventState);

  overlayEntry = OverlayEntry(
    builder: (overlayContext) => ChangeNotifierProvider<BacklogProvider>.value(
      value: backlogProvider, 
      child: GestureDetector(
        onTap: () {
          overlayEntry?.remove();
          onClose();
        },
        child: Material(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 500,
                height: 600,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider.value(
                      value: context.read<AuthBloc>(),
                    ),
                    BlocProvider.value(
                      value: context.read<EventBloc>(),
                    ),
                  ],
                  child: ValueListenableBuilder<AuthState>(
                    valueListenable: authStateNotifier,
                    builder: (context, authState, child) {
                      if (authState is! AuthSuccess ||
                          authState.user.userId == null) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Your Work',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    overlayEntry?.remove();
                                    onClose();
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Center(child: Text('Please login')),
                          ],
                        );
                      }
                      final userId = authState.user.userId!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Your Work',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  overlayEntry?.remove();
                                  onClose();
                                },
                              ),
                            ],
                          ),
                          const Divider(),
                          const Text(
                            'Assigned Issues',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Consumer<BacklogProvider>(
                              builder: (context, provider, child) {
                                if (provider.isLoading) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (provider.errorMessage != null) {
                                  return Center(
                                      child: Text(
                                          'Error: ${provider.errorMessage}'));
                                }

                                final assignedIssues = <Issue>[];
                                for (var sprint in provider.sprints) {
                                  assignedIssues.addAll(sprint.issues.where(
                                      (issue) => issue.assigneeId == userId));
                                }
                                assignedIssues.addAll(provider.backlogIssues
                                    .where(
                                        (issue) => issue.assigneeId == userId));

                                if (assignedIssues.isEmpty) {
                                  return const Center(
                                      child: Text('No issues assigned to you'));
                                }

                                return ListView.builder(
                                  itemCount: assignedIssues.length,
                                  itemBuilder: (context, index) {
                                    final issue = assignedIssues[index];
                                    final sprintName = issue.sprintId != null
                                        ? provider.sprints
                                            .firstWhere(
                                              (sprint) =>
                                                  sprint.id == issue.sprintId,
                                              orElse: () => Sprint(
                                                id: 0,
                                                projectId: project.projectId!,
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
                                    return ListTile(
                                      leading: const Icon(Icons.task),
                                      title: Text(issue.title),
                                      subtitle: Text(
                                          'Status: ${issue.status} | Sprint: $sprintName'),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          const Divider(),
                          const Text(
                            'Your Events',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ValueListenableBuilder<EventState>(
                              valueListenable: eventStateNotifier,
                              builder: (context, eventState, child) {
                                if (eventState is EventLoading) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (eventState is EventsLoaded) {
                                  final userEvents = eventState.events
                                      .where((event) =>
                                          event.userIds?.contains(userId) ??
                                          false)
                                      .toList();
                                  if (userEvents.isEmpty) {
                                    return const Center(
                                        child: Text('No events assigned to you'));
                                  }
                                  return ListView.builder(
                                    itemCount: userEvents.length,
                                    itemBuilder: (context, index) {
                                      final event = userEvents[index];
                                      return ListTile(
                                        leading: const Icon(Icons.event),
                                        title: Text(event.title ?? 'No Title'),
                                        subtitle: Text(
                                          'Start: ${event.startTime?.toLocal().toString() ?? 'N/A'} | ${event.description ?? 'No Description'}',
                                        ),
                                      );
                                    },
                                  );
                                } else if (eventState is EventError) {
                                  return Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('Error: ${eventState.message}'),
                                        TextButton(
                                          onPressed: () {
                                            context.read<EventBloc>().add(
                                                FetchEventsByProjectEvent(
                                                    project.projectId!));
                                          },
                                          child: const Text('Try Again'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return const Center(
                                    child: Text('Failed to load events'));
                              },
                            ),
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
      ),
    ),
  );

  if (context.mounted) {
    final eventState = context.read<EventBloc>().state;
    if (eventState is! EventsLoaded && eventState is! EventLoading) {
      context
          .read<EventBloc>()
          .add(FetchEventsByProjectEvent(project.projectId!));
    }
  }

  return overlayEntry;
}

