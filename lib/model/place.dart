
import 'package:hive/hive.dart';
part 'place.g.dart';

@HiveType(typeId: 0) // TypeId should be unique for each HiveType
class Place extends HiveObject {
  
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String placeName;

  @HiveField(2)
  final String placeDescription;

  @HiveField(3)
  final double placePrice;

  @HiveField(4)
  int rating;

  @HiveField(5)
  final String placeImageUrl;

  @HiveField(6)
  bool isLiked;

  @HiveField(7)
  bool isBookmarked;

  Place(
    this.id,
    this.placeName,
    this.placeDescription,
    this.placePrice,
    this.placeImageUrl, {
    this.rating = 0,
    this.isLiked = false,
    this.isBookmarked = false,
  });

  

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      json['placeName'] as String? ?? '',
      json['placeDescription'] as String? ?? '',
      double.tryParse(json['placePrice']?.toString() ?? '0.0') ?? 0.0,
      json['placeImageUrl'] as String? ?? '',
      rating: json['rating'] is int ? json['rating'] : int.tryParse(json['rating']?.toString() ?? '0') ?? 0,
      isLiked: json['isLiked'] ?? false,
      isBookmarked: json['isBookmarked'] ?? false,
    );
  }
 
  
  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'placename': placeName,
      'placedescription': placeDescription,
      'placeprice': placePrice,
      'rating': rating,
      'placeimageurl':placeImageUrl,
      'isLiked': isLiked,
      'isBookmarked': isBookmarked,
    };
  }
}

