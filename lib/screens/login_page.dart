import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

import 'home_page.dart';

final Logger logger = Logger();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _useruserNameController = TextEditingController();
  final TextEditingController _userpasswordController = TextEditingController();

 // Create an instance of the Users class
  //final Users _user = Users();

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
              decoration: const InputDecoration(labelText: 'User_Name'),
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
    
    
    // Prepare LOGIN data
    Map<String, dynamic> payload = {
      'useruserName': useruserName,
      'userpassword': userpassword,
    };

    
      final response = await login(payload);
      print(response);
      if (response['status'] == 'success') {
        logger.i('user logged in successfully');
       // _showSuccessDialog();
        // Redirect to success page or do something else
       Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>  HomePage(), 
        ),
      );
      } else  {
        _showErrorDialog('login failed:${response['message']}');
        
      }
    } catch (e) {
      logger.e('Error occurred during login: $e');
      _showErrorDialog('Invalid password or userName: $e');
      
    }
  }

  Future<Map<String, dynamic>> login(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('http://localhost/phalc/Login'), 
      body: jsonEncode(payload),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var json = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return json;
    } else {
      if (json["message"] != null) {
        throw Exception(json["message"]);
      }
      throw Exception('User does not exist: ${response.statusCode}');
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

/*  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('User logged in successfully'),
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
  }*/
}
