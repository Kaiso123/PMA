import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:doan/features/data/models/user_model.dart';

class AuthRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'http://192.168.170.200:7105/api/users';

  AuthRemoteDataSource({required this.client});

  Future<UserModel> loginUser(String username, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      if (jsonMap['ec'] == 0) {
        return UserModel(
          userId: jsonMap['dt'] as int,
          username: username,
        );
      } else {
        throw Exception(jsonMap['em'] ?? 'Failed to login');
      }
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<void> register({
    required String username,
    required String password,
    required String email,
    required String name,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'email': email,
        'name': name,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      if (data['ec'] == 0) {
        return;
      } else {
        throw Exception(data['em']);
      }
    } else {
      throw Exception('Failed to register');
    }
  }
}
