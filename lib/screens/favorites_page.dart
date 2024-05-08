/*
    
import 'package:flutter/material.dart';
import '../model/place.dart';

import '/model/tundra.dart';
import '/model/biome.dart'; // Import your data models

class FavoritesPage extends StatelessWidget {
  static const routeName = '/favorites';

  @override
  Widget build(BuildContext context) {
    // Filter out the liked places, tundras, and biomes
    List<Place> likedPlaces = places.where((place) => place.isLiked).toList();
    List<Tundra> likedTundras = tundras.where((tundra) => tundra.isLiked).toList();
    List<Biome> likedBiomes = biomes.where((biome) => biome.isLiked).toList();

    return Scaffold(
      appBar: AppBar(title: Text("Favorites")),
      body: ListView(
        children: [
          if (likedPlaces.isNotEmpty) ...[
            _buildSectionTitle('Liked Places'),
            _buildPlacesList(likedPlaces),
          ],
          if (likedTundras.isNotEmpty) ...[
            _buildSectionTitle('Liked Tundras'),
            _buildTundrasList(likedTundras),
          ],
          if (likedBiomes.isNotEmpty) ...[
            _buildSectionTitle('Liked Biomes'),
            _buildBiomesList(likedBiomes),
          ],
          if (likedPlaces.isEmpty && likedTundras.isEmpty && likedBiomes.isEmpty)
            Center(child: Text('No favorite items yet')),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPlacesList(List<Place> places) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
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
    );
  }

  Widget _buildTundrasList(List<Tundra> tundras) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: tundras.length,
      itemBuilder: (context, index) {
        final tundra = tundras[index];
        final assetPath = 'assets/images/${tundra.imageurl}'; // Assuming tundraimageurl contains the image file name
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage(assetPath),
          ),
          title: Text(tundra.tundraname),
          subtitle: Text(tundra.description),
          // Add onTap functionality as per your requirement
        );
      },
    );
  }

  Widget _buildBiomesList(List<Biome> biomes) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: biomes.length,
      itemBuilder: (context, index) {
        final biome = biomes[index];
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
}
*/

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../model/biome.dart';
import '../model/place.dart';
import '../model/tundra.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Box<Place> _placesBox;
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: ListView(
        children: [
          _buildPlaceList(favoritePlaces),
          _buildTundraList(favoriteTundras),
          _buildBiomeList(favoriteBiomes),
        ],
      ),
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
