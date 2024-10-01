import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import '../model/hotel.dart';
import '../model/place.dart';
import '../model/users.dart';

import '../widgets/common_scaffold.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
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
    List<Place> BookmarkedPlaces = placesBox.values.where((place) => place.isBookmarked).toList();
    List<Accommodation> BookmarkedAccommodations = _accommodationsBox.values.where((accommodation) => accommodation.isBookmarked).toList();
     
       
    return CommonScaffold(
      currentIndex: 2,
      userfirstName: user.userfirstName,
      places: BookmarkedPlaces.map((place) => place.toJson()).toList(),
      body: ListView(
        children: [
          _buildPlaceList(BookmarkedPlaces),
          _buildAccommodationList(BookmarkedAccommodations),
           
          
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
            'isBookmarked Places',
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
                icon: Icon(place.isLiked ? Icons.bookmark : Icons.bookmark_border),
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
            'isBookmarked Accommodations',
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
                backgroundImage: AssetImage('assets/images/${accommodation.imageUrl}'),
              ),
              title: Text(accommodation.name),
              subtitle: Text(accommodation.cityName),
              trailing: IconButton(
                icon: Icon(accommodation.isLiked ? Icons.bookmark : Icons.bookmark_border),
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
  