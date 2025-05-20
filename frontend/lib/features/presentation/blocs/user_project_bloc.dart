import 'package:doan/features/domain/entities/userProject.dart';
import 'package:doan/features/domain/usecases/userProject_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// UserProject Events
abstract class UserProjectEvent {}

class CreateUserProjectEvent extends UserProjectEvent {
  final UserProject userProject;
  CreateUserProjectEvent(this.userProject);
}

class FetchAllUserProjectsEvent extends UserProjectEvent {}

class DeleteUserProjectEvent extends UserProjectEvent {
  final int userProjectId;
  DeleteUserProjectEvent(this.userProjectId);
}

class InviteUserToProjectEvent extends UserProjectEvent {
  final String inviteCode;
  final int userId;
  final bool isManager;
  InviteUserToProjectEvent({
    required this.inviteCode,
    required this.userId,
    this.isManager = false,
  });
}

class FetchUserProjectByProjectIdEvent extends UserProjectEvent {
  final int projectId;
  FetchUserProjectByProjectIdEvent(this.projectId);
}

// UserProject States
abstract class UserProjectState {}

class UserProjectInitial extends UserProjectState {}

class UserProjectLoading extends UserProjectState {}

class UserProjectsLoaded extends UserProjectState {
  final List<UserProject> userProjects;
  UserProjectsLoaded(this.userProjects);
}

class UserProjectSuccess extends UserProjectState {
  final String message;
  UserProjectSuccess(this.message);
}

class UserProjectError extends UserProjectState {
  final String message;
  UserProjectError(this.message);
}

// UserProject Bloc
class UserProjectBloc extends Bloc<UserProjectEvent, UserProjectState> {
  final CreateUserProject createUserProject;
  final GetAllUserProjects getAllUserProjects;
  final DeleteUserProject deleteUserProject;
  final InviteUserToProject inviteUserToProject;
  final GetUserProjectByProjectId getUserProjectByProjectId;

  UserProjectBloc({
    required this.createUserProject,
    required this.getAllUserProjects,
    required this.deleteUserProject,
    required this.inviteUserToProject,
    required this.getUserProjectByProjectId,
  }) : super(UserProjectInitial()) {
    on<CreateUserProjectEvent>(_onCreateUserProject);
    on<FetchAllUserProjectsEvent>(_onFetchAllUserProjects);
    on<DeleteUserProjectEvent>(_onDeleteUserProject);
    on<InviteUserToProjectEvent>(_onInviteUserToProject);
    on<FetchUserProjectByProjectIdEvent>(_onFetchUserProjectByProjectId);
  }

  Future<void> _onCreateUserProject(
      CreateUserProjectEvent event, Emitter<UserProjectState> emit) async {
    emit(UserProjectLoading());
    try {
      final userProject = await createUserProject(event.userProject);
      emit(UserProjectSuccess(
          'User assigned to project successfully: User ${userProject.userId}'));
    } catch (e) {
      emit(UserProjectError('Failed to assign user to project: $e'));
    }
  }

  Future<void> _onFetchAllUserProjects(
      FetchAllUserProjectsEvent event, Emitter<UserProjectState> emit) async {
    emit(UserProjectLoading());
    try {
      final userProjects = await getAllUserProjects(null);
      emit(UserProjectsLoaded(userProjects));
    } catch (e) {
      emit(UserProjectError('Failed to fetch user projects: $e'));
    }
  }

  Future<void> _onDeleteUserProject(
      DeleteUserProjectEvent event, Emitter<UserProjectState> emit) async {
    emit(UserProjectLoading());
    try {
      await deleteUserProject(event.userProjectId);
      emit(UserProjectSuccess('User project deleted successfully'));
    } catch (e) {
      emit(UserProjectError('Failed to delete user project: $e'));
    }
  }

  Future<void> _onInviteUserToProject(
      InviteUserToProjectEvent event, Emitter<UserProjectState> emit) async {
    emit(UserProjectLoading());
    try {
      final userProjectId = await inviteUserToProject(InviteUserParams(
        inviteCode: event.inviteCode,
        userId: event.userId,
        isManager: event.isManager,
      ));
      emit(UserProjectSuccess(
          'User invited to project successfully: UserProjectId $userProjectId'));
    } catch (e) {
      emit(UserProjectError('Failed to invite user to project: $e'));
    }
  }

  Future<void> _onFetchUserProjectByProjectId(
      FetchUserProjectByProjectIdEvent event, Emitter<UserProjectState> emit) async {
    emit(UserProjectLoading());
    try {
      final userProjects = await getUserProjectByProjectId(event.projectId);
      emit(UserProjectsLoaded(userProjects));
    } catch (e) {
      emit(UserProjectError('Failed to fetch users in project: $e'));
    }
  }
}