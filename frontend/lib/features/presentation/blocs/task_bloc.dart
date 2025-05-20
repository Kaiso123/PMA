import 'package:doan/features/domain/usecases/task_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doan/features/domain/entities/task.dart';

// Task Events
abstract class TaskEvent {}

class CreateTaskEvent extends TaskEvent {
  final Task task;
  CreateTaskEvent(this.task);
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;
  UpdateTaskEvent(this.task);
}

class DeleteTaskEvent extends TaskEvent {
  final int taskId;
  DeleteTaskEvent(this.taskId);
}

class FetchTasksByProjectEvent extends TaskEvent {
  final int projectId;
  FetchTasksByProjectEvent(this.projectId);
}

class FetchTaskByIdEvent extends TaskEvent {
  final int taskId;
  FetchTaskByIdEvent(this.taskId);
}

class FetchAllTasksEvent extends TaskEvent {}

// Task States
abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  TaskLoaded(this.tasks);
}

class TaskDetailLoaded extends TaskState {
  final Task task;
  TaskDetailLoaded(this.task);
}

class TaskSuccess extends TaskState {
  final String message;
  TaskSuccess(this.message);
}

class TaskError extends TaskState {
  final String message;
  TaskError(this.message);
}

// Task Bloc
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final CreateTask createTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;
  final GetTasksByProject getTasksByProject;
  final GetTaskById getTaskById;
  final GetAllTasks getAllTasks;

  TaskBloc({
    required this.createTask,
    required this.updateTask,
    required this.deleteTask,
    required this.getTasksByProject,
    required this.getTaskById,
    required this.getAllTasks,
  }) : super(TaskInitial()) {
    on<CreateTaskEvent>(_onCreateTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<FetchTasksByProjectEvent>(_onFetchTasksByProject);
    on<FetchTaskByIdEvent>(_onFetchTaskById);
    on<FetchAllTasksEvent>(_onFetchAllTasks);
  }

  Future<void> _onCreateTask(
      CreateTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await createTask(event.task);
      emit(TaskSuccess('Task created successfully'));
    } catch (e) {
      emit(TaskError('Failed to create task: $e'));
    }
  }

  Future<void> _onUpdateTask(
      UpdateTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await updateTask(event.task);
      emit(TaskSuccess('Task updated successfully'));
    } catch (e) {
      emit(TaskError('Failed to update task: $e'));
    }
  }

  Future<void> _onDeleteTask(
      DeleteTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      await deleteTask(event.taskId);
      emit(TaskSuccess('Task deleted successfully'));
    } catch (e) {
      emit(TaskError('Failed to delete task: $e'));
    }
  }

  Future<void> _onFetchTasksByProject(
      FetchTasksByProjectEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await getTasksByProject(event.projectId);
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError('Failed to fetch tasks: $e'));
    }
  }

  Future<void> _onFetchTaskById(
      FetchTaskByIdEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final task = await getTaskById(event.taskId);
      emit(TaskDetailLoaded(task));
    } catch (e) {
      emit(TaskError('Failed to fetch task: $e'));
    }
  }

  Future<void> _onFetchAllTasks(
      FetchAllTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await getAllTasks(null);
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError('Failed to fetch all tasks: $e'));
    }
  }
}
