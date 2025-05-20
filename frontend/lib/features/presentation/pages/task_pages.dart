import 'package:doan/features/core/enums.dart';
import 'package:doan/features/core/injection.dart';
import 'package:doan/features/presentation/blocs/task_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doan/features/domain/entities/task.dart';


class TaskPage extends StatelessWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<TaskBloc>()..add(FetchAllTasksEvent()), // Gửi sự kiện lấy tất cả task khi khởi tạo
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Task Management'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                context.read<TaskBloc>().add(FetchAllTasksEvent());
              },
            ),
          ],
        ),
        body: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TaskLoaded) {
              if (state.tasks.isEmpty) {
                return const Center(child: Text('No tasks available'));
              }
              return ListView.builder(
                itemCount: state.tasks.length,
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  return ListTile(
                    title: Text(task.title!),
                    subtitle: Text('Status: ${task.status.toString().split('.').last}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showUpdateDialog(context, task),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            context.read<TaskBloc>().add(DeleteTaskEvent(task.taskId!));
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      context.read<TaskBloc>().add(FetchTaskByIdEvent(task.taskId!));
                      _showTaskDetailDialog(context);
                    },
                  );
                },
              );
            } else if (state is TaskError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('Press refresh to load tasks'));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showCreateDialog(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  // Dialog để tạo task mới
  void _showCreateDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final newTask = Task(
                  taskId: DateTime.now().millisecondsSinceEpoch, // Tạm dùng timestamp làm ID
                  title: titleController.text,
                  description: descriptionController.text,
                  startDate: DateTime.now(),
                  deadline: DateTime.now().add(const Duration(days: 7)),
                  priority: Priority.medium,
                  status: ProjectStatus.pending,
                  projectId: 1, // Giả định projectId mặc định
                  assignedUserIds: [1, 2], // Giả định danh sách user
                );
                context.read<TaskBloc>().add(CreateTaskEvent(newTask));
                Navigator.pop(context);
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  // Dialog để cập nhật task
  void _showUpdateDialog(BuildContext context, Task task) {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final updatedTask = Task(
                  taskId: task.taskId,
                  title: titleController.text,
                  description: descriptionController.text,
                  startDate: task.startDate,
                  deadline: task.deadline,
                  priority: task.priority,
                  status: task.status,
                  projectId: task.projectId,
                  assignedUserIds: task.assignedUserIds,
                );
                context.read<TaskBloc>().add(UpdateTaskEvent(updatedTask));
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // Dialog để hiển thị chi tiết task
  void _showTaskDetailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return const AlertDialog(
                content: Center(child: CircularProgressIndicator()),
              );
            } else if (state is TaskDetailLoaded) {
              final task = state.task;
              return AlertDialog(
                title: Text(task.title!),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Description: ${task.description}'),
                    Text('Start Date: ${task.startDate.toString()}'),
                    Text('Deadline: ${task.deadline.toString()}'),
                    Text('Priority: ${task.priority.toString().split('.').last}'),
                    Text('Status: ${task.status.toString().split('.').last}'),
                    Text('Project ID: ${task.projectId}'),
                    Text('Assigned Users: ${task.assignedUserIds?.join(', ') ?? 'None'}'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Close'),
                  ),
                ],
              );
            } else if (state is TaskError) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text(state.message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Close'),
                  ),
                ],
              );
            }
            return const AlertDialog(
              content: Text('No task details available'),
            );
          },
        );
      },
    );
  }
}