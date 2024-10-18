import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'login_screen.dart';
import '../widgets/logo_widget.dart';
import '../services/api_service.dart' as api; // Use a prefix for ApiService
import '../models/user.dart' as models; // Use a prefix for User

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'User'; // Default role
  final List<String> _roles = ['User', 'Admin', 'Moderator']; // Role options
  final api.ApiService _apiService = api.ApiService(); // Use the prefixed class
  bool _obscurePassword = true; // For password visibility toggle
  String? _usernameError; // Variable to hold username error
  String? _emailError; // Variable to hold email error
  List<String> _passwordErrors = []; // List to hold password error messages
  bool _formSubmitted = false; // Flag to track form submission

// Function to show success dialog
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
                Navigator.of(context).pop(); // Close the dialog
                // Navigate to login screen after dialog is dismissed
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Function to handle signup logic
  // Function to handle signup logic
  void _signUp() async {
    setState(() {
      _formSubmitted = true; // Set the flag to true on submission
      // Validate fields on submit
      _validateUsernameField(_usernameController.text);
      _validateEmailField(_emailController.text);
      _validatePassword(_passwordController.text);
    });

    // Check if the form is valid after validation
    if (_usernameError == null &&
        _emailError == null &&
        _passwordErrors.isEmpty) {
      final user = models.User(
        // Use the prefixed class
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        role: _selectedRole,
      );

      try {
        print(
            'Signing up user: ${user.username}, ${user.email}, ${user.role}');
        await _apiService.signUp(user);
        print("aa gya hai yha tk");
        // Handle successful signup, e.g., navigate to the login screen
        // Show success dialog before navigating to the login screen
        _showSuccessDialog('Signup successful! You are signed in.');
      } catch (error) {
        if (error is http.Response) {
          // If it's an HTTP error, print the status code and body
          print('Signup Error: ${error.statusCode} - ${error.body}');
        } else {
          // Log the error
          print('Signup Error: $error');
        }
        _showErrorDialog('Signup failed. Please try again.');
      }
    }
  }

  // Function to show error dialog
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

  // Validate the email field and show errors
  void _validateEmailField(String? value) {
    if (value == null || value.isEmpty) {
      _emailError = 'Enter your email'; // Error when empty
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value)) {
      _emailError = 'Invalid email format'; // Error for invalid format
    } else {
      _emailError = null; // Clear error
    }
  }

  // Validate the username field and show errors
  void _validateUsernameField(String? value) {
    if (value == null || value.isEmpty) {
      _usernameError = 'Enter username'; // Error when empty
    } else {
      _usernameError = null; // Clear error
    }
  }

  // Validate the password field and show errors as a list
  void _validatePassword(String? value) {
    _passwordErrors.clear(); // Clear previous errors
    if (value == null || value.isEmpty) {
      _passwordErrors.add('Enter password'); // Error when empty
    } else {
      if (value.length < 6 || value.length > 15) {
        _passwordErrors.add('6-15 characters required');
      }
      if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
        _passwordErrors.add('At least one uppercase letter required');
      }
      if (!RegExp(r'(?=.*[0-9])').hasMatch(value)) {
        _passwordErrors.add('At least one number required');
      }
      if (!RegExp(r'(?=.*[!@#\$&*~])').hasMatch(value)) {
        _passwordErrors.add('At least one special character required');
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
                'Sign Up',
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
                    'Create an Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Username TextField
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                      errorText: _formSubmitted
                          ? _usernameError
                          : null, // Show error after submission
                    ),
                    onChanged: (value) {
                      _validateUsernameField(
                          value); // Validate username on change
                      setState(() {}); // Rebuild to show errors
                    },
                  ),
                  SizedBox(height: 16),
                  // Email TextField
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                      errorText: _formSubmitted
                          ? _emailError
                          : null, // Show error after submission
                    ),
                    onChanged: (value) {
                      _validateEmailField(value); // Validate email on change
                      setState(() {}); // Rebuild to show errors
                    },
                  ),
                  SizedBox(height: 16),
                  // Password TextField with Eye Icon
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          errorText:
                              _formSubmitted && _passwordErrors.isNotEmpty
                                  ? _passwordErrors.first
                                  : null, // Show only the first error message
                        ),
                        onChanged: (value) {
                          _validatePassword(
                              value); // Validate password on change
                          setState(() {}); // Rebuild to show errors
                        },
                      ),
                      // Display password errors as a list
                      if (_formSubmitted && _passwordErrors.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _passwordErrors.map((error) {
                            return Text(
                              error,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Role Dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Select Role',
                    ),
                    value: _selectedRole,
                    items: _roles.map((role) {
                      return DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value!; // Update selected role
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Select a role';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  // Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _signUp,
                      child: Text('Sign Up'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.blue,
                        textStyle: TextStyle(fontSize: 18),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text(
                      'Already have an account? Login',
                      style: TextStyle(color: Colors.blue),
                    ),
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
