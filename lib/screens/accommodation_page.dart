
// Import necessary packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hidden/widgets/common_scaffold.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../model/accommondation.dart'; 

import '../model/users.dart';
import 'booking_page.dart';



final Logger logger = Logger();

class Accommodationpage extends StatefulWidget {
  final String title;

  const Accommodationpage({super.key, required this.title});

  @override
  State<Accommodationpage> createState() => _AccommodationpageState();
}

class _AccommodationpageState extends State<Accommodationpage> {
  List<String> comments = [];
  late Box<Hotel> hotelsBox;
   
  List<Map<String, dynamic>> hotelList = [];
  
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
   // _fetchHotels();
  }

  Future<void> _initializeData() async {
    try {
      hotelsBox = await Hive.openBox<Hotel>('hotelsBox');
      _fetchHotels();
     
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      logger.e('Error initializing data: $e');
    }
  }

  void updateLikedStatus(int index) {
    final Hotel? hotel = hotelsBox.getAt(index);
    if (hotel != null) {
      setState(() {
        hotel.isLiked = !hotel.isLiked;
        hotelsBox.putAt(index, hotel);
      });
    }
  }

  void updateBookmarkedStatus(int index) {
    final Hotel? hotel = hotelsBox.getAt(index);
    if (hotel != null) {
      setState(() {
        hotel.isBookmarked = !hotel.isBookmarked;
        hotelsBox.putAt(index, hotel);
      });
    }
  }

  void updateHotelRating(Hotel hotel, int newRating) {
    if (newRating >= 1 && newRating <= 5) {
      setState(() {
        hotel.rating = newRating;
        hotelsBox.put(hotel.id, hotel);
      });
    } else {
      logger.w('Invalid rating. Rating should be between 1 and 5.');
    }
  }



Future<void> _fetchHotels() async {
  try {
    final response = await http.get(
      Uri.parse('http://127.0.0.1/phalc/accommodation'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body); 
      
      if (jsonResponse["status"] == "success") { 
        setState(() {
          hotelList = (jsonResponse["data"] as List<dynamic>)
              .map((item) => item as Map<String, dynamic>)
              .toList();
        });
       logger.i('Fetched hotels: $hotelList');

 // Store the fetched data in Hive
for (var hotelData in hotelList) {
            try {
              final hotel = Hotel.fromJson(hotelData);
              
              hotelsBox.put(hotel.id, hotel);
                logger.i('Hotel added to _hotelsBox: ${hotel.toJson()}');
            } catch (e) {
              logger.e('Error fetching hotels: $e');
            }
          }
           logger.i('hotelsBox now has ${hotelsBox.length} entries');
 } else {
          throw Exception("Unable to get hotel.");
        }
      } else {
        logger.e('Failed to fetch hotels: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error fetching hotels: $e');
       _showErrorDialog('Error fetching hotels: $e');
    }
     //Print each hotel as it's being added to hotelsBox
    // print('Hotel added to _hotelsBox: $Hotel');
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
      
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
           itemCount: hotelsBox.length,
              itemBuilder: (context, index) {
                final hotel = hotelsBox.getAt(index);
                if (hotel == null) {
                  return const SizedBox(); // Return an empty widget if hotel is null
                }
                return HotelCard(hotel: hotel.toJson());
              },
            ), currentIndex: 5, userfirstName: user.userfirstName, places:const [],  


            
     
    );
  }
}

class HotelCard extends StatefulWidget {
  final Map<String, dynamic> hotel; // Previous: final Hotel hotel;

  const HotelCard({super.key, required this.hotel});

  @override
  State<HotelCard> createState() => _HotelCardState();
  
}

class _HotelCardState extends State<HotelCard> {
    List<String> comments = [];
  @override
  Widget build(BuildContext context) {
    final assetPath = 'assets/images/${widget.hotel['imageurl']}'; 

         return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  assetPath,
                  width: 400,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: -10.0,
                right: -10.0,
                child: IconButton(
  icon: Icon(
    widget.hotel['isLiked'] == true ? Icons.favorite : Icons.favorite_border,
    color: widget.hotel['isLiked'] == true ? Colors.red : Colors.yellow,
  ),
  onPressed: () {
    setState(() {
      widget.hotel['isLiked'] = !(widget.hotel['isLiked'] ?? false); // Initialize to false if Null
    

                    });
                  },
                ),
              ),

 Positioned(
  bottom: -10.0,
  left: -10.0,
  child: IconButton(
    icon: Icon(
      (widget.hotel['isBookmarked'] != null && widget.hotel['isBookmarked']) 
        ? Icons.bookmark 
        : Icons.bookmark_outline,
      color: (widget.hotel['isBookmarked'] != null && widget.hotel['isBookmarked']) 
        ? Colors.orange 
        : Colors.yellow,
    ),
    onPressed: () {
      setState(() {
        // Toggle the value of 'isBookmarked' in the map
        widget.hotel['isBookmarked'] = !(widget.hotel['isBookmarked'] ?? false);
      });
    },
  ),
),

              Positioned(
                bottom: -10.0,
                right: -10.0,
                child: IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Add Comment'),
                        content: TextField(
                          onChanged: (value) {
                            // Update comment text
                          },
                          decoration: const InputDecoration(
                            hintText: 'Enter your comment',
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                // Add comment to the list
                                comments.add('New Comment: ${DateTime.now()}');
                              });
                              Navigator.pop(context);
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     
                    Text(
                      widget.hotel['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
              
                  ],
                ),
               
                const SizedBox(height: 1.0),
              Text(
  '\$${widget.hotel['price'] ?? 'N/A'}', // Use 'N/A' if price is null
  style: const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: Colors.green,
  ),
),
const SizedBox(height: 0.0),
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: List.generate(5, (index) {
    int starIndex = index + 1;
    return IconButton(
      icon:Icon(
  starIndex <= (widget.hotel['rating'] as int? ?? 0) ? Icons.star : Icons.star_border, // Use 0 if rating is null
  color: starIndex <= (widget.hotel['rating'] as int? ?? 0) ? Colors.yellow : Colors.grey, // Use default colors if rating is null
),

      onPressed: () {
        setState(() {
          // Update the rating in the hotel data if it's not null
          if (widget.hotel['rating'] != null) {
            widget.hotel['rating'] = starIndex;
          
          } else {
        // If rating is null, assign the initial value
        widget.hotel['rating'] = starIndex;
      }
        });
      },
    );
  
                  }),
                ),
              ],
            ),
          ),
          Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const BookingPage(),
                                
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
                              'Review',
                              style: TextStyle(
                          fontSize: 14,
                         color: Colors.white,
                        ),
                          ),
                        ),
                        ),
        ],
      ),
    );
  }
}
