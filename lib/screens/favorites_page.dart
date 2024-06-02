

import 'package:flutter/material.dart';
import 'package:hidden/widgets/common_scaffold.dart';
import 'package:hive_flutter/adapters.dart';

import '../model/biome.dart';
import '../model/place.dart';
import '../model/tundra.dart';
import '../model/users.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Box<Place> _placesBox;
  List<Map<String, dynamic>> _placesList = [];
  late Box<Tundra> _tundrasBox;
  late Box<Biome> _biomesBox;

  @override
  void initState() {
    super.initState();
    _placesBox = Hive.box<Place>('PlacesBox');
    _tundrasBox = Hive.box<Tundra>('TundrasBox');
    _biomesBox = Hive.box<Biome>('BiomesBox');
  }

  @override
  Widget build(BuildContext context) {
    List<Place> favoritePlaces = _placesBox.values.where((place) => place.isLiked).toList();
    List<Tundra> favoriteTundras = _tundrasBox.values.where((tundra) => tundra.isLiked).toList();
    List<Biome> favoriteBiomes = _biomesBox.values.where((biome) => biome.isLiked).toList();

    return CommonScaffold(
      
      body: ListView(
        children: [
          _buildPlaceList(favoritePlaces),
          _buildTundraList(favoriteTundras),
          _buildBiomeList(favoriteBiomes),
        ],
      ), currentIndex: 1, userFirstName: user.userfirstName, places: _placesList, tundras: [], biomes: [],
    );
  }

  Widget _buildPlaceList(List<Place> places) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Favorite Places',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: places.length,
          itemBuilder: (context, index) {
            Place place = places[index];
            final assetPath = 'assets/images/${place.placeImageUrl}'; 
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(assetPath),
          ),
              title: Text(place.placeName),
              subtitle: Text(place.placeDescription),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBiomeList(List<Biome> biomes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Favorite Biomes',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: biomes.length,
          itemBuilder: (context, index) {
            Biome biome = biomes[index];
            final assetPath = 'assets/images/${biome.imageurl}'; 
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(assetPath),
          ),
              title: Text(biome.biomename),
              subtitle: Text(biome.description),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTundraList(List<Tundra> tundras) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Favorite Tundras',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tundras.length,
          itemBuilder: (context, index) {
            Tundra tundra = tundras[index];
              final assetPath = 'assets/images/${tundra.imageurl}'; 
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(assetPath),
          ),
              title: Text(tundra.tundraname),
              subtitle: Text(tundra.description),
            );
          },
        ),
      ],
    );
  }
}
