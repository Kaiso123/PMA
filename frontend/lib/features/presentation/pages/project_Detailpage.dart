import 'package:doan/features/domain/entities/project.dart';
import 'package:doan/features/presentation/blocs/backlog_provider2.dart';
import 'package:doan/features/presentation/blocs/event_bloc.dart';
import 'package:doan/features/presentation/blocs/user_project_bloc.dart';
import 'package:doan/features/presentation/widgets/projectDetailPage/sidebar_layout.dart';
import 'package:doan/features/presentation/widgets/projectDetailPage/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../core/injection.dart';

class ProjectItemDetail extends StatefulWidget {
  final Project project;

  const ProjectItemDetail({Key? key, required this.project}) : super(key: key);

  @override
  State<ProjectItemDetail> createState() => _ProjectItemDetailState();
}

class _ProjectItemDetailState extends State<ProjectItemDetail> {
  bool isSidebarOpen = false;
  final BacklogProvider _backlogProvider = getIt<BacklogProvider>();
  bool _hasFetchedData = false;

  void toggleSidebar() {
    setState(() {
      isSidebarOpen = !isSidebarOpen;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasFetchedData && widget.project.projectId != null) {
        // Fetch backlog data
        _backlogProvider.fetchBacklogData(widget.project.projectId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BacklogProvider>.value(
          value: _backlogProvider,
        ),
        BlocProvider(
          create: (_) => getIt<UserProjectBloc>()
            ..add(FetchUserProjectByProjectIdEvent(widget.project.projectId!)),
        ),
        BlocProvider(
          create: (_) => getIt<EventBloc>()
            ..add(FetchEventsByProjectEvent(widget.project.projectId!)),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              children: [
                TopBar(project: widget.project, fatherContext: context,),
              ],
            ),
            SidebarLayout(
              project: widget.project,
              isSidebarOpen: isSidebarOpen,
              onToggle: toggleSidebar,
            ),
            SidebarToggleButton(
              isSidebarOpen: isSidebarOpen,
              onToggle: toggleSidebar,
            ),
          ],
        ),
      ),
    );
  }
}
