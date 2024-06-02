/*import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../model/users.dart';
import 'accommodation_page.dart';

class BookingPage extends StatefulWidget {
   final selectedHotel;
  
 const BookingPage({Key? key,  required this.selectedHotel}) : super(key: key);
  
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  
  String _selectedBookingType = 'Accommodation'; 
  final Map<String, List<Widget>> _bookingForms = {
    'Accommodation': [
      const TextField(
        decoration: InputDecoration(labelText: 'Accommodation ID'),
      ),
      const TextField(
        keyboardType: TextInputType.datetime,
        decoration: InputDecoration(labelText: 'Check-in Date'),
      ),
      const TextField(
        keyboardType: TextInputType.datetime,
        decoration: InputDecoration(labelText: 'Check-out Date'),
      ),
      const TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: 'Number of Rooms'),
      ),
    ],
    'Event': [
      const TextField(
        decoration: InputDecoration(labelText: 'Event ID'),
      ),
      const TextField(
        keyboardType: TextInputType.datetime,
        decoration: InputDecoration(labelText: 'Event Date'),
      ),
      const TextField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: 'Number of Tickets'),
      ),
      const TextField(
        decoration: InputDecoration(labelText: 'Event Type'),
      ),
    ],
    'Transportation': [
      const TextField(
        decoration: InputDecoration(labelText: 'Transportation ID'),
      ),
      const TextField(
        keyboardType: TextInputType.datetime,
        decoration: InputDecoration(labelText: 'Departure Date'),
      ),
      const TextField(
        keyboardType: TextInputType.datetime,
        decoration: InputDecoration(labelText: 'Return Date'),
      ),
      const TextField(
        decoration: InputDecoration(labelText: 'Departure Location'),
      ),
      const TextField(
        decoration: InputDecoration(labelText: 'Destination Location'),
      ),
    ],
  };

  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  bool _processingPayment = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Page'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
           Text(
                      user.userfirstName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
            SizedBox(height: 4),
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime(DateTime.now().year + 1),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              hint: const Text('Select Booking Type'),
              value: _selectedBookingType,
              onChanged: (value) {
                setState(() {
                  _selectedBookingType = value!;
                });
              },
              items: ['Accommodation', 'Event', 'Transportation'].map((bookingType) {
                return DropdownMenuItem<String>(
                  value: bookingType,
                  child: Text(bookingType),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            if (_bookingForms.containsKey(_selectedBookingType))
              ..._bookingForms[_selectedBookingType]!,
            SizedBox(height: 20),
             if (_selectedBookingType == 'Accommodation') // Check if accommodation is selected
              HotelCard(hotel: widget.selectedHotel), // Display the selected hotel details
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle form submission here
              },
              child: const Text('Submit'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _processingPayment ? null : _processBooking,
              child: _processingPayment
                  ? CircularProgressIndicator()
                  : Text('Confirm Booking'.toUpperCase()),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFA40F),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _processBooking() async {
    setState(() {
      _processingPayment = true;
    });

    try {
      // Simulate API call or processing here
      await Future.delayed(Duration(seconds: 2));

      // Once completed, navigate back or show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking processed successfully!'),
        ),
      );
    } catch (error) {
      print("Error occurred during booking: $error");
    } finally {
      setState(() {
        _processingPayment = false;
      });
    }
  }
}*/

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/users.dart';
import 'accommodation_page.dart';

class BookingPage extends StatefulWidget {
  final selectedHotel;

