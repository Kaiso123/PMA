import 'package:doan/features/core/api_client.dart';
import 'package:doan/features/data/models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource({required this.apiClient});

  Future<UserModel> loginUser(String username, String password) async {
    final response = await apiClient.post('api/users/login', {
      'username': username,
      'password': password,
    });

    final jsonMap = response;
    if (jsonMap['ec'] == 0) {
      return UserModel(
        userId: jsonMap['dt'] as int,
        username: username,
      );
    } else {
      throw Exception(jsonMap['em'] ?? 'Failed to login');
    }
  }

  Future<void> register({
    required String username,
    required String password,
    required String email,
    required String name,
  }) async {
     final response = await apiClient.post('api/users/register', {
      'username': username,
      'password': password,
      'email': email,
      'name': name,
    });

    if (response['ec'] == 0) {
      return;
    } else {
      throw Exception(response['em'] ?? 'Failed to register');
    }
  }
}
