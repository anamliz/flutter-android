import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import '../model/users.dart';

import 'home_page.dart';

final Logger logger = Logger();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Box<Users> _usersBox;
  late Box<String> _tokenBox;
  List<Map<String, dynamic>> _usersList = [];

 
  final TextEditingController _useruserNameController = TextEditingController();
  final TextEditingController _userpasswordController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      _usersBox = await Hive.openBox<Users>('UsersBox');
      _tokenBox = await Hive.openBox<String>('TokenBox');
      print('users Box Initialized: $_usersBox');
      print('token Box Initialized: $_tokenBox');
      await _fetchUsers();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      logger.e('Error initializing data: $e');
    }
  }

  Future<void> _fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost/phalc/Login'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse["status"] == "success") {
          setState(() {
            _usersList = (jsonResponse["data"] as List<dynamic>)
                .map((item) => item as Map<String, dynamic>)
                .toList();
          });

          for (var usersData in _usersList) {
            try {
              final user = Users.fromJson(usersData);
              _usersBox.put(user.userid, user);
              logger.i('user added to _usersBox: ${user.toJson()}');
            } catch (e) {
              logger.e('Error parsing users data: $e');
              logger.d('Users data: $usersData');
            }
          }
          logger.i('usersBox now has ${_usersBox.length} entries');
        } else {
          throw Exception("Unable to get user.");
        }
      } else {
        logger.e('Failed to fetch users: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error fetching users: $e');
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
      if (useruserName.isEmpty || userpassword.isEmpty) {
        _showErrorDialog('All fields are required');
        return;
      }

      Map<String, dynamic> payload = {
        'useruserName': useruserName,
        'userpassword': userpassword,
      };

      final response = await login(payload);
      print(response);
      if (response['status'] == 'success') {
        logger.i('user logged in successfully');
        _tokenBox.put('jwtToken', response['token']);
        logger.i('tokenBox now has ${_tokenBox.length} entries');
        logger.i('Token stored in tokenBox: ${_tokenBox.get('jwtToken')}');

      

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } else {
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
    print(response.body);
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
}