import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

 final Logger logger = Logger();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flight Booking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FlightBookingPage(),
    );
  }
}

class FlightBookingPage extends StatefulWidget {
  const FlightBookingPage({super.key});

  @override
  _FlightBookingPageState createState() => _FlightBookingPageState();
}

class _FlightBookingPageState extends State<FlightBookingPage> {
  final _flight_dateController = TextEditingController();
  final _departure_timeController = TextEditingController();
  final _number_of_ticketsController = TextEditingController();
	
  String? _selectedFrom;
  String? _selectedTo;
  String? _selectedflight_type;
  List<String> _flights = [];
  bool _isSearching = false;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Dummy data for dropdown menus
  final Map<String, String> _citiesToCountry = {
    'Kenya, Nairobi': 'Kenya',
    'Kenya, Mombasa': 'Kenya',
    'Kenya, Kisumu': 'Kenya',
    'Uganda, Kampala': 'Uganda',
    'Uganda, Entebbe': 'Uganda',
    'Uganda, Jinja': 'Uganda',
    'Tanzania, Dar es Salaam': 'Tanzania',
    'Tanzania, Arusha': 'Tanzania',
    'Tanzania, Dodoma': 'Tanzania',
  };

  final List<String> _flight_types = ['Economy', 'Business', 'First Class'];

  Future<void> _searchFlights() async {
    //setState(() {
     // _isSearching = true;
    //});


    final String from_location = _selectedFrom ?? '';
    final String to_location = _selectedTo ?? '';
    final String flight_date = _flight_dateController.text;
    final String departure_time = _departure_timeController.text;
    final String flight_type = _selectedflight_type ?? '';
     final String number_of_tickets = _number_of_ticketsController.text;
    
    if (from_location.isEmpty ||
        to_location.isEmpty ||
        flight_date.isEmpty ||
        departure_time.isEmpty ||
        flight_type.isEmpty ||
        number_of_tickets.isEmpty) {
      _showErrorDialog('All fields are required');
      return;
    }

          Map<String, dynamic> payload = {
          'from_location': from_location,
          'to_location': to_location,
          'flight_date': flight_date,
          'departure_time': departure_time,
          'flight_type': flight_type,
          'number_of_tickets': number_of_tickets,
          };
      
      try {
      final response = await flight(payload);

      if (response['status'] == 'Success') {
        logger.i('booking added successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('booking added successfully')),
        );


        
      } else {
        logger.e('Failed to add booking: ${response['message']}');
        _showErrorDialog('Failed to add booking: ${response['message']}');
      }
    } catch (e) {
      logger.e('Error occurred: $e');
      _showErrorDialog('An error occurred while adding booking: $e');
    }
  }
Future<Map<String, dynamic>> flight(Map<String, dynamic> payload) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1/phalc/searchflight'),
    body: jsonEncode(payload),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

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



  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _flight_dateController.text = "${picked.toLocal()}".split(' ')[0]; // Format date
      });
    }
  }	

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _departure_timeController.text = "${picked.format(context)}";
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
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
        title: Text('Flight Booking'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!_isSearching) ...[
              // From Location Dropdown
              _buildDropdown('From', _selectedFrom, (value) {
                setState(() {
                  _selectedFrom = value;
                });
              }),
              SizedBox(height: 10),

              // To Location Dropdown
              _buildDropdown('To', _selectedTo, (value) {
                setState(() {
                  _selectedTo = value;
                });
              }),
              SizedBox(height: 10),

              // Date Picker
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: _flight_dateController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Departure Time Picker
              GestureDetector(
                onTap: () => _selectTime(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: _departure_timeController,
                    decoration: InputDecoration(
                      labelText: 'Departure Time',
                      prefixIcon: Icon(Icons.access_time),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Number of Tickets
              TextField(
                controller: _number_of_ticketsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Number of Tickets',
                  prefixIcon: Icon(Icons.confirmation_number),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
              ),
              SizedBox(height: 10),


              // Flight Type Dropdown
              DropdownButtonFormField<String>(
                value: _selectedflight_type,
                hint: Text('Select Flight Type'),
                items: _flight_types.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedflight_type = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Flight Type',
                  prefixIcon: Icon(Icons.flight),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
              ),
              SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: _searchFlights,
                icon: Icon(Icons.search),
                label: Text('Search Flights'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ] else if (_isSearching) ...[
              // Loading Indicator
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Searching for flights...', textAlign: TextAlign.center),
            ] else ...[
              // Flight Results
              Expanded(
                child: ListView.builder(
                  itemCount: _flights.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 3,
                      child: ListTile(
                        title: Text(_flights[index]),
                        onTap: () {
                          setState(() {
                            _isSearching = false;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String? selectedValue, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      hint: Text('Select $label location'),
      items: _citiesToCountry.keys.map((location) {
        return DropdownMenuItem(
          value: location,
          child: Text(location),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(label == 'From' ? Icons.flight_takeoff : Icons.flight_land),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      ),
    );
  }
}
