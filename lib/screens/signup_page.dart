

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

import 'login_page.dart';

final Logger logger = Logger();

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _userfirstNameController = TextEditingController();
  final TextEditingController _userlastNameController = TextEditingController();
  final TextEditingController _useremailController = TextEditingController();
  final TextEditingController _userphoneNumberController = TextEditingController();
  final TextEditingController _useruserNameController = TextEditingController();
  final TextEditingController _userpasswordController = TextEditingController();
  final TextEditingController _userconfirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _userfirstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _userlastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: _useremailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _userphoneNumberController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
              TextField(
                controller: _useruserNameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _userpasswordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _userconfirmPasswordController,
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Signup'),
              ),
             /*  const SizedBox(height: 2.0),
            GestureDetector(
              onTap: () {
                // Navigate to homepage
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(), 
                  ),
                );
              },
            ),*/
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    final String userfirstName = _userfirstNameController.text;
    final String userlastName = _userlastNameController.text;
    final String useremail = _useremailController.text;
    final String userphoneNumber = _userphoneNumberController.text;
    final String useruserName = _useruserNameController.text;
    final String userpassword = _userpasswordController.text;
    final String userconfirmPassword = _userconfirmPasswordController.text;

    // Validate form fields
    if (userfirstName.isEmpty ||
        userlastName.isEmpty ||
        useremail.isEmpty ||
        userphoneNumber.isEmpty ||
        useruserName.isEmpty ||
        userpassword.isEmpty ||
        userconfirmPassword.isEmpty) {
      _showErrorDialog('All fields are required');
      return;
    }

    if (userpassword != userconfirmPassword) {
      _showErrorDialog('Passwords do not match');
      return;
    }

    // Prepare signup data
    Map<String, dynamic> payload = {
      'userfirstName': userfirstName,
      'userlastName': userlastName,
      'useremail': useremail,
      'userphoneNumber': userphoneNumber,
      'useruserName': useruserName,
      'userpassword': userpassword,
      'userconfirmpassword': userconfirmPassword,
    };

    try {
      final response = await signup(payload);
      if (response['status'] == 'Success') {
        logger.i('User created successfully');
        // Redirect to success page or do something else
        Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginPage(), 
        ),
      );
      } else {
        _showErrorDialog('Signup failed: ${response['message']}');
      }
    } catch (e) {
      logger.e('Error occurred during signup: $e');
      _showErrorDialog('An error occurred during signup error $e.');
    }
  }

  Future<Map<String, dynamic>> signup(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1/phalc/Signup'), 

      body: jsonEncode(payload),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return json;
    } else {
      if (json["message"] != null){
        throw Exception(json["message"]);
      }
      throw Exception('Failed to signup: ${response.statusCode}');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}


