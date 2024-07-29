/*
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

import '../model/login.dart';
import 'home_page.dart';

final Logger logger = Logger();

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Box<Login> _loginBox;
  final TextEditingController _useruserNameController = TextEditingController();
  final TextEditingController _userpasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      _loginBox = await Hive.openBox<Login>('LoginBox');
      // _loginBox.clear();
       
      print('Login Box Initialized: $_loginBox');
        
    } catch (e) {
      logger.e('Error initializing data: $e');
      
    }
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _useruserNameController,
                decoration: const InputDecoration(labelText: 'User Name'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _userpasswordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _loginForm,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
void _loginForm() async {
  final String useruserName = _useruserNameController.text;
  final String userpassword = _userpasswordController.text;

  try {
    // Validate form fields
    if (useruserName.isEmpty || userpassword.isEmpty) {
      _showErrorDialog('All fields are required');
      return;
    }

    // Prepare login payload
    Map<String, dynamic> payload = {'useruserName': useruserName, 'userpassword': userpassword};

    final response = await login(payload);

    logger.d('Login Response: $response');

    // Check if response is not null and status is success
    if (response != null && response['status'] == 'success') {
      logger.i('User logged in successfully');

      // If data key exists in the response, parse user data from response
      if (response.containsKey('data')) {
        final userData = response['data'];

        // Create a Login instance from the response data
        final login = Login.fromJson(userData);

        // Store login details in Hive
        await _loginBox.put(login.userid, login);
        print('loginBox now has ${_loginBox.length} entries');
        // print('placesBox now has ${_placesBox.length} entries');
         print('Login added to _loginBox: ${login.toJson()}');
          
        // Clear text fields after successful login
        //_useruserNameController.clear();
        //_userpasswordController.clear();

        // Navigate to HomePage
      //  Navigator.of(context).pushReplacement(
         // MaterialPageRoute(
         //   builder: (context) => HomePage(),
         // ),
        //);
      } else {
        // Handle case when no 'data' key present in the response
        logger.d('No "data" key found in the response.');
        

        // Navigate to HomePage since authentication was successful
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    } else {
      logger.e('Login failed: ${response['message']}');
      _showErrorDialog('Login failed: ${response['message']}');
    }
  } catch (e) {
    logger.e('Error occurred during login: $e');
    _showErrorDialog('Error occurred during login: $e');
  }
}

  Future<Map<String, dynamic>> login(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('http://localhost/phalc/Login'), // Replace with your actual login URL
      body: jsonEncode(payload),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
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
}*/