  const BookingPage({Key? key, required this.selectedHotel, required Map<String, dynamic> hotel}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

final TextEditingController _accommodationidController = TextEditingController();
final TextEditingController _checkin_dateController = TextEditingController();
final TextEditingController _checkout_dateController = TextEditingController();
final TextEditingController _numberof_roomsController = TextEditingController();
final TextEditingController _event_idController = TextEditingController();
final TextEditingController _event_dateController = TextEditingController();
final TextEditingController _numberof_ticketsController = TextEditingController();
final TextEditingController _event_typeController = TextEditingController();
final TextEditingController _transportation_idController = TextEditingController();
final TextEditingController _departure_dateController = TextEditingController();
final TextEditingController _retun_dateController = TextEditingController();
final TextEditingController _departure_locationController = TextEditingController();
final TextEditingController _destination_locationController = TextEditingController();

class _BookingPageState extends State<BookingPage> {
  String _selectedBookingType = 'Accommodation';
  final Map<String, List<Widget>> _bookingForms = {
    'Accommodation': [
      TextField(
        controller: _accommodationidController,
        decoration: InputDecoration(labelText: 'Accommodation ID'),
      ),
      TextField(
        controller: _checkin_dateController,
        keyboardType: TextInputType.datetime,
        decoration: InputDecoration(labelText: 'Check-in Date'),
      ),
      TextField(
        controller: _checkout_dateController,
        keyboardType: TextInputType.datetime,
        decoration: InputDecoration(labelText: 'Check-out Date'),
      ),
      TextField(
        controller: _numberof_roomsController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: 'Number of Rooms'),
      ),
    ],
    'Event': [
      TextField(
        controller: _event_idController,
        decoration: InputDecoration(labelText: 'Event ID'),
      ),
      TextField(
        controller: _event_dateController,
        keyboardType: TextInputType.datetime,
        decoration: InputDecoration(labelText: 'Event Date'),
      ),
      TextField(
        controller: _numberof_ticketsController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: 'Number of Tickets'),
      ),
      TextField(
        controller: _event_typeController,
        decoration: InputDecoration(labelText: 'Event Type'),
      ),
    ],
    'Transportation': [
      TextField(
        controller: _transportation_idController,
        decoration: InputDecoration(labelText: 'Transportation ID'),
      ),
      TextField(
        controller: _departure_dateController,
        keyboardType: TextInputType.datetime,
        decoration: InputDecoration(labelText: 'Departure Date'),
      ),
      TextField(
        controller: _retun_dateController,
        keyboardType: TextInputType.datetime,
        decoration: InputDecoration(labelText: 'Return Date'),
      ),
      TextField(
        controller: _departure_locationController,
        decoration: InputDecoration(labelText: 'Departure Location'),
      ),
      TextField(
        controller: _destination_locationController,
        decoration: InputDecoration(labelText: 'Destination Location'),
      ),
    ],
  };

  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  bool _processingPayment = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Page'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              user.userfirstName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 4),
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime(DateTime.now().year + 1),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              hint: const Text('Select Booking Type'),
              value: _selectedBookingType,
              onChanged: (value) {
                setState(() {
                  _selectedBookingType = value!;
                });
              },
              items: ['Accommodation', 'Event', 'Transportation']
                  .map((bookingType) {
                return DropdownMenuItem<String>(
                  value: bookingType,
                  child: Text(bookingType),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            if (_bookingForms.containsKey(_selectedBookingType))
              ..._bookingForms[_selectedBookingType]!,
            SizedBox(height: 20),
            if (_selectedBookingType == 'Accommodation')
              HotelCard(hotel: widget.selectedHotel),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    // Handle form submission here
    final String accommodationid = _accommodationidController.text;
    final String checkinDate = _checkin_dateController.text;
    final String checkoutDate = _checkout_dateController.text;
    final int numberOfRooms = int.tryParse(_numberof_roomsController.text) ?? 0;
    final String eventID = _event_idController.text;
    final String eventDate = _event_dateController.text;
    final int numberOfTickets = int.tryParse(_numberof_ticketsController.text) ?? 0;
    final String eventType = _event_typeController.text;
    final String transportationID = _transportation_idController.text;
    final String departureDate = _departure_dateController.text;
    final String returnDate = _retun_dateController.text;
    final String departureLocation = _departure_locationController.text;
    final String destinationLocation = _destination_locationController.text;

    // Validate form fields
    if (_selectedBookingType == 'Accommodation') {
      if (accommodationid.isEmpty ||
          checkinDate.isEmpty ||
          checkoutDate.isEmpty ||
          numberOfRooms <= 0) {
        _showErrorDialog('All fields are required');
        return;
      }
    } else if (_selectedBookingType == 'Event') {
      if (eventID.isEmpty ||
          eventDate.isEmpty ||
          numberOfTickets <= 0 ||
          eventType.isEmpty) {
        _showErrorDialog('All fields are required');
        return;
      }
    } else if (_selectedBookingType == 'Transportation') {
      if (transportationID.isEmpty ||
          departureDate.isEmpty ||
          returnDate.isEmpty ||
          departureLocation.isEmpty ||
          destinationLocation.isEmpty) {
        _showErrorDialog('All fields are required');
        return;
      }
    }

    // Perform payment processing logic
    setState(() {
      _processingPayment = true;
    });

    try {
      // Simulate payment processing
      await Future.delayed(Duration(seconds: 2));

      // Perform API call to process booking
      final response = await _processBookingAPI();

      // Check API response
      if (response['status'] == 'Success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Booking processed successfully!'),
          ),
        );
      } else {
        _showErrorDialog('Booking failed: ${response['message']}');
      }
    } catch (e) {
      print("Error occurred during booking: $e");
    } finally {
      setState(() {
        _processingPayment = false;
      });
    }
  }

  Future<Map<String, dynamic>> _processBookingAPI() async {
    // Prepare booking data based on the selected booking type
    Map<String, dynamic> payload = {};

    if (_selectedBookingType == 'Accommodation') {
      payload = {
        'accommodationid': _accommodationidController.text,
        'checkinDate': _checkin_dateController.text,
        'checkoutDate': _checkout_dateController.text,
        'numberOfRooms': _numberof_roomsController.text,
      };
    } else if (_selectedBookingType == 'Event') {
      payload = {
        'eventID': _event_idController.text,
        'eventDate': _event_dateController.text,
        'numberOfTickets': _numberof_ticketsController.text,
        'eventType': _event_typeController.text,
      };
    } else if (_selectedBookingType == 'Transportation') {
      payload = {
        'transportationID': _transportation_idController.text,
        'departureDate': _departure_dateController.text,
        'returnDate': _retun_dateController.text,
        'departureLocation': _departure_locationController.text,
        'destinationLocation': _destination_locationController.text,
      };
    }

    // Perform API call
    final response = await http.post(
      Uri.parse('http://127.0.0.1/phalc/Booking'),
      body: jsonEncode(payload),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var jsonData = json.decode(response.body);

    if (response.statusCode == 200) {
      return jsonData;
    } else {
      throw Exception('Failed to process booking: ${response.statusCode}');
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
