import 'package:flutter/material.dart';
import 'package:hidden/widgets/common_scaffold.dart';
import 'package:logger/logger.dart';
import 'dart:convert'; 
import 'package:http/http.dart' as http; 
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import '../model/biome.dart';
import '../model/place.dart';
import '../model/tundra.dart';
import '../model/users.dart';
import '../screens/review_page.dart';
import '../screens/accommodation_page.dart';
import '../screens/gamepark_page.dart';
import '../screens/gem_page.dart';
import '../screens/transport_page.dart';
import '../widgets/images_widgets.dart';
import 'dashboard_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  final Logger logger = Logger();
  bool get isLiked => false;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<Place> _placesBox;
  List<Map<String, dynamic>> _placesList = [];
 TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      _placesBox = await Hive.openBox<Place>('PlacesBox');
      //_placesBox.clear();
      // Add a print statement to log the contents of _placesBox
print('Places Box Initialized: $_placesBox');
     
      _fetchPlaces();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  Future<void> _fetchPlaces() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1/phalc/location'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse["status"] == "success") {
          setState(() {
            _placesList = (jsonResponse["data"] as List<dynamic>)
                .map((item) => item as Map<String, dynamic>)
                .toList();
          });
          print('Fetched places: $_placesList');

          // Store the fetched data in Hive
         for (var placeData in _placesList) {
         
            

            try {
               final place = Place.fromJson(placeData);
            _placesBox.put(place.id, place);
            print('Place added to _placesBox: ${place.toJson()}');
           } catch (e) {
              widget.logger.e('Error parsing place data: $e');
              widget.logger.d('Place data: $placeData');
            }
          }
            print('placesBox now has ${_placesBox.length} entries');
        } else {
          throw Exception("Unable to get location.");
        }
      } else {
        widget.logger.e('Failed to fetch places: ${response.statusCode}');
      }
    } catch (e) {
      widget.logger.e('Error fetching places: $e');
    }
    
  // Print each place as it's being added to _placesBox
  print('Place added to _placesBox: $Place');
  }
