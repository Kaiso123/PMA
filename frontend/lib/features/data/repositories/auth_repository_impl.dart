import 'package:doan/features/data/datasources/auth_remote_data_source.dart';
import 'package:doan/features/domain/entities/user.dart';
import 'package:doan/features/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> loginUser(String username, String password) async {
    try {
      final userModel = await remoteDataSource.loginUser(username, password);
      return userModel.toEntity();
    } catch (e) {
      throw Exception('Error logging in: $e');
    }
  }

  Future<void> register({
    required String username,
    required String password,
    required String email,
    required String name,
  }) async {
    await remoteDataSource.register(
      username: username,
      password: password,
      email: email,
      name: name,
    );
  }
}
