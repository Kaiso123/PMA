import 'package:doan/features/domain/entities/user.dart';

class UserModel {
  final int? userId;
  final String? username;
  final String? password;
  final String? email;
  final int? age;
  final String? address;
  final String? gender;
  final int? phone;
  final String? name;

  const UserModel({
    this.userId,
    this.username,
    this.password,
    this.email,
    this.age,
    this.address,
    this.gender,
    this.phone,
    this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as int?,
      username: json['username'] as String?,
      password: json['password'] as String?,
      email: json['email'] as String?,
      age: json['age'] as int?,
      address: json['address'] as String?,
      gender: json['gender'] as String?,
      phone: json['phone'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'userId': userId,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (email != null) 'email': email,
      if (age != null) 'age': age,
      if (address != null) 'address': address,
      if (gender != null) 'gender': gender,
      if (phone != null) 'phone': phone,
      if (name != null) 'name': name,
    };
  }

  User toEntity() => User(
        userId: userId,
        username: username,
        password: password,
        email: email,
        age: age,
        address: address,
        gender: gender,
        phone: phone,
        name: name,
      );
}