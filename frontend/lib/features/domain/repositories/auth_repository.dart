import 'package:doan/features/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> loginUser(String username, String password);
  Future<void> register({
    required String username,
    required String password,
    required String email,
    required String name,
  });
}