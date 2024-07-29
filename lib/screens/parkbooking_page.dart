// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:hidden/widgets/common_scaffold.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

import '../model/users.dart';



class ParkbookingPage extends StatefulWidget {
  final String title;

  const ParkbookingPage({Key? key, required this.title}) : super(key: key);

  @override
  State<ParkbookingPage> createState() => _ParkbookingPageState();
}

class _ParkbookingPageState extends State<ParkbookingPage> {
  final Logger logger = Logger();

  final TextEditingController _useridController = TextEditingController();
  final TextEditingController _park_idController = TextEditingController();
  // ignore: non_constant_identifier_names
  final TextEditingController _booking_dateController = TextEditingController();
  final TextEditingController _num_ticketsController = TextEditingController();
  final TextEditingController _total_priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _useridController,
                decoration: const InputDecoration(labelText: 'User ID'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _park_idController,
                decoration: const InputDecoration(labelText: 'Park ID'),
              ),
              TextField(
                controller: _booking_dateController,
                decoration: const InputDecoration(labelText: 'Booking Date'),
              ),
              TextField(
                controller: _num_ticketsController,
                decoration: const InputDecoration(labelText: 'Number of Tickets'),
              ),
              TextField(
                controller: _total_priceController,
                decoration: const InputDecoration(labelText: 'Total Price'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitPark,
                child: const Text('Book Game Park Ticket'),
              ),
            ],
          ),
        ),
      ), currentIndex: 5, userFirstName: user.userfirstName, places: [],
    );
  }

  void _submitPark() async {
    final String userid = _useridController.text;
    final String park_id = _park_idController.text;
    final String booking_date = _booking_dateController.text;
    final String num_tickets = _num_ticketsController.text;
    final String total_price = _total_priceController.text;

    if (userid.isEmpty ||
        park_id.isEmpty ||
        booking_date.isEmpty ||
        num_tickets.isEmpty ||
        total_price.isEmpty) {
      _showErrorDialog('All fields are required');
      return;
    }

    Map<String, dynamic> payload = {
      'userid': userid,
      'park_id': park_id,
      'booking_date': booking_date,
      'num_tickets': num_tickets,
      'total_price': total_price,
    };

    try {
      print('Sending payload: $payload');
      final response = await Park(payload);
      final decodedResponse = response;
      print('Received response: $decodedResponse');
      if (decodedResponse['status'] == 'Success') {
        logger.i('Booking successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking successful')),
        );
      } else {
        _showErrorDialog('Failed to add booking: ${decodedResponse['message']}');
      }
    } catch (e) {
      logger.e('Error occurred: $e');
      _showErrorDialog('An error occurred while adding booking: $e');
    }
  }

  Future<Map<String, dynamic>> Park(Map<String, dynamic> payload) async {
    print('Making HTTP request to book park with payload: $payload');
    final response = await http.post(
      Uri.parse('http://127.0.0.1/phalc/parkbooking'),
      body: jsonEncode(payload),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print('HTTP response: ${response.statusCode}, body: ${response.body}');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      var json = jsonDecode(response.body);
      if (json["message"] != null) {
        throw Exception(json["message"]);
      }
      throw Exception('Failed to add booking: ${response.statusCode}');
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
