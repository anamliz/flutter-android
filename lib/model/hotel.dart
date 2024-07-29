import 'package:hive/hive.dart';

part 'hotel.g.dart';

@HiveType(typeId: 1)
class Accommodation extends HiveObject {
  @HiveField(0)
  final String destId;

  @HiveField(1)
  final String searchType;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final String cityName;

  @HiveField(4)
  final String lc;

  @HiveField(5)
  final String label;

  @HiveField(6)
  final String destType;

  @HiveField(7)
  final String roundtrip;

  @HiveField(8)
  final String cc1;

  @HiveField(9)
  final double longitude;

  @HiveField(10)
  final double latitude;

  @HiveField(11)
  final String country;

  @HiveField(12)
  final String region;

  @HiveField(13)
  final int hotels;

  @HiveField(14)
  final int nrHotels;

  @HiveField(15)
  final String name;

  @HiveField(16)
  final int cityUfi;

  @HiveField(17)
   int rating;

  @HiveField(18)
  bool isLiked;

  @HiveField(19)
  bool isBookmarked;

  Accommodation(
    this.destId,
    this.searchType,
    this.imageUrl,
    this.cityName,
    this.lc,
    this.label,
    this.destType,
    this.roundtrip,
    this.cc1,
    this.longitude,
    this.latitude,
    this.country,
    this.region,
    this.hotels,
    this.nrHotels,
    this.name,
    this.cityUfi, 
    {
    this.rating =0,
    this.isLiked = false,
    this.isBookmarked= false,
    }
);

  factory Accommodation.fromJson(Map<String, dynamic> json) {
    return Accommodation(
      json['dest_id'] as String? ?? '',
      json['search_type'] as String? ?? '',
      json['image_url'] as String? ?? '',
      json['city_name'] as String? ?? '',
      json['lc'] as String? ?? '',
      json['label'] as String? ?? '',
      json['dest_type'] as String? ?? '',
      json['roundtrip'] as String? ?? '',
      json['cc1'] as String? ?? '',
      double.tryParse(json['longitude']?.toString() ?? '') ?? 0.0,
      double.tryParse(json['latitude']?.toString() ?? '') ?? 0.0,
      json['country'] as String? ?? '',
      json['region'] as String? ?? '',
      json['hotels'] is String ? int.tryParse(json['hotels']) ?? 0 : json['hotels'] as int? ?? 0,
      json['nr_hotels'] is String ? int.tryParse(json['nr_hotels']) ?? 0 : json['nr_hotels'] as int? ?? 0,
      json['name'] as String? ?? '',
      json['city_ufi'] is String ? int.tryParse(json['city_ufi']) ?? 0 : json['city_ufi'] as int? ?? 0,
      rating: json['rating'] is String ? int.tryParse(json['rating'] as String? ?? '0') ?? 0 : json['rating'] as int? ?? 0,
    isLiked: json['isLiked'] == 'true', 
    isBookmarked: json['isBookmarked'] == 'true', 
      
        
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dest_id': destId,
      'search_type': searchType,
      'image_url': imageUrl,
      'city_name': cityName,
      'lc': lc,
      'label': label,
      'dest_type': destType,
      'roundtrip': roundtrip,
      'cc1': cc1,
      'longitude': longitude,
      'latitude': latitude,
      'country': country,
      'region': region,
      'hotels': hotels,
      'nr_hotels': nrHotels,
      'name': name,
      'city_ufi': cityUfi,
      'rating': rating,
      'isLiked': isLiked,
      'isBookmarked': isBookmarked,
      
    };
  }
}