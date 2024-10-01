
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hidden/screens/parkbooking_page.dart';
import 'package:hidden/widgets/common_scaffold.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';
import '../model/gameparks.dart';
import '../model/users.dart';
import 'package:http/http.dart' as http;


class Gameparkpage extends StatefulWidget {
  final String title;

  const Gameparkpage({super.key,  required this.title});

  bool get isLiked => false;

  @override
  State<Gameparkpage> createState() => _GameparkpageState();
}

class _GameparkpageState extends State<Gameparkpage> {
  late Box<Park> _parksBox;
   List<Map<String, dynamic>> _parksList = [];

   final logger = Logger();

  bool _isLoading = true;

   @override
  void initState() {
    super.initState();
    _initializeData();
  }

  
  Future<void> _initializeData() async {
    try {
      _parksBox = await Hive.openBox<Park>('ParksBox');
     // _parksBox.clear();
      // Add a print statement to log the contents of _placesBox
      print('Parks Box Initialized: $_parksBox');

        await _fetchParks();
        
      setState(() {
        _isLoading = false;
      });

    } catch (e) {
      logger.e('Error initializing data: $e');
    }
  }


  Future<void> _fetchParks() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost/phalc/gamepark'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse["status"] == "success") {
          setState(() {
            _parksList = (jsonResponse["data"] as List<dynamic>)
                .map((item) => item as Map<String, dynamic>)
                .toList();
          });

          // Store the fetched data in Hive
          for (var parkData in _parksList) {
            try {
              final park = Park.fromJson(parkData);
              _parksBox.put(park.park_id, park);
            } catch (e) {
              logger.e('Error parsing park data: $e');
              logger.d('Park data: $parkData');
            }
          }
        } else {
          throw Exception("Unable to get park.");
        }
      } else {
        logger.e('Failed to fetch parks: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error fetching parks: $e');
    }
  }


  void updateLikedStatus(int index) {
    final park = _parksBox.getAt(index);
    if (park != null) {
      setState(() {
        park.isLiked = !park.isLiked;
        _parksBox.putAt(index, park);
      });
    }
  }

  void updateFlightRating(Park park, int newRating) {
    if (newRating >= 1 && newRating <= 5) {
      setState(() {
        park.rating = newRating;
        _parksBox.put(park.park_id, park);
      });
    } else {
      logger.w('Invalid rating. Rating should be between 1 and 5.');
    }

  }

  void updateBookmarkedStatus(int index) {
    final park = _parksBox.getAt(index);
    if (park != null) {
      setState(() {
        park.isBookmarked = !park.isBookmarked;
        _parksBox.putAt(index, park);
      });
    } else {
      print('Error: Park is null at index $index');
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


  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //const SizedBox(height: 4),
                    const SizedBox(height: 1),
                          const Text(
                            'visit Gamepark',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                           const SizedBox(height: 1),
                    Container(
                      height: 3500,
                      child: ListView.builder(
                        shrinkWrap: true,
                
                        physics:NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: _parksBox.length,
                        itemBuilder: (context, index) {
                          final park = _parksBox.getAt(index);

                          if (park == null) {
                            return const SizedBox();
                          }
                           final assetPath = 'assets/images/${park.image_url}';

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.asset(
                                          assetPath,
                                          width: 350,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: -10.0,
                                        right: -10.0,
                                        child: IconButton(
                                          icon: Icon(
                                            park.isLiked ? Icons.favorite : Icons.favorite_border,
                                            color: park.isLiked ? Colors.red : const Color.fromARGB(255, 250, 226, 7),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              park.isLiked = !park.isLiked;
                                              _parksBox.putAt(index, park);
                                            });
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        bottom: -10.0,
                                        left: -10.0,
                                        child: IconButton(
                                          icon: Icon(
                                            park.isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                                            color: park.isBookmarked ? Colors.orange : Colors.yellow,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              park.isBookmarked = !park.isBookmarked;
                                              _parksBox.putAt(index, park);
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Parks_id: ${park.park_id}',
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 1.0),
                                        Text(
                                          'ParkName: ${park.park_name}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16.0),
                                        ),
                                        const SizedBox(height: 1.0),
                                        Text(
                                          'Location: ${park.park_location}',
                                          maxLines: 6,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16.0),
                                        ),
                                        const SizedBox(height: 1.0),
                                        Text(
                                          'Established: ${park.established_date}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16.0),
                                        ),
                                        const SizedBox(height: 1.0),
                                        Text(
                                          'Size:${park.size_in_acres}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16.0),
                                        ),
                                        const SizedBox(height: 1.0),
                                        Text(
                                          '\$${park.entry_fee.toStringAsFixed(1)}',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                                       
                            Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ParkbookingPage(title: 'gamepark tab',),
                                
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 11, 66, 110),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                            child: const Text(
                              'BOOK',
                              style: TextStyle(
                          fontSize: 14,
                         color: Colors.white,
                        ),
                          ),
                        ),
                        ),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
        ],
                ),
              ),
            ),
          ],
        ),
      ), currentIndex: 7, userfirstName: user.userfirstName, places: [],
    );
  }
}
