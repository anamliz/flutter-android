import 'package:hive/hive.dart';

part 'taxi.g.dart';

@HiveType(typeId: 8)
class Taxi extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final double latitude;

  @HiveField(2)
  final String types;

  @HiveField(3)
  final double longitude;

  @HiveField(4)
  final String country;

  @HiveField(5)
  final String iata;

  @HiveField(6)
  final String name;

  @HiveField(7)
  final String countryCode;

  @HiveField(8)
  final String city;

  @HiveField(9)
  final String googlePlaceId;

  @HiveField(10)
  final String image_url;

  @HiveField(11)
   int rating;

  @HiveField(12)
  bool isLiked;

  @HiveField(13)
  bool isBookmarked;

  Taxi(
    this.id,
    this.latitude,
    this.types,
    this.longitude,
    this.country,
    this.iata,
    this.name,
    this.countryCode,
    this.city,
    this.googlePlaceId,
    this.image_url,
     
    {
    this.rating =0,
    this.isLiked = false,
    this.isBookmarked= false,
    }
);

  factory Taxi.fromJson(Map<String, dynamic> json) {
    return Taxi(
     // json['flights_id'] as int? ?? 0,
       int.tryParse(json['id']?.toString() ?? '0') ?? 0,
       double.tryParse(json['latitude']?.toString() ?? '') ?? 0.0,
       json['types'] as String? ?? '',
       double.tryParse(json['longitude']?.toString() ?? '') ?? 0.0,
      json['country'] as String? ?? '',
      json['iata'] as String? ?? '',
      json['name'] as String? ?? '',
      json['countryCode'] as String? ?? '',
      json['city'] as String? ?? '',
      json['googlePlaceId'] as String? ?? '',
      json['image_url'] as String? ?? '',
     
      rating: json['rating'] is int ? json['rating'] : int.tryParse(json['rating']?.toString() ?? '0') ?? 0,
      // rating: json['rating'] != null ? int.parse(json['rating']) : 0,
    isLiked: json['isLiked'] == 'true', 
    isBookmarked: json['isBookmarked'] == 'true', 
      
        
    );
  }

  Map<String, dynamic> toJson() {
    return {
      
      'id': id,
      'latitude': latitude,
      'types': types,
      'longitude': longitude,
      'country': country,
      'iata': iata,
      'name': name,
      'countryCode': countryCode,
      'city': city,
      'googlePlaceId': googlePlaceId,
      'image_url': image_url,
      'rating': rating,
      'isLiked': isLiked,
      'isBookmarked': isBookmarked,
      
    };
  }
}