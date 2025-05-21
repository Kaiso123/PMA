import 'package:doan/features/core/injection.dart';
import 'package:doan/features/presentation/blocs/auth_bloc.dart';
import 'package:doan/features/presentation/blocs/project_bloc.dart';
import 'package:doan/features/presentation/blocs/user_project_bloc.dart';
import 'package:doan/features/presentation/pages/login_page.dart';
import 'package:doan/features/presentation/widgets/projectPage/projectItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doan/features/core/enums.dart';
import 'package:doan/features/domain/entities/project.dart';


class ProjectPage extends StatefulWidget {
  const ProjectPage({Key? key}) : super(key: key);

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  int currentPage = 1; // Trang hiện tại
  final int itemsPerPage = 7; // Số item trên mỗi trang
  final TextEditingController _pageController = TextEditingController();

  void _showCreateProjectDialog(BuildContext parentContext) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final authState = parentContext.read<AuthBloc>().state;

    if (authState is! AuthSuccess) {
      ScaffoldMessenger.of(parentContext).showSnackBar(
        const SnackBar(
          content: Text('Please login to create a project'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pushReplacement(
        parentContext,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
      return;
    }

    showDialog(
      context: parentContext,
      builder: (_) {
        return BlocProvider.value(
          value: BlocProvider.of<ProjectBloc>(parentContext),
          child: Builder(
            builder: (dialogContext) {
              return AlertDialog(
                title: const Text('Create New Project'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration:
                          const InputDecoration(labelText: 'Project Name'),
                      maxLength: 16,
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (nameController.text.isNotEmpty) {
                        final newProject = Project(
                          projectId: 0,
                          managerId: authState.user.userId!,
                          name: nameController.text,
                          description: descriptionController.text.isNotEmpty
                              ? descriptionController.text
                              : null,
                          startDate: DateTime.now(),
                          endDate: null,
                          memberIds: null,
                          status: ProjectStatus.pending,
                          budget: 0.0,
                          progress: 0.0,
                        );
                        dialogContext
                            .read<ProjectBloc>()
                            .add(CreateProjectEvent(newProject));
                        Navigator.of(dialogContext).pop();
                      }
                    },
                    child: const Text('Create'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void _showJoinProjectDialog(BuildContext parentContext) {
    final inviteCodeController = TextEditingController();
    bool isManager = false;
    final authState = parentContext.read<AuthBloc>().state;

    if (authState is! AuthSuccess) {
      ScaffoldMessenger.of(parentContext).showSnackBar(
        const SnackBar(
          content: Text('Please login to join a project'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pushReplacement(
        parentContext,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
      return;
    }

    showDialog(
      context: parentContext,
      builder: (_) {
        return BlocProvider.value(
          value: BlocProvider.of<UserProjectBloc>(parentContext),
          child: Builder(
            builder: (dialogContext) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: const Text('Join Project'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: inviteCodeController,
                          decoration: const InputDecoration(
                              labelText: 'Invite Code'),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (inviteCodeController.text.isNotEmpty) {
                            dialogContext.read<UserProjectBloc>().add(
                                  InviteUserToProjectEvent(
                                    inviteCode: inviteCodeController.text,
                                    userId: authState.user.userId!,
                                    isManager: isManager,
                                  ),
                                );
                            Navigator.of(dialogContext).pop();
                          }
                        },
                        child: const Text('Join'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final authState = context.read<AuthBloc>().state;
            if (authState is AuthSuccess) {
              return getIt<ProjectBloc>()
                ..add(FetchProjectsByUserEvent(authState.user.userId!));
            } else {
              // Nếu chưa đăng nhập, trả về bloc mà không gọi event
              return getIt<ProjectBloc>();
            }
          },
        ),
        BlocProvider(
          create: (_) => getIt<UserProjectBloc>(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Projects',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              _showJoinProjectDialog(context);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.group_add, size: 18),
                                SizedBox(width: 4),
                                Text(
                                  'Join Project',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () {
                              _showCreateProjectDialog(context);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.add, size: 18),
                                SizedBox(width: 4),
                                Text(
                                  'New Project',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 0.5,
                  margin: const EdgeInsets.only(bottom: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: MultiBlocListener(
                    listeners: [
                      BlocListener<ProjectBloc, ProjectState>(
                        listener: (context, state) {
                          if (state is ProjectSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)),
                            );
                            final authState = context.read<AuthBloc>().state;
                            if (authState is AuthSuccess) {
                              context
                                  .read<ProjectBloc>()
                                  .add(FetchProjectsByUserEvent(authState.user.userId!));
                            }
                          } else if (state is ProjectError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)),
                            );
                          }
                        },
                      ),
                      BlocListener<UserProjectBloc, UserProjectState>(
                        listener: (context, state) {
                          if (state is UserProjectSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)),
                            );
                            final authState = context.read<AuthBloc>().state;
                            if (authState is AuthSuccess) {
                              context
                                  .read<ProjectBloc>()
                                  .add(FetchProjectsByUserEvent(authState.user.userId!));
                            }
                          } else if (state is UserProjectError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)),
                            );
                          }
                        },
                      ),
                    ],
                    child: BlocBuilder<ProjectBloc, ProjectState>(
                      builder: (context, state) {
                        final authState = context.read<AuthBloc>().state;
                        if (authState is! AuthSuccess) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Please login to view projects'),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => LoginPage()),
                                    );
                                  },
                                  child: const Text('Go to Login'),
                                ),
                              ],
                            ),
                          );
                        }

                        if (state is ProjectLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is ProjectsLoaded) {
                          if (state.projects.isEmpty) {
                            return const Center(
                                child: Text('No projects available'));
                          }

                          // Tính toán số trang và danh sách project cho trang hiện tại
                          final totalItems = state.projects.length;
                          final totalPages = (totalItems / itemsPerPage).ceil();
                          final startIndex = (currentPage - 1) * itemsPerPage;
                          final endIndex = startIndex + itemsPerPage > totalItems
                              ? totalItems
                              : startIndex + itemsPerPage;
                          final currentProjects =
                              state.projects.sublist(startIndex, endIndex);

                          return Column(
                            children: [
                              Expanded(
                                child: ListView(
                                  padding: const EdgeInsets.all(16.0),
                                  children: currentProjects
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    return ProjectItem(project: entry.value);
                                  }).toList(),
                                ),
                              ),
                              // Thanh điều hướng
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.arrow_left),
                                      onPressed: currentPage > 1
                                          ? () {
                                              setState(() {
                                                currentPage--;
                                                _pageController.text =
                                                    currentPage.toString();
                                              });
                                            }
                                          : null,
                                    ),
                                    SizedBox(
                                      width: 40,
                                      child: TextField(
                                        controller: _pageController
                                          ..text = currentPage.toString(),
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 4.0),
                                        ),
                                        onSubmitted: (value) {
                                          final page = int.tryParse(value) ?? 1;
                                          if (page >= 1 && page <= totalPages) {
                                            setState(() {
                                              currentPage = page;
                                              _pageController.text =
                                                  currentPage.toString();
                                            });
                                          } else {
                                            _pageController.text =
                                                currentPage.toString();
                                          }
                                        },
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.arrow_right),
                                      onPressed: currentPage < totalPages
                                          ? () {
                                              setState(() {
                                                currentPage++;
                                                _pageController.text =
                                                    currentPage.toString();
                                              });
                                            }
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                        return const Center(
                            child: Text('Press button to load projects'));
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}