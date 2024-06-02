
import 'package:flutter/material.dart';
import 'package:hidden/widgets/common_scaffold.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

import '../model/users.dart';

class DashboardPage extends StatefulWidget {
  final String title;

  const DashboardPage({Key? key, required this.title}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
      List<Map<String, dynamic>> _placesList = [];
  late TabController _tabController;
  final Logger logger = Logger();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageurlController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();
//places
  final TextEditingController _placeNameController = TextEditingController();
  final TextEditingController _placeDescriptionController = TextEditingController();
  final TextEditingController _placePriceController = TextEditingController();
  final TextEditingController _placeImageurlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Column(
              children: [
                Text(
                  widget.title,
                  
                ),
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Hotel'),
                    Tab(text: 'Places'),
                    Tab(text: 'Gamepark'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(       
        controller: _tabController,
        children: [
          _buildHotelTab(),
          _buildPlacesTab(),
          _buildGameparkTab(),
        ],
        ),
          ),
        ],

      ), currentIndex: 4, userFirstName: user.userfirstName, tundras: [], biomes: [], places: _placesList,
    );
  }

  Widget _buildHotelTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: _imageurlController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            TextField(
              controller: _commentsController,
              decoration: const InputDecoration(labelText: 'Comments'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Add Hotel'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlacesTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _placeNameController,
              decoration: const InputDecoration(labelText: 'Place Name'),
            ),
            const SizedBox(height: 16.0),
           
            TextField(
              controller: _placeDescriptionController,
              decoration: const InputDecoration(labelText: 'Place Description'),
            ),
            TextField(
              controller: _placePriceController,
              decoration: const InputDecoration(labelText: 'Place Price'),
            ),
            TextField(
              controller: _placeImageurlController,
              decoration: const InputDecoration(labelText: 'Place Image URL'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitFormPlace,
              child: const Text('Add Place'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameparkTab() {
    return const Center(
      child: Text('Gamepark Tab Content'),
    );
  }

  void _submitForm() async {
    final String name = _nameController.text;
    final String description = _descriptionController.text;
    final String price = _priceController.text;
    final String imageurl = _imageurlController.text;
    final String comments = _commentsController.text;

    if (name.isEmpty ||
        description.isEmpty ||
        price.isEmpty ||
        imageurl.isEmpty ||
        comments.isEmpty) {
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
      final response = await hotel(payload);
      if (response['status'] == 'Success') {
        logger.i('Hotel added successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Hotel added successfully')),
        );
      } else {
        _showErrorDialog('Failed to add hotel: ${response['message']}');
      }
    } catch (e) {
      logger.e('Error occurred: $e');
      _showErrorDialog('An error occurred while adding hotel: $e');
    }
  }

  void _submitFormPlace() async {
    final String placeName = _placeNameController.text;
    final String placeDescription = _placeDescriptionController.text;
    final String placePrice = _placePriceController.text;
    final String placeImageurl = _placeImageurlController.text;

    if (placeName.isEmpty ||
        placeDescription.isEmpty ||
        placePrice.isEmpty ||
        placeImageurl.isEmpty) {
      _showErrorDialog('All fields are required');
      return;
    }

    Map<String, dynamic> payload = {
      'placeName': placeName,
      'placeDescription': placeDescription,
      'placePrice': placePrice,
      'placeImageurl': placeImageurl,
    };
try {
    final response = await place(payload);
    final decodedResponse = response;
    if (decodedResponse['status'] == 'Success') {
      logger.i('Place added successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Place added successfully')),
      );
    } else {
      _showErrorDialog('Failed to add place: ${decodedResponse['message']}');
    }
  } catch (e) {
    logger.e('Error occurred: $e');
    _showErrorDialog('An error occurred while adding place: $e');
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

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      var json = jsonDecode(response.body);
      if (json["message"] != null) {
        throw Exception(json["message"]);
      }
      throw Exception('Failed to Add hotel: ${response.statusCode}');
    }
  }


  Future<Map<String, dynamic>> place(Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1/phalc/location'),
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
      throw Exception('Failed to Add place: ${response.statusCode}');
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
