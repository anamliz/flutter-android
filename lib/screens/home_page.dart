import 'package:flutter/material.dart';
import 'package:hidden/widgets/common_scaffold.dart';
import 'package:logger/logger.dart';
import 'dart:convert'; 
import 'package:http/http.dart' as http; 
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import '../model/hotel.dart';
import '../model/place.dart';
import '../model/users.dart';
import '../screens/review_page.dart';
import '../screens/accommodation_page.dart';
import '../screens/gamepark_page.dart';
import '../screens/gem_page.dart';
import '../screens/transport_page.dart';
import '../widgets/images_widgets.dart';
import 'booking_page.dart';
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

  late Box<Accommodation> _accommodationsBox;
  List<Map<String, dynamic>> _placesList = [];
  //search
 final TextEditingController _searchController = TextEditingController();
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

 // await Hive.deleteBoxFromDisk('accommodationsBox');
 _accommodationsBox = await Hive.openBox<Accommodation>('AccommodationsBox');
      //_accommodationsBox.clear();
       
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
          //print('Fetched places: $_placesList');

          // Store the fetched data in Hive
         for (var placeData in _placesList) {
         
            try {
               final place = Place.fromJson(placeData);
            _placesBox.put(place.id, place);
           //print('Place added to _placesBox: ${place.toJson()}');
           } catch (e) {
              widget.logger.e('Error parsing place data: $e');
              widget.logger.d('Place data: $placeData');
            }
          }
           // print('placesBox now has ${_placesBox.length} entries');
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
  //print('Place added to _placesBox: $Place');
  }
 
  Future<void> _search(String query) async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1/phalc/hotel'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse["status"] == "success") {
          setState(() {
            _searchResults = (jsonResponse['data'] as List<dynamic>)
                .map((item) => item as Map<String, dynamic>)
                .toList();
          });
                  // Store the fetched data in Hive
          for (var accommodationData in _searchResults) {
            try {
               final accommodation = Accommodation.fromJson(accommodationData);
              
              _accommodationsBox.put(accommodation.destId, accommodation);
              print('Accommodation added to _accommodationsBox: ${accommodation.toJson()}');
            } catch (e) {
              widget.logger.e('Error parsing accommodation data: $e');
              widget.logger.d('Accommodation data: $accommodationData');
            }
          }
          print('accommodationsBox now has ${_accommodationsBox.length} entries');
        } else {
          throw Exception("Unable to get accommodation.");
        }
      } else {
        widget.logger.e('Failed to fetch accommodation: ${response.statusCode}');
      }
    } catch (e) {
      widget.logger.e('Error searching for accommodation: $e');
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
    final accommodation = _accommodationsBox.getAt(index);
    if (accommodation != null) {
      setState(() {
       // accommodation.isLiked = !accommodation.isLiked;
 accommodation.isLiked = !(accommodation.isLiked); // Ensure isLiked is not null
  _accommodationsBox.putAt(index, accommodation);
      });
    }
  }

  void updatePlaceRating(Place place, Accommodation accommodation, int newRating) {
    if (newRating >= 1 && newRating <= 5) {
      setState(() {
        place.rating = newRating;
        _placesBox.put(place.id, place);
      });
    } else {
      widget.logger.w('Invalid rating. Rating should be between 1 and 5.');
    }
    
    if (newRating >= 1 && newRating <= 5) {
      setState(() {
        accommodation.rating = newRating;
        _accommodationsBox.put(accommodation.destId, accommodation);
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
   final accommodation = _accommodationsBox.getAt(index);
    if (accommodation != null) {
      setState(() {
        accommodation.isBookmarked = !(accommodation.isBookmarked);
        _accommodationsBox.putAt(index, accommodation);
      });

    print('Updated isLiked for accommodation at index $index: ${accommodation.isLiked}');
  } else {
    print('Error: Accommodation is null at index $index');
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
                          const SizedBox(height: 4),
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
                                     onSubmitted: (searchController) {
                                    _search(searchController);
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
                                        MaterialPageRoute(builder: (context) =>  GemPage(title: 'Hidden Gem Details')),
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
                          
         const SizedBox(height: 4),
          Container(
             height: 680,
              child:  ListView.builder(
              shrinkWrap: true,
            //physics: const NeverScrollableScrollPhysics(),
             physics: const BouncingScrollPhysics(),  
             scrollDirection: Axis.horizontal,
              itemCount: _accommodationsBox.length,
              itemBuilder: (context, index) {
              final accommodation = _accommodationsBox.getAt(index); 

               if (accommodation == null) {
               return const SizedBox();
      }
                  final String imageUrl = accommodation.imageUrl;
                // final String assetPath = 'assets/images/${accommodation.imageUrl}';
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
                    //child: Image.asset(
                      //assetPath,
                       child: Image.network(
                      imageUrl,
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
            accommodation.isLiked ? Icons.favorite : Icons.favorite_border,
            color: accommodation.isLiked ? Colors.red : const Color.fromARGB(255, 250, 226, 7),
                                    
                      ),
                      onPressed: () {
                        setState(() {
                          accommodation.isLiked = !accommodation.isLiked;

                          _accommodationsBox.putAt(index, accommodation);
                        });
                      },
                    ),
                  ),
                  Positioned(
                    bottom: -10.0,
                    left: -10.0,
                    child: IconButton(
                      icon: Icon(
                        accommodation.isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                        color: accommodation.isBookmarked ? Colors.orange : Colors.yellow,
                
                      ),
                      onPressed: () {
                        setState(() {
                         accommodation.isBookmarked = !accommodation.isBookmarked;
                          
                          _accommodationsBox.putAt(index, accommodation);
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
                     //accommodation.destId,
                       'destId: ${accommodation.destId}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 1.0),
                    Text(
                     'searchType: ${ accommodation.searchType}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 1.0),
                    
                     Text(
                      'cityName: ${accommodation.cityName}',
                       
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                     const SizedBox(height: 1.0),
                     Text(
                      'lc: ${accommodation.lc}',

                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                     const SizedBox(height: 1.0),
                     Text(
                      'label:${accommodation.label}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    
                     const SizedBox(height: 1.0),
                     Text(
                      'destType:${accommodation.destType}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                   
                    const SizedBox(height: 1.0),
                    Text(
                      'cc1:${accommodation.cc1}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 1.0),
                     Text(
                      'longitude:${accommodation.longitude.toString()}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 1.0),
                     Text(
                      'latitude:${accommodation.latitude.toString()}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                     Text(
                      'country:${accommodation.country}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                     const SizedBox(height: 1.0),
                     Text(
                      'region:${accommodation.region}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                     const SizedBox(height: 1.0),
                     Text(
                      'hotels:${accommodation.hotels.toString()}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                     const SizedBox(height: 1.0),
                    Text(
                      'nrHotels:${accommodation.nrHotels.toString()}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                     const SizedBox(height: 1.0),
                     Text(
                      'name:${accommodation.name}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16.0),
                    ),Text(
                      'cityUfi:${accommodation.cityUfi.toString()}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                    

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (starIndex) {
                        return IconButton(
                          icon: Icon(
                            starIndex < (accommodation.rating) ? Icons.star : Icons.star_border,
                            color: starIndex < (accommodation.rating) ? Colors.yellow : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                             accommodation .rating = starIndex + 1;
                              _accommodationsBox.putAt(index, accommodation);
                            });
                          },
                        );
                      }),
                    ),
                                            // Add the Review button
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

                         

                          const SizedBox(height: 4),
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
      // print('Displaying place at index $index: ${place.toJson()}');
        //print('Displaying place at index $index: ${place.placeName}');
      //print('Displaying place at index $index: ${place.placeImageUrl}');

     
    final String assetPath = 'assets/images/${place.placeImageUrl}';
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
                        color: place.isLiked ? Colors.red : const Color.fromARGB(255, 250, 226, 7),
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
                      'placeName:${place.placeName}',
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'placeDescription:${place.placeDescription}',
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
      ),
    );
  }
}