//search hotels
Future<void> _search(String query) async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8080/search?q=$query'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _searchResults = List<Map<String, dynamic>>.from(
          json.decode(response.body)['data'],
        );
      });
    } else {
      throw Exception('Failed to load data');
    }
  }


  void updateLikedStatus(int index) {
    final place = _placesBox.getAt(index);
    if (place != null) {
      setState(() {
        place.isLiked = !place.isLiked;
        _placesBox.putAt(index, place);
      });
    }
  }

  void updatePlaceRating(Place place, int newRating) {
    if (newRating >= 1 && newRating <= 5) {
      setState(() {
        place.rating = newRating;
        _placesBox.put(place.id, place);
      });
    } else {
      widget.logger.w('Invalid rating. Rating should be between 1 and 5.');
    }
  }

  void updateBookmarkedStatus(int index) {
    final place = _placesBox.getAt(index);
    if (place != null) {
      setState(() {
        place.isBookmarked = !place.isBookmarked;
        _placesBox.putAt(index, place);
      });
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
      currentIndex: 0,
      userFirstName: user.userfirstName,
      places: _placesList,
      tundras: tundras,
      biomes: biomes,
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
                          const SizedBox(height: 20),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 0),
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color.fromARGB(255, 216, 209, 209)),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.search),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                     controller: _searchController,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 92, 91, 91),
                                    ),
                                     onSubmitted: (value) {
                                    _search(value);
                                     },
                                    decoration: InputDecoration(
                                      hintText: 'Search...',
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: const Color.fromARGB(255, 49, 49, 49).withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 1),
                          const Text(
                            'TravelScape',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Container(
                            padding: const EdgeInsets.all(4),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  CircularItem(
                                    icon: Icons.visibility,
                                    text: 'Hidden gem',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const GemPage(title: 'Hidden Gem Details')),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 15),
                                  CircularItem(
                                    icon: Icons.hotel_class,
                                    text: 'Accommodations',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const Accommodationpage(title: 'Accommodation Details')),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 15),
                                  CircularItem(
                                    icon: Icons.video_call,
                                    text: 'Forum',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ReviewPage(onCommentAdded: (String) { },)),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 15),
                                  CircularItem(
                                    icon: Icons.explore,
                                    text: 'Dashboard',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const DashboardPage(title: 'Inputs')),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 15),
                                  CircularItem(
                                    icon: Icons.landscape,
                                    text: 'Game parks',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const Gameparkpage(title: 'Gamepark Details')),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 15),
                                  CircularItem(
                                    icon: Icons.book_online,
                                    text: 'Transportation',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const TransportPage()),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
         const SizedBox(height: 10),
          Container(
             height: 410,
            child: Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final result = _searchResults[index];
                  return ListTile(
                    title: Text(result['name']),
                    subtitle: Text(result['city_name'] + ', ' + result['country']),
                    leading: Image.network(result['image_url']),
                    onTap: () {
                      // Handle tapping on search results if needed
                    },
                  );
                },
              ),
            ),
          ),                   

                          const SizedBox(height: 1),
                          const Text(
                            'Discover places',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                         Container(
  height: 5000,
  child: ListView.builder(
    
    physics: const NeverScrollableScrollPhysics(),
    itemCount: _placesBox.length, 
    itemBuilder: (context, index) {
      final place = _placesBox.getAt(index); 
  
      if (place == null) {
        return const SizedBox();
      }
       print('Displaying place at index $index: ${place.toJson()}');
        print('Displaying place at index $index: ${place.placeName}');
      print('Displaying place at index $index: ${place.placeImageUrl}');

     
    final String assetPath = 'assets/images/${place?.placeImageUrl ?? ''}';
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
                        place.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: place.isLiked ? Colors.red : Color.fromARGB(255, 250, 226, 7),
                      ),
                      onPressed: () {
                        setState(() {
                          place.isLiked = !place.isLiked;
                          _placesBox.putAt(index, place);
                        });
                      },
                    ),
                  ),
                  Positioned(
                    bottom: -10.0,
                    left: -10.0,
                    child: IconButton(
                      icon: Icon(
                        place.isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                        color: place.isBookmarked ? Colors.orange : Colors.yellow,
                      ),
                      onPressed: () {
                        setState(() {
                          place.isBookmarked = !place.isBookmarked;
                          _placesBox.putAt(index, place);
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
                      place.placeName,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      place.placeDescription,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '\$${place.placePrice}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (starIndex) {
                        return IconButton(
                          icon: Icon(
                            starIndex < (place.rating) ? Icons.star : Icons.star_border,
                            color: starIndex < (place.rating) ? Colors.yellow : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              place.rating = starIndex + 1;
                              _placesBox.putAt(index, place);
                            });
                          },
                        );
                      }),
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

/*
 Container(
        //height: 410,
        height: MediaQuery.of(context).size.height,
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: _placesBox.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
           
     final place = _placesBox.getAt(index); 
  
    final String assetPath = 'assets/images/${place?.placeImageUrl ?? ''}';

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
              child: Container(
                width: 150, // You can customize the width as per your needs
                height: index.isEven ? 410 : (index == 1 ? 420 : 500), // Even indices 300, odd indices 200 and 250
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
                            width: double.infinity,
                            height: index.isEven ? 150 : (index == 1 ? 100 : 150), // Even indices 150, odd indices 100 and 150
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: -10.0,
                          right: -10.0,
                          child: IconButton(
                            icon: Icon(
                              place!.isLiked ? Icons.favorite : Icons.favorite_border,
                              color: place.isLiked ? Colors.red : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                place.isLiked = !place.isLiked;
                                _placesBox.putAt(index, place);
                              });
                            },
                          ),
                        ),
                        Positioned(
                          bottom: -10.0,
                          left: -10.0,
                          child: IconButton(
                            icon: Icon(
                              place.isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                              color: place.isBookmarked ? Colors.orange : Colors.yellow,
                            ),
                            onPressed: () {
                              setState(() {
                                place.isBookmarked = !place.isBookmarked;
                                _placesBox.putAt(index, place);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            place.placeName,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            place.placeDescription,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            '\$${place.placePrice}',
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (starIndex) {
                              return IconButton(
                                icon: Icon(
                                  starIndex < (place.rating ?? 0) ? Icons.star : Icons.star_border,
                                  color: starIndex < (place.rating ?? 0) ? Colors.yellow : Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    place.rating = starIndex + 1;
                                    _placesBox.putAt(index, place);
                                  });
                                },
                              );
                            }),
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
      ),*/
    
  


                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}