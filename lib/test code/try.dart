import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Flight model
class Flight {
  int id;
  String departureCity;
  String arrivalCity;
  String departureDate;
  String arrivalDate;
  int price;

  Flight({
    required this.id,
    required this.departureCity,
    required this.arrivalCity,
    required this.departureDate,
    required this.arrivalDate,
    required this.price,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      id: json['id'],
      departureCity: json['departureCity'],
      arrivalCity: json['arrivalCity'],
      departureDate: json['departureDate'],
      arrivalDate: json['arrivalDate'],
      price: json['price'],
    );
  }
}

// Booking model
class Booking {
  int id;
  int flightId;
  String passengerName;
  String contactNumber;
  String email;

  Booking({
    required this.id,
    required this.flightId,
    required this.passengerName,
    required this.contactNumber,
    required this.email,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      flightId: json['flightId'],
      passengerName: json['passengerName'],
      contactNumber: json['contactNumber'],
      email: json['email'],
    );
  }
}

// API Client for fetching flights and booking flights
class ApiClient {
  final String _baseUrl = 'https://your-api-url.com/api';

  Future<List<Flight>> getFlights() async {
    final response = await http.get(Uri.parse('$_baseUrl/flights'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return (jsonData as List).map((jsonFlight) => Flight.fromJson(jsonFlight)).toList();
    } else {
      throw Exception('Failed to load flights');
    }
  }

  Future<Booking> bookFlight(int flightId, String passengerName, String contactNumber, String email) async {
    final response = await http.post(Uri.parse('$_baseUrl/bookings'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'flightId': flightId,
          'passengerName': passengerName,
          'contactNumber': contactNumber,
          'email': email,
        }));

    if (response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      return Booking.fromJson(jsonData);
    } else {
      throw Exception('Failed to book flight');
    }
  }
}

// Main app
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flight Booking System',
      home: FlightListPage(),
    );
  }
}

// Flight list page
class FlightListPage extends StatefulWidget {
  @override
  _FlightListPageState createState() => _FlightListPageState();
}

class _FlightListPageState extends State<FlightListPage> {
  List<Flight> _flights = [];
  final _apiClient = ApiClient();

  @override
  void initState() {
    super.initState();
    _loadFlights();
  }

  Future<void> _loadFlights() async {
    final flights = await _apiClient.getFlights();
    setState(() {
      _flights = flights;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flight Booking System'),
      ),
      body: _flights.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _flights.length,
              itemBuilder: (context, index) {
                final flight = _flights[index];
                return ListTile(
                  title: Text('${flight.departureCity} to ${flight.arrivalCity}'),
                  subtitle: Text('Departure: ${flight.departureDate}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BookingPage(flight: flight)),
                      );
                    },
                    child: Text('Book'),
                  ),
                );
              },
            ),
    );
  }
}

// Booking page
class BookingPage extends StatelessWidget {
  final Flight flight;

  BookingPage({required this.flight});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController contactController = TextEditingController();
    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Book Flight')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text('Flight: ${flight.departureCity} to ${flight.arrivalCity}'),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Passenger Name'),
              ),
              TextFormField(
                controller: contactController,
                decoration: InputDecoration(labelText: 'Contact Number'),
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final apiClient = ApiClient();
                    await apiClient.bookFlight(
                      flight.id,
                      nameController.text,
                      contactController.text,
                      emailController.text,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Flight booked successfully!')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: Text('Confirm Booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
