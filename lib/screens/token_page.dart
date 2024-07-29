import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../services/auth_service.dart';

class ProtectedPage extends StatefulWidget {
  @override
  _ProtectedPageState createState() => _ProtectedPageState();
}

class _ProtectedPageState extends State<ProtectedPage> {
  final AuthService _authService = AuthService();
  String? _message;

  @override
  void initState() {
    super.initState();
    _fetchProtectedData();
  }

  Future<void> _fetchProtectedData() async {
    final headers = await _authService.getAuthHeaders();
    final response = await http.get(
      Uri.parse('http://localhost/phalc/protected'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _message = data['message'];
      });
    } else {
      setState(() {
        _message = 'Error fetching data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Protected Page')),
      body: Center(
        child: _message != null
            ? Text(_message!)
            : CircularProgressIndicator(),
      ),
    );
  }
}
