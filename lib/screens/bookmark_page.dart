/*import 'package:flutter/material.dart';
import '../model/place.dart';
// Import your Place model

class BookmarkPage extends StatelessWidget {
  final List<Place> places; // List of all places

  const BookmarkPage({Key? key, required this.places}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter out the bookmarked places
    List<Place> bookmarkedPlaces = places.where((place) => place.isBookmarked).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: ListView.builder(
        itemCount: bookmarkedPlaces.length,
        itemBuilder: (context, index) {
          final place = bookmarkedPlaces[index];
          final assetPath = 'assets/images/${place.placeImageUrl}'; // Assuming placeimageurl contains the image file name
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(assetPath),
            ),
            title: Text(place.placeName),
            subtitle: Text(place.placeDescription),
            // Add onTap functionality as per your requirement
          );
        },
      ),
    );
  }
}*/


import 'package:flutter/material.dart';
import 'package:hidden/widgets/common_scaffold.dart';
import 'package:hive/hive.dart';
import 'package:hidden/model/biome.dart';
import 'package:hidden/model/place.dart';
import 'package:hidden/model/tundra.dart';

import '../model/users.dart';

class BookmarkPage extends StatefulWidget {
   final List<Place> places;
    final List<Tundra> tundras;
     final List<Biome> biomes;

  //const BookmarkPage({super.key});
     const BookmarkPage({super.key, required this.places,required this.tundras,required this.biomes});
 

  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  List<Map<String, dynamic>> _placesList = [];

  late Box<Place> _placesBox;
  late Box<Biome> _biomesBox;
  late Box<Tundra> _tundrasBox;

  @override
  void initState() {
    super.initState();
    _placesBox = Hive.box<Place>('PlacesBox');
    _biomesBox = Hive.box<Biome>('BiomesBox');
    _tundrasBox = Hive.box<Tundra>('TundrasBox');
  }

  Widget _buildBookmarkedPlaceList(List<Place> places) {
    List<Place> bookmarkedPlaces = places.where((place) => place.isBookmarked).toList();
    return ListView.builder(
      itemCount: bookmarkedPlaces.length,
      itemBuilder: (context, index) {
        Place place = bookmarkedPlaces[index];
        final assetPath = 'assets/images/${place.placeImageUrl}';
        return ListTile(
          leading: CircleAvatar(
              backgroundImage: AssetImage(assetPath),
            ),
          title: Text(place.placeName),
          subtitle: Text(place.placeDescription),
        );
      },
    );
  }

  Widget _buildBookmarkedBiomeList(List<Biome> biomes) {
    List<Biome> bookmarkedBiomes = biomes.where((biome) => biome.isBookmarked).toList();
    return ListView.builder(
      itemCount: bookmarkedBiomes.length,
      itemBuilder: (context, index) {
        Biome biome = bookmarkedBiomes[index];
        final assetPath = 'assets/images/${biome.imageurl}';
        return ListTile(
          leading: CircleAvatar(
              backgroundImage: AssetImage(assetPath),
            ),
          title: Text(biome.biomename),
          subtitle: Text(biome.description),
        );
      },
    );
    
  }

  Widget _buildBookmarkedTundraList(List<Tundra> tundras) {
    List<Tundra> bookmarkedTundras = tundras.where((tundra) => tundra.isBookmarked).toList();
    return ListView.builder(
      itemCount: bookmarkedTundras.length,
      itemBuilder: (context, index) {
        Tundra tundra = bookmarkedTundras[index];
        final assetPath = 'assets/images/${tundra.imageurl}';
        return ListTile(
          leading: CircleAvatar(
              backgroundImage: AssetImage(assetPath),
            ),
          title: Text(tundra.tundraname),
          subtitle: Text(tundra.description),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
     
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              ' Places',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: _buildBookmarkedPlaceList(_placesBox.values.toList())),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              ' Biomes',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: _buildBookmarkedBiomeList(_biomesBox.values.toList())),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              ' Tundras',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: _buildBookmarkedTundraList(_tundrasBox.values.toList())),
        ],
      ), currentIndex:2, userFirstName: user.userfirstName, places: _placesList, tundras: [], biomes: [],
    );
  }
}

