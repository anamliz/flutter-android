/*import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import '/model/accommondation.dart';
import '../model/users.dart';
import 'booking_page.dart';

class Accommodationpage extends StatefulWidget {
  final String title;

  const Accommodationpage({Key? key, required this.title}) : super(key: key);

  @override
  State<Accommodationpage> createState() => _AccommodationpageState();
}

class _AccommodationpageState extends State<Accommodationpage> {
  List<String> comments = [];
  
  int _currentPage = 0;
  final PageController _pageController = PageController();

late Box<Hotel> hotelsBox;
  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
    _initializeData();
    //openBox();
  }

  //Future<void> openBox() async {
    Future<void> _initializeData() async {
       try {

    hotelsBox = await Hive.openBox<Hotel>('hotelsBox');
     // _hotelsBox.clear();
    
      for (var hotel in hotels) {
      final existingHotel = hotelsBox.get(hotel.id);
      if (existingHotel == null) {
        hotelsBox.put(hotel.id, hotel); // Assuming `hotel.id` is unique
        print('Hotel with ID ${hotel.id} inserted.');
      }
    }

    setState(() {
      _isLoading = false;
    });

     setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

 void updateLikedStatus(int index) {
    final Hotel? hotel = hotelsBox.getAt(index); // Use hotelsBox here
    if (hotel != null) {
      setState(() {
        hotel.isLiked = !hotel.isLiked;
        hotelsBox.putAt(index, hotel); // Update the hotel in hotelsBox
      });
    }
  }

  void updateBookmarkedStatus(int index) {
    final Hotel? hotel = hotelsBox.getAt(index); // Use hotelsBox here
    if (hotel != null) {
      setState(() {
        hotel.isBookmarked = !hotel.isBookmarked;
        hotelsBox.putAt(index, hotel); // Update the hotel in hotelsBox
      });
    }
    void updateHotelRating(Hotel hotel, int newRating) {
  // Assuming hotel.rating is in the range of 1 to 5
  if (newRating >= 1 && newRating <= 5) {
    setState(() {
      hotel.rating = newRating;
      // Update the rating in Hive or your database
      hotelsBox.putAt(index, hotel);
    });
  } else {
    // Handle invalid ratings
    print('Invalid rating. Rating should be between 1 and 5.');
  }
}

  }
    



  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 73, 4),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Accommodation",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Column(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 12,
                  child: Icon(Icons.person, color: Colors.black),
                ),
                const SizedBox(width: 2.0),
                Text(
                  user.userfirstName, // Assuming user is defined elsewhere
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return HotelCard(hotel: hotels[index]); // Assuming hotels is defined elsewhere
                },
                childCount: hotels.length, // Assuming hotels is defined elsewhere
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (int index) {
          if (index == 0) {
            Navigator.pop(context);
          } else {
            _pageController.jumpToPage(index);
            setState(() => _currentPage = index);
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class HotelCard extends StatefulWidget {
  final Hotel hotel;

  const HotelCard({Key? key, required this.hotel}) : super(key: key);

  @override
  _HotelCardState createState() => _HotelCardState();
}

class _HotelCardState extends State<HotelCard> {


  List<String> comments = [];
  
  int _currentPage = 0;
  final PageController _pageController = PageController();

late Box<Hotel> hotelsBox;
  bool _isLoading = true;
  
  


  @override
  void initState() {
    super.initState();
    _initializeData();
    //openBox();
  }

  //Future<void> openBox() async {
    Future<void> _initializeData() async {
       try {

    hotelsBox = await Hive.openBox<Hotel>('hotelsBox');
     // _hotelsBox.clear();
    
      for (var hotel in hotels) {
      final existingHotel = hotelsBox.get(hotel.id);
      if (existingHotel == null) {
        hotelsBox.put(hotel.id, hotel); // Assuming `hotel.id` is unique
        print('Hotel with ID ${hotel.id} inserted.');
      }
    }

    setState(() {
      _isLoading = false;
    });

     setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

 void updateLikedStatus(int index) {
    final Hotel? hotel = hotelsBox.getAt(index); // Use hotelsBox here
    if (hotel != null) {
      setState(() {
        hotel.isLiked = !hotel.isLiked;
        hotelsBox.putAt(index, hotel); // Update the hotel in hotelsBox
      });
    }
  }

  void updateBookmarkedStatus(int index) {
    final Hotel? hotel = hotelsBox.getAt(index); // Use hotelsBox here
    if (hotel != null) {
      setState(() {
        hotel.isBookmarked = !hotel.isBookmarked;
        hotelsBox.putAt(index, hotel); // Update the hotel in hotelsBox
      });
    }

    void updateHotelRating(Hotel hotel, int newRating) {
  // Assuming hotel.rating is in the range of 1 to 5
  if (newRating >= 1 && newRating <= 5) {
    setState(() {
      hotel.rating = newRating;
      // Update the rating in Hive or your database
      hotelsBox.putAt(index, hotel);
    });
  } else {
    // Handle invalid ratings
    print('Invalid rating. Rating should be between 1 and 5.');
  }
}


  }
    

  
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
     final Hotel hotel = widget.hotel;
     
    final assetPath = 'assets/images/${widget.hotel.imageurl}';
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
                    hotel.isLiked ? Icons.favorite : Icons.favorite_border,
                            color: hotel.isLiked ? Colors.red : Colors.yellow,
                          
                  ),
                 onPressed: () {
                            setState(() {
                              hotel.isLiked = !hotel.isLiked;
                             // _hotelsBox.putAt(index, hotel);
                                                        });
                      
                    
                  },
                ),
              ),
                Positioned(
                        bottom: -10.0,
                        left: -10.0,
                        child: IconButton(
                          icon: Icon(
                            hotel.isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                            color: hotel.isBookmarked ? Colors.orange : Colors.yellow,
                          ),
                          onPressed: () {
                            setState(() {
                              hotel.isBookmarked = !hotel.isBookmarked;
                            //  hotelsBox.putAt(index, hotel); 
                               
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
                      widget.hotel.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the booking screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingPage(selectedHotel: widget.hotel),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 1, 58, 105),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      child: const Text(
                        'BOOK NOW',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(widget.hotel.description),
                const SizedBox(height: 1.0),
                Text(
                  '\$${widget.hotel.price.toStringAsFixed(1)}',
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
                      icon: Icon(
                        starIndex <= widget.hotel.rating ? Icons.star : Icons.star_border,
                        color: starIndex <= widget.hotel.rating ? Colors.yellow : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.hotel.rating = starIndex;
                          // Update the rating in Hive or your database
                            void updateHotelRating(Hotel hotel, int newRating) {
  // Assuming hotel.rating is in the range of 1 to 5
  if (newRating >= 1 && newRating <= 5) {
    setState(() {
      hotel.rating = newRating;
      // Update the rating in Hive or your database
      hotelsBox.putAt(index, hotel);
    });
  } else {
    // Handle invalid ratings
    print('Invalid rating. Rating should be between 1 and 5.');
  }
}

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
    );
  }
}*/


