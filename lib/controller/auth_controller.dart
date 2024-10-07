import 'dart:convert'; // เพิ่ม import สำหรับการเข้าถึง jsonEncode และ jsonDecode
import 'package:flutter/material.dart';

import 'package:mongo_flutter_lab_1/models/user_models.dart';
import 'package:http/http.dart' as http;
import 'package:mongo_flutter_lab_1/providers/user_provider.dart';
import 'package:mongo_flutter_lab_1/varibles.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  Future<UserModel> login(
      BuildContext context, String email, String password) async {
    print(email);
    print(password);

    final response = await http.post(
      Uri.parse("$apiURL/api/auth/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print('Response data: $data'); // Log the full response data
      UserModel userModel = UserModel.fromJson(data);
      return userModel;
    } else {
      throw Exception(
          'Error: Invalid response structure (Status Code: ${response.statusCode})');
    }
  }

  // Register method
  // Future<void> register(
  //     String username, String password, String name, String tel, String email, String role) async {
  //   final response = await http.post(
  //     Uri.parse("$apiURL/api/auth/register"),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode(<String, String>{
  //       'user_name': username,
  //       'password': password,
  //       'name': name,
  //       "tel": tel,
  //       "email": email,
  //       'role': role,
  //     }),
  //   );

  //   print('Response body: ${response.body}'); // Print the response body

  //   if (response.statusCode == 201) {
  //     // If registration is successful, handle success (e.g., navigate to login page)
  //     print('User registered successfully');
  //     return; // No need to return UserModel if the response isn't JSON
  //   } else {
  //     throw Exception('Failed to register');
  //   }
  // }

  Future<void> register(BuildContext context, String username, String password,
      String name, String role, String email, String tel) async {
    final Map<String, dynamic> registerData = {
      "username": username,
      "password": password,
      "name": name,
      "tel": tel,
      "role": role,
      "email": email,
    };

    final response = await http.post(
      Uri.parse("$apiURL/api/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(registerData),
    );

    print(response.statusCode);

    if (response.statusCode == 201) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      print(
          'Registration failed: ${response.body}'); // Log response body on failure
      throw Exception(
          'Failed to register user (Status Code: ${response.statusCode})');
    }
  }

  // Function to logout (optional)
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
  }

  Future<void> refreshToken(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final response = await http.post(
      Uri.parse("$apiURL/api/auth/refresh"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${userProvider.refreshToken}",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      print(data);

      final accessToken = data['accessToken'];
      userProvider.updateAccessToken(accessToken); // แก้ไขให้รับแค่ accessToken
    } else {
      throw Exception('Failed to refresh token');
    }
  }
}
