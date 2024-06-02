import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import '../model/biome.dart';
import '../model/place.dart';
import '../model/profile.dart';
import '../model/tundra.dart';
import '../screens/profile_page.dart';
import '../screens/home_page.dart';
import '../screens/favorites_page.dart';
import '../screens/bookmark_page.dart';
import '../screens/settings_page.dart';


class CommonScaffold extends StatefulWidget {
  final Widget body;
  final int currentIndex;
  final String userFirstName;
  final List<Map<String, dynamic>> places;
  final List<Tundra> tundras;
  final List<Biome> biomes;

  const CommonScaffold({super.key, 
    required this.body,
    required this.currentIndex,
    required this.userFirstName,
    required this.places,
    required this.tundras,
    required this.biomes,
  });

  @override
  _CommonScaffoldState createState() => _CommonScaffoldState();
}

class _CommonScaffoldState extends State<CommonScaffold> {
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentPage = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FavoritesPage()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => BookmarkPage(
                    places:placesList(widget.places),
                    tundras: widget.tundras,
                    biomes: widget.biomes,
                  )),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()),
        );
        break;
    }
  }
   List<Place> placesList(List<Map<String, dynamic>> placesData) {
    List<Place> places = [];
    for (var placeData in placesData) {
      // Assuming Place.fromJson is a method to convert JSON to Place object
      Place place = Place.fromJson(placeData);
      places.add(place);
    }
    return places;
  }
 
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 73, 4),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "HiddenHaven",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Row(
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProfilePage(profiles: profile)),
                        );
                      },
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 12,
                        child: Icon(Icons.person, color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 2.0),
                    Text(
                      widget.userFirstName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: widget.body,
      bottomNavigationBar: BottomBar(
        selectedIndex: _currentPage,
        onTap: _onItemTapped,
        items: <BottomBarItem>[
          const BottomBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            activeColor: Colors.blue,
          ),
          const BottomBarItem(
            icon: Icon(Icons.favorite),
            title: Text('Favorites'),
            activeColor: Colors.red,
          ),
          BottomBarItem(
            icon: const Icon(Icons.bookmark),
            title: const Text('Bookmark'),
            activeColor: Colors.greenAccent.shade700,
          ),
          const BottomBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
            activeColor: Colors.orange,
          ),
        ],
      ),
    );
    
  }
}
