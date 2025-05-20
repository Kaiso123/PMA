import 'package:doan/features/domain/entities/user.dart';
import 'package:doan/features/domain/repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<User> call(String username, String password) async {
    return await repository.loginUser(username, password);
  }
}

class RegisterUser {
  final AuthRepository repository;

  RegisterUser(this.repository);

  Future<void> call({
    required String username,
    required String password,
    required String email,
    required String name,
  }) async {
    await repository.register(
      username: username,
      password: password,
      email: email,
      name: name,
    );
  }
}