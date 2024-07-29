import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Import intl package for date formatting

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookingPage(),
    );
  }
}

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  String _checkInDate = '';
  String _checkOutDate = '';
  int _numAdults = 1;
  int _numChildren = 0;
  int _numRooms = 1;
  String _roomType = 'Single';
  double _totalPrice = 0.0;

  final List<String> _roomTypes = ['Single', 'Double', 'Suite'];

  Future<void> _submitBooking() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Calculate total price (example calculation)
      _totalPrice = (_numRooms * 100.0) + (_numAdults * 50.0) + (_numChildren * 25.0);

      // Replace with your actual backend URL
      const url = 'http://127.0.0.1/phalc/booking';

      // Replace with your actual JWT token
      const token = 'your_jwt_token';

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: json.encode({
            'checkInDate': _checkInDate,
            'checkOutDate': _checkOutDate,
            'numAdults': _numAdults,
            'numChildren': _numChildren,
            'numRooms': _numRooms,
            'roomType': _roomType,
            'totalPrice': _totalPrice,
          }),
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          final bookingId = responseData['booking_id'];

          // Navigate to payment page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentPage(bookingId: bookingId),
            ),
          );
        } else {
          // Handle error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Booking failed: ${response.reasonPhrase}')),
          );
        }
      } catch (e) {
        // Handle network or server errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _showDatePicker({required bool isCheckIn}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue, // Adjust your theme color here
          
            colorScheme: ColorScheme.light(primary: Colors.blue),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = DateFormat('yyyy-MM-dd').format(picked);
        } else {
          _checkOutDate = DateFormat('yyyy-MM-dd').format(picked);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book a Room'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ListTile(
                title: Text('Check-in Date: $_checkInDate'),
                trailing: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _showDatePicker(isCheckIn: true),
                ),
              ),
              ListTile(
                title: Text('Check-out Date: $_checkOutDate'),
                trailing: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _showDatePicker(isCheckIn: false),
                ),
              ),
              _buildIncrementDecrementTile('Number of Adults', _numAdults, (newValue) {
                setState(() {
                  _numAdults = newValue;
                });
              }),
              _buildIncrementDecrementTile('Number of Children', _numChildren, (newValue) {
                setState(() {
                  _numChildren = newValue;
                });
              }),
              _buildIncrementDecrementTile('Number of Rooms', _numRooms, (newValue) {
                setState(() {
                  _numRooms = newValue;
                });
              }),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Room Type'),
                value: _roomType,
                items: _roomTypes
                    .map((type) => DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _roomType = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a room type';
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

  Widget _buildIncrementDecrementTile(String label, int value, ValueChanged<int> onChanged) {
    return ListTile(
      title: Text(label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              if (value > 0) {
                onChanged(value - 1);
              }
            },
          ),
          Text(value.toString()),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              onChanged(value + 1);
            },
          ),
        ],
      ),
    );
  }
}

class PaymentPage extends StatefulWidget {
  final int bookingId;

  PaymentPage({required this.bookingId});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Map<String, dynamic>? bookingDetails;
  bool isLoading = true;
  String mpesaPin = '';

  @override
  void initState() {
    super.initState();
    _fetchBookingDetails();
  }

  Future<void> _fetchBookingDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1/phalc/booking/${widget.bookingId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer your_jwt_token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          bookingDetails = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load booking details');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _processPayment() async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1/phalc/payment'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer your_jwt_token',
        },
        body: json.encode({
          'bookingId': widget.bookingId,
          'mpesaPin': mpesaPin,
          'amount': bookingDetails?['totalPrice'],
        }),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 && responseData['status'] == 'Success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment successful')),
        );
        Navigator.of(context).pop();
      } else {
        throw Exception(responseData['message'] ?? 'Payment failed');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : bookingDetails == null
              ? Center(child: Text('No booking details available'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Booking Details:', style: TextStyle(fontSize: 20)),
                      SizedBox(height: 10),
                      Text('Check-in Date: ${bookingDetails?['checkInDate']}'),
                      Text('Check-out Date: ${bookingDetails?['checkOutDate']}'),
                      Text('Number of Adults: ${bookingDetails?['numAdults']}'),
                      Text('Number of Children: ${bookingDetails?['numChildren']}'),
                      Text('Number of Rooms: ${bookingDetails?['numRooms']}'),
                      Text('Room Type: ${bookingDetails?['roomType']}'),
                      Text('Total Price: \$${bookingDetails?['totalPrice']}'),
                      SizedBox(height: 20),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Mpesa PIN',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            mpesaPin = value;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: mpesaPin.isEmpty
                                ? null
                                : () {
                                    _processPayment();
                                  },
                            child: Text('Continue'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}
