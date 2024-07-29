import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class AuthService {
  final String baseUrl = 'http://localhost/phalc/Login';
  
 //final Box  tokenBox = Hive.box('TokenBox');
 final Box  tokenBox = Hive.box<String>('TokenBox');

  Future<String?> login(String useruserName, String userpassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/phalc/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'useruserName': useruserName, 'userpassword': userpassword}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['token'] != null) {
         await tokenBox.put('jwtToken', data['token']);
       
        return null;
      } else {
        return data['error'];
      }
    } else {
      return 'Error logging in';
    }
  }

  Future<void> logout() async {
    await tokenBox.delete('jwt_token');
  }

  Future<Map<String, String>> getAuthHeaders() async {
    final token = tokenBox.get('jwt_token');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