import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

import '../model/accommondation.dart';
import '../model/users.dart';
import 'booking_page.dart';

void main() {
  runApp(const MaterialApp(home: Accommodationpage(title: 'Accommodation')));
}

final Logger logger = Logger();

class Accommodationpage extends StatefulWidget {
  final String title;

  const Accommodationpage({Key? key, required this.title}) : super(key: key);

  @override
  State<Accommodationpage> createState() => _AccommodationpageState();
}

class _AccommodationpageState extends State<Accommodationpage> {
  List<String> comments = [];

  int _currentPage = 0;
  final PageController _pageController = PageController();

  late Box<Hotel> hotelsBox;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      hotelsBox = await Hive.openBox<Hotel>('hotelsBox');
      for (var hotel in hotels) {
        final existingHotel = hotelsBox.get(hotel.id);
        if (existingHotel == null) {
          hotelsBox.put(hotel.id, hotel); // Assuming `hotel.id` is unique
          print('Hotel with ID ${hotel.id} inserted.');
        }
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing data: $e');
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
      print('Invalid rating. Rating should be between 1 and 5.');
    }
  }
  

  void _fetchHotel() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1/phalc/accommodation'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Fetched hotels: $data');
        // Process the fetched data as needed
      } else {
        print('Failed to fetch hotels: ${response.statusCode}');
        _showErrorDialog('Failed to fetch hotels: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred while fetching hotels: $e');
      logger.e('Error occurred while fetching hotels: $e');
      _showErrorDialog('An error occurred while fetching hotels: $e');
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 73, 4),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Accommodation",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Column(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 12,
                  child: Icon(Icons.person, color: Colors.black),
                ),
                const SizedBox(width: 2.0),
                Text(
                  user.userfirstName, // Assuming user is defined elsewhere
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return HotelCard(hotel: hotels[index]); // Assuming hotels is defined elsewhere
                },
                childCount: hotels.length, // Assuming hotels is defined elsewhere
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (int index) {
          if (index == 0) {
            Navigator.pop(context);
          } else {
            _pageController.jumpToPage(index);
            setState(() => _currentPage = index);
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class HotelCard extends StatefulWidget {
  final Hotel hotel;

  const HotelCard({Key? key, required this.hotel}) : super(key: key);

  @override
  _HotelCardState createState() => _HotelCardState();
}

class _HotelCardState extends State<HotelCard> {
  List<String> comments = [];

  int _currentPage = 0;
  final PageController _pageController = PageController();

  late Box<Hotel> hotelsBox;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      hotelsBox = await Hive.openBox<Hotel>('hotelsBox');
      for (var hotel in hotels) {
        final existingHotel = hotelsBox.get(hotel.id);
        if (existingHotel == null) {
          hotelsBox.put(hotel.id, hotel); // Assuming `hotel.id` is unique
          print('Hotel with ID ${hotel.id} inserted.');
        }
      }
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing data: $e');
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
      print('Invalid rating. Rating should be between 1 and 5.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Hotel hotel = widget.hotel;

    final assetPath = 'assets/images/${widget.hotel.imageurl}';
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
                    hotel.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: hotel.isLiked ? Colors.red : Colors.yellow,
                  ),
                  onPressed: () {
                    setState(() {
                      hotel.isLiked = !hotel.isLiked;
                    });
                  },
                ),
              ),
              Positioned(
                bottom: -10.0,
                left: -10.0,
                child: IconButton(
                  icon: Icon(
                    hotel.isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                    color: hotel.isBookmarked ? Colors.orange : Colors.yellow,
                  ),
                  onPressed: () {
                    setState(() {
                      hotel.isBookmarked = !hotel.isBookmarked;
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
                      widget.hotel.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the booking screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingPage(selectedHotel: widget.hotel),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 1, 58, 105),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      child: const Text(
                        'BOOK NOW',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(widget.hotel.description),
                const SizedBox(height: 1.0),
                Text(
                  '\$${widget.hotel.price.toStringAsFixed(1)}',
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
                      icon: Icon(
                        starIndex <= widget.hotel.rating ? Icons.star : Icons.star_border,
                        color: starIndex <= widget.hotel.rating ? Colors.yellow : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.hotel.rating = starIndex;
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
    );
  }
}
