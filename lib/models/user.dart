// lib/models/user.dart

class User {
  final String username; // Add username field
  final String email;
  final String password;
  final String role;

  User({
    required this.username, // Update constructor
    required this.email,
    required this.password,
    required this.role,
  });

  // Convert a User object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'username': username, // Include username in the map
      'email': email,
      'password': password,
      'role': role,
    };
  }

  // Create a User object from a Map object
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      username: map['username'], // Map username
      email: map['email'],
      password: map['password'],
      role: map['role'],
    );
  }
}
