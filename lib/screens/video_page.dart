import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(GameParkBookingApp());
}

class GameParkBookingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Park Booking',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: BookingForm(),
    );
  }
}

class BookingForm extends StatefulWidget {
  @override
  _BookingFormState createState() => _BookingFormState();
}

class _BookingFormState extends State<BookingForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _parkIdController = TextEditingController();
  final TextEditingController _bookingDateController = TextEditingController();
  final TextEditingController _numTicketsController = TextEditingController();

  Future<void> _submitBooking() async {
    if (_formKey.currentState?.validate() ?? false) {
      final response = await http.post(
        Uri.parse('http://your_api_endpoint/book_game_park.php'),
        body: {
          'user_id': _userIdController.text,
          'park_id': _parkIdController.text,
          'booking_date': _bookingDateController.text,
          'num_tickets': _numTicketsController.text,
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result == 'Booking successful!') {
          _showDialog('Success', 'Booking successful!');
        } else {
          _showDialog('Error', result);
        }
      } else {
        _showDialog('Error', 'Failed to submit booking.');
      }
    }
  }

  void _showDialog(String title, String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Your Game Park Visit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _userIdController,
                decoration: InputDecoration(labelText: 'User ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your User ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _parkIdController,
                decoration: InputDecoration(labelText: 'Game Park ID'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Game Park ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _bookingDateController,
                decoration: InputDecoration(labelText: 'Booking Date'),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the booking date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _numTicketsController,
                decoration: InputDecoration(labelText: 'Number of Tickets'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of tickets';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitBooking,
                child: Text('Book Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
