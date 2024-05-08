import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

void main() {
  runApp(const MaterialApp(home: HotelPage()));
}

final Logger logger = Logger();

class HotelPage extends StatefulWidget {
  const HotelPage({Key? key}) : super(key: key);

  @override
  State<HotelPage> createState() => _HotelPageState();
}

class _HotelPageState extends State<HotelPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageurlController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();
  
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('hotels'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'name'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'description'),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'price'),
              ),
              TextField(
                controller: _imageurlController,
                decoration: const InputDecoration(labelText: 'imageurl'),
              ),
              TextField(
                controller: _commentsController,
                decoration: const InputDecoration(labelText: 'comments'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('hotel'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    print('Submitting form...');
    final String name = _nameController.text;
    final String description = _descriptionController.text;
    final String price = _priceController.text;
    final String imageurl = _imageurlController.text;
    final String comments = _commentsController.text;

    print('Name: $name');
    print('Description: $description');
    print('Price: $price');
    print('Image URL: $imageurl');
    print('Comments: $comments');

    if (name.isEmpty ||
        description.isEmpty ||
        price.isEmpty ||
        imageurl.isEmpty ||
        comments.isEmpty) {
      print('Error: All fields are required');
      _showErrorDialog('All fields are required');
      return;
    }

    Map<String, dynamic> payload = {
      'name': name,
      'description': description,
      'price': price,
      'imageurl': imageurl,
      'comments': comments,
    };

    try {
      print('Sending hotel data to server...');
      final response = await hotel(payload);
      if (response['status'] == 'Success') {
        print('Hotel added successfully');
        logger.i('Hotel added successfully');
      } else {
        print('Failed to add hotel: ${response['message']}');
        _showErrorDialog('Failed to add hotel: ${response['message']}');
      }
    } catch (e) {
      print('An error occurred while adding hotel: $e');
      logger.e('Error occurred: $e');
      _showErrorDialog('An error occurred while adding hotel: $e');
    }
  }

  Future<Map<String, dynamic>> hotel(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1/phalc/accommodation'),
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
      throw Exception('Failed to Add hotel: ${response.statusCode}');
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


 List<Map<String, dynamic>> hotelList = [];

@override
  void initState() {
    super.initState();
    _fetchHotels(); // Fetch hotels when the page loads
  }

Future<void> _fetchHotels() async {
  try {
    final response = await http.get(
      Uri.parse('http://127.0.0.1/phalc/accommodation'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      setState(() {
        hotelList = jsonResponse.cast<Map<String, dynamic>>();
      });
    } else {
      logger.e('Failed to fetch hotels: ${response.statusCode}');
    }
  } catch (e) {
    logger.e('Error fetching hotels: $e');
  }
}

List<Widget> _buildHotelList() {
  return hotelList.map((hotel) {
    return ListTile(
      title: Text(hotel['name']),
      subtitle: Text(hotel['description']),
      trailing: Text('Price: ${hotel['price']}'),
    );
  }).toList();
}
}