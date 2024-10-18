import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../config.dart'; // Import the config file

class ApiService {
  Future<void> signUp(User newUser) async {
  try {
    final response = await http.post(
      Uri.parse('${Config.baseUrl}/signup'), // Use the base URL from Config
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newUser.toMap()),
    );

    if (response.statusCode == 200) {
      // Successfully signed up
      print('User created successfully');
      // You could also return early here if you wanted to prevent further processing.
    } else {
      // Handle error message from server
      final responseData = json.decode(response.body);
      throw Exception(responseData['message'] ?? 'Failed to sign up');
    }
  } catch (e) {
    print('Error during sign up: $e');
    throw Exception('Failed to sign up: $e');
  }
}


  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${Config.baseUrl}/login'), // Use the base URL from Config
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        // Successfully logged in
        return true;
      } else {
        // Handle error message from server
        final responseData = json.decode(response.body);
        throw Exception(responseData['message'] ?? 'Failed to log in');
      }
    } catch (e) {
      print('Error during login: $e');
      throw Exception('Failed to log in: $e');
    }
  }
}
