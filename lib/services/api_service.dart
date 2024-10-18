import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../config.dart'; // Import the config file

class ApiService {
  Future<void> signUp(User user) async {
    print('Sending request to: ${Config.baseUrl}/signup');
    try {
      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2:5000/api/auth/signup'), // Use the base URL from Config
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toMap()),
      );
      print('Response status: ${response.statusCode}');
      print(
          'Response body: ${response.body}'); // Log response body for debugging

      if (response.statusCode == 200 || response.statusCode == 201) {
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

  Future<void> login(String email, String password) async {
    print('Attempting to log in user: $email');

    // Log the API endpoint being used
    final url = '${Config.baseUrl}/login';
    print('Sending request to: $url');

    try {
      // Send the POST request
      final response = await http.post(
        Uri.parse(url), // Use the base URL from Config
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      // Log the status code and response body
      print('Response status: ${response.statusCode}');
      print(
          'Response body: ${response.body}'); // Log response body for debugging

      // Check for success response
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Login successful');
      } else {
        // Handle error message from server
        final responseData = json.decode(response.body);
        print(
            'Login failed: ${responseData['message']}'); // Log specific error message
        throw Exception(responseData['message'] ?? 'Failed to log in');
      }
    } catch (e) {
      print('Error during login: $e');
      throw Exception('Failed to log in: $e');
    }
  }
}
