import 'package:doan/features/domain/usecases/project_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doan/features/domain/entities/project.dart';
import 'package:doan/features/domain/entities/task.dart';


// Project Events
abstract class ProjectEvent {}

class CreateProjectEvent extends ProjectEvent {
  final Project project;
  CreateProjectEvent(this.project);
}

class FetchProjectsByUserEvent extends ProjectEvent {
  final int userId;
  FetchProjectsByUserEvent(this.userId);
}

class AssignTaskToProjectEvent extends ProjectEvent {
  final int projectId;
  final Task task;
  AssignTaskToProjectEvent(this.projectId, this.task);
}

// Project States
abstract class ProjectState {}

class ProjectInitial extends ProjectState {}

class ProjectLoading extends ProjectState {}

class ProjectsLoaded extends ProjectState {
  final List<Project> projects;
  ProjectsLoaded(this.projects);
}

class ProjectSuccess extends ProjectState {
  final String message;
  ProjectSuccess(this.message);
}

class ProjectError extends ProjectState {
  final String message;
  ProjectError(this.message);
}

// Project Bloc
class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  final CreateProject createProject;
  final GetProjectsByUser getProjectsByUser;
  final AssignTaskToProject assignTaskToProject;

  ProjectBloc({
    required this.createProject,
    required this.getProjectsByUser,
    required this.assignTaskToProject,
  }) : super(ProjectInitial()) {
    on<CreateProjectEvent>(_onCreateProject);
    on<FetchProjectsByUserEvent>(_onFetchProjectsByUser);
    on<AssignTaskToProjectEvent>(_onAssignTaskToProject);
  }

  Future<void> _onCreateProject(CreateProjectEvent event, Emitter<ProjectState> emit) async {
    emit(ProjectLoading());
    try {
      final project = await createProject(event.project);
      emit(ProjectSuccess('Project created successfully: ${project.name}'));
    } catch (e) {
      emit(ProjectError('Failed to create project: $e'));
    }
  }

  Future<void> _onFetchProjectsByUser(FetchProjectsByUserEvent event, Emitter<ProjectState> emit) async {
    emit(ProjectLoading());
    try {
      final projects = await getProjectsByUser(event.userId);
      emit(ProjectsLoaded(projects));
    } catch (e) {
      emit(ProjectError('Failed to fetch projects: $e'));
    }
  }

  Future<void> _onAssignTaskToProject(AssignTaskToProjectEvent event, Emitter<ProjectState> emit) async {
    emit(ProjectLoading());
    try {
      await assignTaskToProject(AssignTaskParams(projectId: event.projectId, task: event.task));
      emit(ProjectSuccess('Task assigned to project successfully'));
    } catch (e) {
      emit(ProjectError('Failed to assign task to project: $e'));
    }
  }
}