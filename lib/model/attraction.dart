import 'package:hive/hive.dart';

part 'attraction.g.dart';

@HiveType(typeId: 2)
class Destination extends HiveObject {

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String _typename;

  @HiveField(2)
  final int ufi;

  @HiveField(3)
  final String country;

  @HiveField(4)
  final String cityName;

  @HiveField(5)
  final int productCount;

  @HiveField(6)
  final String cc1;

  @HiveField(7)
  final String image_url;

  @HiveField(8)
   int rating;

  @HiveField(9)
  bool isLiked;

  @HiveField(10)
  bool isBookmarked;

  Destination(
    this.id,
    this._typename,
    this.ufi,
    this.country,
    this.cityName,
    this.productCount,
    this.cc1,
    this.image_url,
    {
    this.rating =0,
    this.isLiked = false,
    this.isBookmarked= false,
    }
);

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      json['id'] as String? ?? '',
      json['_typename'] as String? ?? '',
      int.tryParse(json['ufi']?.toString() ?? '0') ?? 0,
      json['country'] as String? ?? '',
      json['cityName'] as String? ?? '',
      int.tryParse(json['productCount']?.toString() ?? '0') ?? 0,
      json['cc1'] as String? ?? '',
      json['image_url'] as String? ?? '',
       rating: json['rating'] is int ? json['rating'] : int.tryParse(json['rating']?.toString() ?? '0') ?? 0,
      isLiked: json['isLiked'] == 'true', 
      isBookmarked: json['isBookmarked'] == 'true', 
      
        
    );
  }

  Map<String, dynamic> toJson() {
    return {
      
      'id': id,
      '_typename': _typename,
      'ufi': ufi,
      'country': country,
      'cityName': cityName,
      'productCount': productCount,
      'cc1': cc1,
      'image_url': image_url,
      'rating': rating,
      'isLiked': isLiked,
      'isBookmarked': isBookmarked,
      
    };
  }
}