/*import 'package:flutter/material.dart';
import 'package:hidden/screens/home_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/datum.dart';


// Define the Datum and MetaMatch classes here

void main() {
  runApp(HotelPage());
}

class HotelPage extends StatefulWidget {
  @override
  _HotelPageState createState() => _HotelPageState();
}

class _HotelPageState extends State<HotelPage> {
  TextEditingController _queryController = TextEditingController();
  List<Datum>? _datums;

  Future<void> fetchData(String query) async {
    final response = await http.get(
      Uri.parse('https://booking-com15.p.rapidapi.com/api/v1/hotels/searchDestination?query=$query'),
      headers: {
        'X-RapidAPI-Key': '6b8d7d3b44msh76deb9870700c38p14107bjsnd5b5cdd1ad9d',
        'X-RapidAPI-Host': 'booking-com15.p.rapidapi.com',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> rawData = data['data'];

      setState(() {
        _datums = rawData.map((json) => Datum.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Query',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
         // title: Text('Location '),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _queryController,
                decoration: const InputDecoration(
                  labelText: 'Enter Location',
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  await fetchData(_queryController.text);
                },
                child: const Text('Search'),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: _datums == null
                    ? const Center(child: Text('search location'))
                    : ListView.builder(
                        itemCount: _datums!.length,
                        itemBuilder: (context, index) {
                          final datum = _datums![index];
                          return ListTile(
                            
                            subtitle: Text(datum.name),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/

/*

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../model/datum.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(DatumAdapter()); // Register the adapter
  await Hive.openBox<Datum>('datumsBox'); // Open the Hive box
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hotel Search',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HotelScreen(),
    );
  }
}

class HotelScreen extends StatefulWidget {
  @override
  _HotelScreenState createState() => _HotelScreenState();
}

class _HotelScreenState extends State<HotelScreen> {
  final _queryController = TextEditingController();
  late Box<Datum> _datumsBox;
  List<Datum> _filteredDatums = [];

  @override
  void initState() {
    super.initState();
    _datumsBox = Hive.box<Datum>('datumsBox'); // Use the opened box
    _filteredDatums = _datumsBox.values.toList();
  }

  Future<void> fetchData(String query) async {
    if (_datumsBox.isNotEmpty) {
      // Data is already cached, use it
      setState(() {
        _filteredDatums = _datumsBox.values.toList();
      });
    } else {
      // Fetch data from the API
      final response = await http.get(
        Uri.parse('https://booking-com15.p.rapidapi.com/api/v1/hotels/searchDestination?query=$query'),
        headers: {
          'X-RapidAPI-Key': '6b8d7d3b44msh76deb9870700c38p14107bjsnd5b5cdd1ad9d',
          'X-RapidAPI-Host': 'booking-com15.p.rapidapi.com',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> rawData = data['data'];

        final datums = rawData.map((json) => Datum.fromJson(json)).toList();

        // Cache the data in Hive
        await _datumsBox.addAll(datums);

        setState(() {
          _filteredDatums = datums;
        });
      } else {
        throw Exception('Failed to load data');
      }
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _queryController,
              decoration: const InputDecoration(
                labelText: 'Enter Location', // Corrected label
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await fetchData(_queryController.text);
              },
              child: const Text('Search'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: _filteredDatums.isEmpty
                  ? const Center(child: Text('Search location'))
                  : ListView.builder(
                      itemCount: _filteredDatums.length,
                      itemBuilder: (context, index) {
                        final datums = _filteredDatums[index];
                        return ListTile(
                          subtitle: Text(datums.name), // Use the 'name' property
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


*/
/*
import 'package:flutter/material.dart';

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
}

class HotelSearchPage extends StatefulWidget {
  @override
  _HotelSearchPageState createState() => _HotelSearchPageState();
}

class _HotelSearchPageState extends State<HotelSearchPage> {
  TextEditingController destinationController = TextEditingController();
  List<Hotel> hotels = [
    Hotel(name: 'Hotel A', price: 120, rating: 4.5, imageUrl: 'hotel_a.jpg'),
    Hotel(name: 'Hotel B', price: 150, rating: 4.2, imageUrl: 'hotel_b.jpg'),
    // Add more hotels...
  ];

  List<Hotel> filteredHotels = [];

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
              decoration: InputDecoration(labelText: 'Search Hotels'),
            ),
            ElevatedButton(
              onPressed: () {
                final searchQuery = destinationController.text;
                searchHotels(searchQuery);
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
                    leading: Image.asset(hotel.imageUrl),
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
*/



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