import 'dart:convert';
//import 'package:hidden/screens/dashboard_page.dart';
import 'package:http/http.dart' as http; 
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logger/logger.dart';
import '../model/attraction.dart';
import '../model/users.dart';
import '../widgets/common_scaffold.dart';


class GemPage extends StatefulWidget {
  final String title;

  GemPage({super.key, required this.title});

  final Logger logger = Logger();
  bool get isLiked => false;

  @override
  State<GemPage> createState() => _GemPageState();
}

class _GemPageState extends State<GemPage> {
  late Box<Destination> _destinationBox;
  List<Map<String, dynamic>> _destinationList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      _destinationBox = await Hive.openBox<Destination>('DestinationBox');
      print('Destination Box Initialized: $_destinationBox');
      _fetchDestination();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  Future<void> _fetchDestination() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1/phalc/attraction'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse["status"] == "success") {
          setState(() {
            _destinationList = (jsonResponse["data"] as List<dynamic>)
                .map((item) => item as Map<String, dynamic>)
                .toList();
          });

          for (var destinationData in _destinationList) {
            try {
              final destination = Destination.fromJson(destinationData);
              _destinationBox.put(destination.id, destination);
            } catch (e) {
              widget.logger.e('Error parsing Destination data: $e');
              widget.logger.d('Destination data: $destinationData');
            }
          }
        } else {
          throw Exception("Unable to get Destination.");
        }
      } else {
        widget.logger.e('Failed to fetch Destination: ${response.statusCode}');
      }
    } catch (e) {
      widget.logger.e('Error fetching Destination: $e');
    }
  }

  void updateLikedStatus(int index) {
    final destination = _destinationBox.getAt(index);
    if (destination != null) {
      setState(() {
        destination.isLiked = !destination.isLiked;
        _destinationBox.putAt(index, destination);
      });
    }
  }

  void updateDestinationRating(Destination destination, int newRating) {
    if (newRating >= 1 && newRating <= 5) {
      setState(() {
        destination.rating = newRating;
        _destinationBox.put(destination.id, destination);
      });
    } else {
      widget.logger.w('Invalid rating. Rating should be between 1 and 5.');
    }
  }

  void updateBookmarkedStatus(int index) {
    final destination = _destinationBox.getAt(index);
    if (destination != null) {
      setState(() {
        destination.isBookmarked = !destination.isBookmarked;
        _destinationBox.putAt(index, destination);
      });
    }
    print('Updated isLiked for accommodation at index $index: ${destination?.isLiked}');
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Discover hidden gem All over the world',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Container(
                            height: 700,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _destinationBox.length,
                              itemBuilder: (context, index) {
                                final destination = _destinationBox.getAt(index);

                                if (destination == null) {
                                  return const SizedBox();
                                }

                                final assetPath = 'assets/images/${destination.image_url}';
                                return Card(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 0,
                                          blurRadius: 7,
                                          offset: const Offset(0, 3),
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
                                                width: 328,
                                                height: 145,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                              top: -10.0,
                                              right: -10.0,
                                              child: IconButton(
                                                icon: Icon(
                                                  destination.isLiked
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: destination.isLiked ? Colors.red : Colors.yellow,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    destination.isLiked = !destination.isLiked;
                                                    _destinationBox.putAt(index, destination);
                                                  });
                                                },
                                              ),
                                            ),
                                              Positioned(
                    bottom: -10.0,
                    left: -10.0,
                    child: IconButton(
                      icon: Icon(
                        destination.isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                        color: destination.isBookmarked ? Colors.orange : Colors.yellow,
                      ),
                      onPressed: () {
                        setState(() {
                          destination.isBookmarked = !destination.isBookmarked;
                          _destinationBox.putAt(index, destination);
                        });
                      },
                    ),
                  )
                                          ],
                                        ),
                                        SizedBox(
                                          width: 400,
                                          child: Container(
                                            margin: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      destination.country,
                                                      style: const TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 1.0),
                                                Text(
                                                  destination.cityName,
                                                  style: const TextStyle(fontSize: 16.0),
                                                ),

                                                 const SizedBox(height: 1.0),
                                                Text(
                      'cityUfi:${destination.productCount.toString()}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 1.0),
                     Text(
                      'cityUfi:${destination.ufi.toString()}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                                                 const SizedBox(height: 1.0),
                                                Text(
                                                  destination.cc1,
                                                  style: const TextStyle(fontSize: 16.0),
                                                ),
                                                const SizedBox(height: 1.0),
                                               /* Text(
                                                  '\$${destination.price.toStringAsFixed(1)}',
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                                const SizedBox(height: 0.0),*/
                                                   Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (starIndex) {
                        return IconButton(
                          icon: Icon(
                            starIndex < (destination.rating) ? Icons.star : Icons.star_border,
                            color: starIndex < (destination.rating) ? Colors.yellow : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                             destination .rating = starIndex + 1;
                              _destinationBox.putAt(index, destination);
                            });
                          },
                        );
                      }),
                    ),
                         
                   

                                              ],
                                            ),
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
      ), currentIndex: 2, userfirstName: user .userfirstName, places: [],
    );
  }
}
