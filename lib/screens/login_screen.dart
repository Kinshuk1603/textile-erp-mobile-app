import 'package:flutter/material.dart';
import 'signup_screen.dart';
import '../widgets/logo_widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final String email;
  final String password;

  User({required this.email, required this.password});
}

class ApiService {
  Future<void> login(User user) async {
    final url = 'https://your-api-url.com/login'; // Replace with your API endpoint
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': user.email,
        'password': user.password,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to log in');
    }
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _emailError;
  List<String> _passwordErrors = [];
  bool _formSubmitted = false;
  bool _isPasswordVisible = false; 
  final ApiService _apiService = ApiService();

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _validateEmailField(String? value) {
    if (value == null || value.isEmpty) {
      _emailError = 'Please enter your email';
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
      _emailError = 'Invalid email format';
    } else {
      _emailError = null;
    }
  }

  void _validatePasswordField(String? value) {
    _passwordErrors.clear();

    if (value == null || value.isEmpty) {
      _passwordErrors.add('Please enter your password');
    } else {
      if (value.length < 6 || value.length > 15) {
        _passwordErrors.add('6 - 15 characters required');
      }
      if (!RegExp(r'[A-Z]').hasMatch(value)) {
        _passwordErrors.add('At least one uppercase letter required');
      }
      if (!RegExp(r'[a-z]').hasMatch(value)) {
        _passwordErrors.add('At least one lowercase letter required');
      }
      if (!RegExp(r'[0-9]').hasMatch(value)) {
        _passwordErrors.add('At least one number required');
      }
      if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
        _passwordErrors.add('At least one special character required');
      }
    }
  }

  void _login() async {
    setState(() {
      _formSubmitted = true;
      _validateEmailField(_emailController.text);
      _validatePasswordField(_passwordController.text);
    });

    if (_emailError == null && _passwordErrors.isEmpty) {
      final user = User(
        email: _emailController.text,
        password: _passwordController.text,
      );

      try {
        await _apiService.login(user);
        _showSuccessDialog('Login successful! You are signed in.');
      } catch (error) {
        print('Login Error: $error');
        _showErrorDialog('Login failed. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 223, 243, 255),
      appBar: AppBar(
        title: Row(
          children: [
            LogoWidget(size: 45),
            SizedBox(width: 30),
            Expanded(
              child: Text(
                'Login',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
        elevation: 10,
        shadowColor: Colors.blueAccent.withOpacity(0.5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(blurRadius: 6, color: Colors.grey.withOpacity(0.5)),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Login to Your Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                      errorText: _formSubmitted ? _emailError : null,
                    ),
                    onChanged: (value) {
                      _validateEmailField(value);
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    onChanged: (value) {
                      _validatePasswordField(value);
                      setState(() {});
                    },
                  ),
                  if (_formSubmitted && _passwordErrors.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _passwordErrors.map((error) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        );
                      }).toList(),
                    ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => SignUpScreen()),
                          );
                        },
                        child: Text('Sign Up'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
