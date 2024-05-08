/*class Biome {
  final int biomeid;
  final String biomename;
  final String description;
  final double price;
  final double latitude;
  final double longitude;
  final int rating;
  final String imageurl;
   bool isLiked;

  Biome(this.biomeid,this.biomename,this.description,this.price,this.latitude,
  this.longitude,this.rating, this.imageurl,{this.isLiked = false,});

 factory Biome.fromJson(dynamic json){
          return Biome(
            json['biomeid'],
            json['biomename'],
            json['description'],
            json['price'],
            json['latitude'],
            json['longitude'],
            json['imageurl'],
            json['rating'],
          );
        }
      
}

 List<Biome> biomes= [
   Biome( 1, "Tundra", "landscapes.", 500.0,37.42, 5.0, 5,"b1.jpg"),
   Biome( 2, "Rainforest", "beautiful", 400.0, 34.0, 4.0, 4,"b2.jpg"),
   Biome( 3, "Savanna", "nature",  400, 35.42, 5.0, 5,"b3.jpg"),
   Biome( 4, "minecraft", "mining",300.00, 37.45, 6.6, 5,"b4.jpg"),
   Biome( 5, "Aquatic","worderful", 200.00, 37.46, 6.7,4,"b5.jpg"),
   Biome( 6, "Derserts","", 150.00,30.09, 3.5, 5,"b6.jpg"),
   Biome( 7, "water bodies","",100.00,38.49, 4.0, 5,"b7.jpg"),
                 ];
 
*/

import 'package:hive/hive.dart';
part 'biome.g.dart';

@HiveType(typeId: 1) // TypeId should be unique for each HiveType

class Biome extends HiveObject {
  @HiveField(0)
  final int biomeid;

  @HiveField(1)
  final String biomename;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final double latitude;

  @HiveField(5)
  final double longitude;

  @HiveField(6)
  final int rating;

  @HiveField(7)
  final String imageurl;

  @HiveField(8)
   bool isLiked;
   
  @HiveField(9)
  bool isBookmarked;

  Biome(this.biomeid,this.biomename,this.description,this.price,this.latitude,
  this.longitude,this.rating, this.imageurl,{this.isLiked = false, this.isBookmarked=false});

 factory Biome.fromJson(Map<String, dynamic>json){
  
          return Biome(
            json['biomeid'] as int,
            json['biomename']as String ,
            json['description'] as String ,
            json['price'] as double,
            json['latitude'] as double,
            json['longitude']as double,
            json['rating'] as int,
            json['imageurl'] as String,
            isLiked: json['isLiked'] as bool? ?? false,
            isBookmarked: json['isBookmarked'] as bool? ?? false,
          );
        }
     
      
  Map<String, dynamic> toJson() {
    return {
      'biomeid': biomeid,
      'biomename': biomename,
      'description': description,
      'price': price,
      'rating': rating,
      'imageurl': imageurl,
      'isLiked': isLiked,
      'isBookmarked': isBookmarked,
    };
  }
}

 List<Biome> biomes= [
   Biome( 1, "UTULIVU-GARDEN", "Events ground", 500.0,37.42, 5.0, 5,"utulivu-garden.jpg"),
   Biome( 2, "coffee restaurant", "coffee zone", 400.0, 34.0, 4.0, 4,"coffee.jpg"),
   Biome( 3, "Tundra animals", "landscapes",  400, 35.42, 5.0, 5,"b1.jpg"),
   Biome( 4, "Rainforest ", " nature",300.00, 37.45, 6.6, 5,"b5.jpg"),
   Biome( 5, "Aquatic","worderful", 200.00, 37.46, 6.7,4,"r5.jpg"),
   Biome( 6, "Derserts Animals","find out", 150.00,30.09, 3.5, 5,"b6.jpg"),
   Biome( 7, "waterfalls","cool fresh water",100.00,38.49, 4.0, 5,"hotel.jpg"),
                 ];
 



 