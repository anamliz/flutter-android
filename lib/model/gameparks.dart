

import 'package:hive/hive.dart';
part 'gameparks.g.dart';

@HiveType(typeId: 9)
class Park extends HiveObject {

  @HiveField(0)
  final int park_id;

  @HiveField(1)
  final String park_name;

  @HiveField(2)
  final String park_location;

  @HiveField(3)
  final double size_in_acres;

  @HiveField(4)
  final DateTime established_date;

  @HiveField(5)
  final double entry_fee;

  @HiveField(6)
  final String image_url;

  @HiveField(7)
  int rating;

  @HiveField(8)
  bool isLiked;

  @HiveField(9)
  bool isBookmarked;

  Park(
    this.park_id,
    this.park_name, 
    this.park_location, 
    this.size_in_acres,
    this.established_date, 
    this.entry_fee,
    this.image_url,
    {this.rating = 0,
     this.isLiked = false,
     this.isBookmarked = false,}
  );

  factory Park.fromJson(dynamic json) {
    return Park(
      int.tryParse(json['park_id']?.toString() ?? '0') ?? 0,
      json['park_name'] as String? ?? '',
      json['park_location'] as String? ?? '',
      double.tryParse(json['size_in_acres']?.toString() ?? '0.0') ?? 0.0,
      DateTime.tryParse(json['established_date']?.toString() ?? '') ?? DateTime.now(),
      double.tryParse(json['entry_fee']?.toString() ?? '0.0') ?? 0.0,
      json['image_url'] as String? ?? '',
      rating: json['rating'] is int ? json['rating'] : int.tryParse(json['rating']?.toString() ?? '0') ?? 0,
      isLiked: json['isLiked'] == true,
      isBookmarked: json['isBookmarked'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'park_id': park_id,
      'park_name': park_name,
      'park_location': park_location,
      'size_in_acres': size_in_acres,
      'established_date': established_date.toIso8601String(),
      'entry_fee': entry_fee,
      'image_url': image_url,
      'rating': rating,
      'isLiked': isLiked,
      'isBookmarked': isBookmarked,
    };
  }
  
   /*// ignore: non_constant_identifier_names
   List<Park> Parks = [
         Park( 1, "Kora National Park", "elephants, Lesser Kudus, wild dogs, striped and spotted hyenas, leopards, lions and cheetahs. There are about 500 species of insects, 40 reptiles in the park. Visitors can enjoy bird watching, hiking, river rafting, fishing, rock climbing, camping and visits to the George Adamson's grave.","Kora National Park is located in Tana River County,Kenya. The park covers an area of 1,788 square kilometres. It is located 125 kilometres east of Mount Kenya. The park was initially gazetted as a nature reserve in 1973.", 100, 4,"A1.jpg"),
         Park( 2, "Lake Nakuru ","Rhino","", 100,5,"A2.jpg"),
         Park( 3, "Amboseli  Park", " Lion","", 100,5,"A3.jpg"),
         Park( 4, "Aberdare  Park", "Leopard","", 100,5,"A4.jpg"),
         Park( 5, "Masai Mara","buffelo", "", 100,5,"A5.jpg"),
         Park( 6, "Bwindi National Park", "Giraffe","", 100,4,"A6.jpg"),
         Park( 7, "Tsavo National Park", "Zebra","", 100,5,"A7.jpg"),
                 ];*/

}
