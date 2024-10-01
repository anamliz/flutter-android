import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import '../model/hotel.dart';
import '../model/place.dart';
import '../model/users.dart';

import '../widgets/common_scaffold.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Box<Place> placesBox;
  late Box<Accommodation> _accommodationsBox;
  

  @override
  void initState() {
    super.initState();
    _openBoxes();
  }

  Future<void> _openBoxes() async {
    placesBox = await Hive.openBox<Place>('PlacesBox');
    _accommodationsBox = await Hive.openBox<Accommodation>('AccommodationsBox');
  

    setState(() {}); // Trigger a rebuild after the boxes are opened
  }

  @override
  Widget build(BuildContext context) {
    List<Place> favoritePlaces = placesBox.values.where((place) => place.isLiked).toList();
    List<Accommodation> favoriteAccommodations = _accommodationsBox.values.where((accommodation) => accommodation.isLiked).toList();
     
       
    return CommonScaffold(
      currentIndex: 1,
      userfirstName: user.userfirstName,
      places: favoritePlaces.map((place) => place.toJson()).toList(),
      body: ListView(
        children: [
          _buildPlaceList(favoritePlaces),
          _buildAccommodationList(favoriteAccommodations),
           
          
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
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/${place.placeImageUrl}'),
              ),
              title: Text(place.placeName),
              subtitle: Text(place.placeDescription),
              trailing: IconButton(
                icon: Icon(place.isLiked ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  setState(() {
                    place.isLiked = !place.isLiked;
                    placesBox.put(place.id, place);
                  });
                },
              ),
            );
          },
        ),
      ],
    );
  }



  Widget _buildAccommodationList(List<Accommodation> accommodations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Favorite Accommodations',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: accommodations.length,
          itemBuilder: (context, index) {
            Accommodation accommodation = accommodations[index];
            return ListTile(
             leading: CircleAvatar(
                     backgroundImage: NetworkImage('/phalc/hotel/${accommodation.imageUrl}'), 
                //backgroundImage: AssetImage('assets/images/${accommodation.imageUrl}'),
              ),
              title: Text(accommodation.name),
              subtitle: Text(accommodation.cityName),
              trailing: IconButton(
                icon: Icon(accommodation.isLiked ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  setState(() {
                    accommodation.isLiked = !accommodation.isLiked;
                    _accommodationsBox.put(accommodation.destId, accommodation);
                  });
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
  