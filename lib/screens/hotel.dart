/*import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    title: 'Hotel Search',
    home: HotelSearchPage(),
  ));
}

class HotelSearchPage extends StatefulWidget {
  @override
  _HotelSearchPageState createState() => _HotelSearchPageState();
}

class _HotelSearchPageState extends State<HotelSearchPage> {
  TextEditingController _queryController = TextEditingController();
  String _searchResult = '';

  void _searchHotels() async {
    final String apiKey = '';
    final String apiHost = '';
    final String apiUrl = '';

    final Map<String, String> headers = {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': apiHost,
    };

    final Map<String, String> queryParams = {
      'query': _queryController.text,
    };

    final Uri uri = Uri.parse(apiUrl).replace(queryParameters: queryParams);
    final http.Response response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final Map<String, dynamic> data = json.decode(response.body);
      // Update the search result
      setState(() {
        _searchResult = data.toString(); // Update with your desired logic
      });
    } else {
      // Handle error response
      setState(() {
        _searchResult = 'Error: ${response.statusCode} - ${response.reasonPhrase}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _queryController,
              decoration: InputDecoration(
                labelText: 'Enter Query',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _searchHotels,
              child: Text('Search'),
            ),
            SizedBox(height: 16.0),
            Text(_searchResult),
          ],
        ),
      ),
    );
  }
}
*/


/*
import 'package:flutter/material.dart';

void main() {
  runApp(HotelBookingApp());
}

class HotelBookingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Booking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HotelListScreen(),
    );
  }
}

class HotelListScreen extends StatelessWidget {
  final List<HotelRoom> hotelRooms = [
    HotelRoom('Deluxe Room', 'Spacious room with city view', 120),
    HotelRoom('Executive Suite', 'Luxury suite with all amenities', 250),
    HotelRoom('Standard Room', 'Cozy room for budget travelers', 80),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel Rooms'),
      ),
      body: ListView.builder(
        itemCount: hotelRooms.length,
        itemBuilder: (context, index) {
          return HotelRoomCard(hotelRoom: hotelRooms[index]);
        },
      ),
    );
  }
}

class HotelRoom {
  final String name;
  final String description;
  final double price;

  HotelRoom(this.name, this.description, this.price);
}

class HotelRoomCard extends StatelessWidget {
  final HotelRoom hotelRoom;

  HotelRoomCard({required this.hotelRoom});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hotelRoom.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(hotelRoom.description),
            SizedBox(height: 10),
            Text('\$${hotelRoom.price.toStringAsFixed(2)} per night'),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _showBookingDialog(context, hotelRoom.name);
              },
              child: Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookingDialog(BuildContext context, String roomName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Booking Confirmation'),
          content: Text('Do you want to book the $roomName?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Handle booking logic here
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$roomName booked successfully!')),
                );
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
*/

/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(BookingFormApp());
}

class BookingFormApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booking Form Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BookingFormScreen(),
    );
  }
}

class BookingFormScreen extends StatefulWidget {
  @override
  _BookingFormScreenState createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  late DateTime checkInDate;
  late DateTime checkOutDate;

  @override
  void initState() {
    super.initState();
    checkInDate = DateTime.now();
    checkOutDate = DateTime.now().add(Duration(days: 1)); // Default checkout date is next day
  }

  Future<void> _submitBookingForm() async {
    final String fullName = fullNameController.text;
    final String email = emailController.text;
    final String phone = phoneController.text;

    // Perform your logic here, e.g., call an API to book the accommodation
    final url = 'https://yourapi.com/book'; // Replace with your API endpoint
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'checkInDate': checkInDate.toIso8601String(),
        'checkOutDate': checkOutDate.toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      // Handle successful booking response
      print('Booking successful!');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking successful!')),
      );
    } else {
      // Handle booking failure
      print('Failed to book accommodation. Please try again.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to book accommodation. Please try again.')),
      );
    }
  }

  Future<void> _selectCheckInDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: checkInDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1), // Allow booking up to 1 year ahead
    );
    if (picked != null && picked != checkInDate) {
      setState(() {
        checkInDate = picked;
      });
    }
  }

  Future<void> _selectCheckOutDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: checkOutDate,
      firstDate: checkInDate.add(Duration(days: 1)), // Check-out must be after check-in
      lastDate: DateTime(DateTime.now().year + 1), // Allow booking up to 1 year ahead
    );
    if (picked != null && picked != checkOutDate) {
      setState(() {
        checkOutDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: Text('Check-in Date: ${DateFormat('dd/MM/yyyy').format(checkInDate)}'),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectCheckInDate(context),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: Text('Check-out Date: ${DateFormat('dd/MM/yyyy').format(checkOutDate)}'),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectCheckOutDate(context),
                ),
              ],
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _submitBookingForm,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}


*/