


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



const kBaseURL = 'your_base_url_here';


class Hotel {
  final String name;
  final double price;
  final double rating;
  final String imageUrl;

  Hotel({
    required this.name,
    required this.price,
    required this.rating,
    required this.imageUrl,
  });

  factory Hotel.fromJson(Map<String, dynamic> parsedJson) {
    return Hotel(
      name: parsedJson['name'] ?? '',
      price: parsedJson['price'].toDouble() ?? 0.0,
      rating: parsedJson['rating'].toDouble() ?? 0.0,
      imageUrl: parsedJson['image_url'] ?? '',
    );
  }
}

class HotelSearchPage extends StatefulWidget {
  const HotelSearchPage({super.key});

  @override
  _HotelSearchPageState createState() => _HotelSearchPageState();
}

class _HotelSearchPageState extends State<HotelSearchPage> {
  TextEditingController destinationController = TextEditingController();
  List<Hotel> hotels = [];
  List<Hotel> filteredHotels = [];

  Future<void> getHotelsByCity(String city) async {
    final url = '$kBaseURL/$city';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      Iterable decodedJson = jsonDecode(response.body);
      final fetchedHotels = decodedJson.map((parsedJson) => Hotel.fromJson(parsedJson));
      setState(() {
        hotels = fetchedHotels.toList();
        filteredHotels = hotels;
      });
    } else {
      throw Exception("Error getting hotels");
    }
  }

  void searchHotels(String query) {
    setState(() {
      filteredHotels = hotels
          .where((hotel) =>
              hotel.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hotel Search')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: destinationController,
              decoration: InputDecoration(labelText: 'Search Hotels By City'),
            ),
            ElevatedButton(
              onPressed: () {
                final searchQuery = destinationController.text;
                getHotelsByCity(searchQuery);
              },
              child: Text('Search Hotels'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredHotels.length,
                itemBuilder: (context, index) {
                  final hotel = filteredHotels[index];
                  return ListTile(
                    leading: Image.network(hotel.imageUrl),
                    title: Text(hotel.name),
                    subtitle: Text('\$${hotel.price} per night'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.yellow),
                        Text(hotel.rating.toString()),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: HotelSearchPage()));
}