import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:doan/features/domain/entities/user.dart';
import 'package:doan/features/domain/usecases/auth_usecase.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginUserEvent extends AuthEvent {
  final String username;
  final String password;

  const LoginUserEvent(this.username, this.password);

  @override
  List<Object?> get props => [username, password];
}

class RegisterUserEvent extends AuthEvent {
  final String username;
  final String password;
  final String email;
  final String name;

  const RegisterUserEvent({
    required this.username,
    required this.password,
    required this.email,
    required this.name,
  });

  @override
  List<Object?> get props => [username, password, email, name];
}

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;

  const AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthRegisterSuccess extends AuthState {
  final String message;

  const AuthRegisterSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;

  AuthBloc({
    required this.loginUser,
    required this.registerUser,
  }) : super(AuthInitial()) {
    on<LoginUserEvent>(_onLoginUser);
    on<RegisterUserEvent>(_onRegisterUser);
  }

  Future<void> _onLoginUser(LoginUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await loginUser(event.username, event.password);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onRegisterUser(RegisterUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await registerUser(
        username: event.username,
        password: event.password,
        email: event.email,
        name: event.name,
      );
      emit(const AuthRegisterSuccess('Registration successful'));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}