
import 'package:hive/hive.dart';
part 'place.g.dart';

@HiveType(typeId: 0) // TypeId should be unique for each HiveType
class Place extends HiveObject {
  
  @HiveField(0)
  final int placeId;

  @HiveField(1)
  final String placeName;

  @HiveField(2)
  final String placeDescription;

  @HiveField(3)
  final double placePrice;

  @HiveField(4)
  final int rating;

  @HiveField(5)
  final String placeImageUrl;

  @HiveField(6)
  bool isLiked;

  @HiveField(7)
  bool isBookmarked;

  Place(
    this.placeId,
    this.placeName,
    this.placeDescription,
    this.placePrice,
    this.rating,
    this.placeImageUrl, {
    this.isLiked = false,
    this.isBookmarked = false,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      json['placeid'] as int,
      json['placename'] as String,
      json['placedescription'] as String,
      json['placeprice'] as double,
      json['rating'] as int,
      json['placeimageurl'] as String,
      isLiked: json['isLiked'] as bool? ?? false,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'placeid': placeId,
      'placename': placeName,
      'placedescription': placeDescription,
      'placeprice': placePrice,
      'rating': rating,
      'placeimageurl': placeImageUrl,
      'isLiked': isLiked,
      'isBookmarked': isBookmarked,
    };
  }
}

List<Place> places = [
  Place(1, "NEWRAIN RESTAURANT", "K-ROAD JUJA", 200, 3, "hotel.jpg"),
  Place(2, "juja", " hotel", 1000, 2, "u2.jpg"),
  Place(3, "Diani Beach", "white sand", 1000.00, 5, "r5.jpg"),
  Place(4, "Mombasa", "diving", 600, 4, "img7.jpg"),
  Place(5, "Thika", " chaina waterfall", 200, 3, "img6.jpg"),
  Place(6, "kisumu", " beach", 1000, 2, "r1.jpg"),
  Place(7, "Nairobi", " gamepark", 100, 3, "img1.jpg"),
  Place(8, "karura", "waterfall", 500, 4, "img4.jpg"),
  Place(9, "Nanyuki", "waterfall", 500, 5, "img3.jpg"),
  Place(10, "Nanyuki", "beach", 500, 5, "r3.jpg"),

];

