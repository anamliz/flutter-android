import 'package:hive/hive.dart';

part 'flight.g.dart';

@HiveType(typeId: 7)
class Flight extends HiveObject {
  @HiveField(0)
  final int flights_id;

  @HiveField(1)
  final String id;

  @HiveField(2)
  final String type;

  @HiveField(3)
  final String name;

  @HiveField(4)
  final String code;

  @HiveField(5)
  final String city;

  @HiveField(6)
  final String cityName;

  @HiveField(7)
  final String regionName;

  @HiveField(8)
  final String country;

  @HiveField(9)
  final String countryName;

  @HiveField(10)
  final String countryNameShort;

  @HiveField(11)
  final String photoUri;

  @HiveField(12)
   int rating;

  @HiveField(13)
  bool isLiked;

  @HiveField(14)
  bool isBookmarked;

  Flight(
    this.flights_id,
    this.id,
    this.type,
    this.name,
    this.code,
    this.city,
    this.cityName,
    this.regionName,
    this.country,
    this.countryName,
    this.countryNameShort,
    this.photoUri,
     
    {
    this.rating =0,
    this.isLiked = false,
    this.isBookmarked= false,
    }
);

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
     
      int.tryParse(json['flights_id']?.toString() ?? '0') ?? 0,
      json['id'] as String? ?? '',
      json['type'] as String? ?? '',
      json['name'] as String? ?? '',
      json['code'] as String? ?? '',
      json['city'] as String? ?? '',
      json['cityName'] as String? ?? '',
      json['regionName'] as String? ?? '',
      json['country'] as String? ?? '',
      json['countryName'] as String? ?? '',
      json['countryNameShort'] as String? ?? '',
      json['photoUri'] as String? ?? '',
      rating: json['rating'] is int ? json['rating'] : int.tryParse(json['rating']?.toString() ?? '0') ?? 0,
      
    isLiked: json['isLiked'] == 'true', 
    isBookmarked: json['isBookmarked'] == 'true', 
      
        
    );
  }

  Map<String, dynamic> toJson() {
    return {
      
      'flights_id': flights_id,
      'id': id,
      'type': type,
      'name': name,
      'code': code,
      'city': city,
      'cityName': cityName,
      'regionName': regionName,
      'country': country,
      'countryName': countryName,
      'countryNameShor': countryNameShort,
      'photoUri': photoUri,
      'rating': rating,
      'isLiked': isLiked,
      'isBookmarked': isBookmarked,
      
    };
  }
}