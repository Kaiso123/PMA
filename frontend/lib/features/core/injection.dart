import 'package:doan/features/core/api_client.dart';
import 'package:doan/features/data/datasources/auth_remote_data_source.dart';
import 'package:doan/features/data/datasources/backlog_remote_data_source.dart';
import 'package:doan/features/data/datasources/event_remote_data_source.dart';
import 'package:doan/features/data/datasources/project_remote_data_source.dart';
import 'package:doan/features/data/repositories/auth_repository_impl.dart';
import 'package:doan/features/data/repositories/backlog_repository_impl.dart';
import 'package:doan/features/data/repositories/event_repository_impl.dart';
import 'package:doan/features/data/repositories/project_repository_impl.dart';
import 'package:doan/features/domain/repositories/auth_repository.dart';
import 'package:doan/features/domain/repositories/backlog_repository.dart';
import 'package:doan/features/domain/repositories/event_repository.dart';
import 'package:doan/features/domain/repositories/project_repository.dart';
import 'package:doan/features/domain/usecases/auth_usecase.dart';
import 'package:doan/features/domain/usecases/backlog_usecase.dart';
import 'package:doan/features/domain/usecases/event_usecase.dart';
import 'package:doan/features/domain/usecases/project_usecase.dart';
import 'package:doan/features/domain/usecases/task_usecase.dart';
import 'package:doan/features/domain/usecases/userProject_usecase.dart';
import 'package:doan/features/presentation/blocs/auth_bloc.dart';
import 'package:doan/features/presentation/blocs/backlog_provider2.dart';
import 'package:doan/features/presentation/blocs/event_bloc.dart';
import 'package:doan/features/presentation/blocs/project_bloc.dart';
import 'package:doan/features/presentation/blocs/task_bloc.dart';
import 'package:doan/features/presentation/blocs/user_project_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:doan/features/data/datasources/task_remote_data_source.dart';
import 'package:doan/features/data/repositories/task_repository_impl.dart';
import 'package:doan/features/domain/repositories/task_repository.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  //Core
  getIt.registerSingleton<ApiClient>(
    ApiClient(baseUrl: 'http://192.168.1.200:7105'),
  );
  // Data
  getIt.registerLazySingleton(() => http.Client());
  getIt.registerLazySingleton<ProjectRemoteDataSource>(
    () => ProjectRemoteDataSource(apiClient: getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(
        remoteDataSource: getIt<ProjectRemoteDataSource>()),
  );
  getIt.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSource(client: getIt<http.Client>()),
  );
  getIt.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(remoteDataSource: getIt<TaskRemoteDataSource>()),
  );
  getIt.registerSingleton<BacklogRemoteDataSource>(
    BacklogRemoteDataSource(apiClient: getIt<ApiClient>()),
  );
  getIt.registerSingleton<BacklogRepository>(
    BacklogRepositoryImpl(remoteDataSource: getIt<BacklogRemoteDataSource>()),
  );
  getIt.registerLazySingleton<EventRemoteDataSource>(
    () => EventRemoteDataSource(apiClient: getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<EventRepository>(
    () => EventRepositoryImpl(remoteDataSource: getIt<EventRemoteDataSource>()),
  );
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(apiClient: getIt<ApiClient>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: getIt<AuthRemoteDataSource>()),
  );
  //UseCase
  //Task
  getIt.registerLazySingleton(() => CreateTask(getIt<TaskRepository>()));
  getIt.registerLazySingleton(() => UpdateTask(getIt<TaskRepository>()));
  getIt.registerLazySingleton(() => DeleteTask(getIt<TaskRepository>()));
  getIt.registerLazySingleton(() => GetTasksByProject(getIt<TaskRepository>()));
  getIt.registerLazySingleton(() => GetTaskById(getIt<TaskRepository>()));
  getIt.registerLazySingleton(() => GetAllTasks(getIt<TaskRepository>()));
  //Project
  getIt.registerLazySingleton(() => CreateProject(getIt<ProjectRepository>()));
  getIt.registerLazySingleton(
      () => GetProjectsByUser(getIt<ProjectRepository>()));
  getIt.registerLazySingleton(
      () => AssignTaskToProject(getIt<ProjectRepository>()));
  // UserProject Use Cases
  getIt.registerLazySingleton(
      () => CreateUserProject(getIt<ProjectRepository>()));
  getIt.registerLazySingleton(
      () => GetAllUserProjects(getIt<ProjectRepository>()));
  getIt.registerLazySingleton(
      () => DeleteUserProject(getIt<ProjectRepository>()));
  getIt.registerLazySingleton(
      () => InviteUserToProject(getIt<ProjectRepository>()));
  getIt.registerLazySingleton(
      () => GetUserProjectByProjectId(getIt<ProjectRepository>()));
  //Backlog
  getIt.registerSingleton<GetSprints>(
    GetSprints(getIt<BacklogRepository>()),
  );
  getIt.registerSingleton<GetIssues>(
    GetIssues(getIt<BacklogRepository>()),
  );
  getIt.registerSingleton<CreateSprint>(
    CreateSprint(getIt<BacklogRepository>()),
  );
  getIt.registerSingleton<CreateIssue>(
    CreateIssue(getIt<BacklogRepository>()),
  );
  getIt.registerSingleton<UpdateIssue>(
    UpdateIssue(getIt<BacklogRepository>()),
  );
  getIt.registerSingleton<UpdateSprint>(
    UpdateSprint(getIt<BacklogRepository>()),
  );
  getIt.registerSingleton<DeleteSprint>(
    DeleteSprint(getIt<BacklogRepository>()),
  );
  getIt.registerSingleton<DeleteIssue>(
    DeleteIssue(getIt<BacklogRepository>()),
  );
  // Event
  getIt.registerLazySingleton(
      () => GetEventsByProject(getIt<EventRepository>()));
  getIt.registerLazySingleton(() => CreateEvent(getIt<EventRepository>()));
  getIt.registerLazySingleton(() => UpdateEvent(getIt<EventRepository>()));
  getIt.registerLazySingleton(() => DeleteEvent(getIt<EventRepository>()));
  // Auth
  getIt.registerLazySingleton(() => LoginUser(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => RegisterUser(getIt<AuthRepository>()));
  // Bloc
  getIt.registerFactory(() => TaskBloc(
        createTask: getIt<CreateTask>(),
        updateTask: getIt<UpdateTask>(),
        deleteTask: getIt<DeleteTask>(),
        getTasksByProject: getIt<GetTasksByProject>(),
        getTaskById: getIt<GetTaskById>(),
        getAllTasks: getIt<GetAllTasks>(),
      ));
  getIt.registerFactory(() => ProjectBloc(
        createProject: getIt<CreateProject>(),
        getProjectsByUser: getIt<GetProjectsByUser>(),
        assignTaskToProject: getIt<AssignTaskToProject>(),
      ));
  getIt.registerFactory(() => UserProjectBloc(
        createUserProject: getIt<CreateUserProject>(),
        getAllUserProjects: getIt<GetAllUserProjects>(),
        deleteUserProject: getIt<DeleteUserProject>(),
        inviteUserToProject: getIt<InviteUserToProject>(),
        getUserProjectByProjectId: getIt<GetUserProjectByProjectId>(),
      ));
  getIt.registerFactory<BacklogProvider>(
    () => BacklogProvider(
      getSprintsUseCase: getIt<GetSprints>(),
      getIssuesUseCase: getIt<GetIssues>(),
      createSprintUseCase: getIt<CreateSprint>(),
      createIssueUseCase: getIt<CreateIssue>(),
      updateIssueUseCase: getIt<UpdateIssue>(),
      updateSprintUseCase: getIt<UpdateSprint>(),
      deleteSprintUseCase: getIt<DeleteSprint>(),
      deleteIssueUseCase: getIt<DeleteIssue>(),
    ),
  );
  getIt.registerFactory(() => EventBloc(
        getEventsByProject: getIt<GetEventsByProject>(),
        createEvent: getIt<CreateEvent>(),
        updateEvent: getIt<UpdateEvent>(),
        deleteEvent: getIt<DeleteEvent>(),
      ));
  getIt.registerFactory(() => AuthBloc(
        loginUser: getIt<LoginUser>(),
        registerUser: getIt<RegisterUser>(),
      ));
}
