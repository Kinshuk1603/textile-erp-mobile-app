// lib/server_connection_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ServerConnectionScreen extends StatefulWidget {
  const ServerConnectionScreen({Key? key}) : super(key: key);

  @override
  _ServerConnectionScreenState createState() => _ServerConnectionScreenState();
}

class _ServerConnectionScreenState extends State<ServerConnectionScreen> {
  String _message = 'Connecting...';

  @override
  void initState() {
    super.initState();
    _fetchMessageFromServer();
  }

  Future<void> _fetchMessageFromServer() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:5000/')); // Update with your port number

      if (response.statusCode == 200) {
        setState(() {
          _message = response.body; // Get the response message
        });
      } else {
        setState(() {
          _message = 'Failed to connect to the server.';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Server Connection'),
      ),
      body: Center(
        child: Text(
          _message,
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
