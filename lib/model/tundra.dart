
import 'package:hive/hive.dart';
part 'tundra.g.dart';

@HiveType(typeId: 2) // TypeId should be unique for each HiveType
class Tundra extends HiveObject {

  @HiveField(0)
  final int tundraid;

  @HiveField(1)
  final String tundraname;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final int rating;

  @HiveField(5)
  final String imageurl;

  @HiveField(6)
   bool isLiked;

   @HiveField(7)
  bool isBookmarked;

 Tundra(this.tundraid,this.tundraname,this.description,this.price,this.rating,
  this.imageurl,{this.isLiked = false, this.isBookmarked=false});


 factory Tundra.fromJson(Map<String, dynamic>  json){
          return Tundra(
            json['tundraid'] as int,
            json['tundraname'] as String,
            json['description'] as String,
            json['price'] as double,
            json['rating'] as int,
            json['imageurl'] as String,
            
          );
        }
      Map<String, dynamic> toJson() {
    return {
      'tundraid': tundraid,
      'tundraname': tundraname,
      'description': description,
      'price': price,
      'rating': rating,
      'imageurl': imageurl,
      'isLiked': isLiked,
      'isBookmarked': isBookmarked,
    };
  }
}

 List<Tundra> tundras= [
   Tundra( 1, "Reindeer", "Animals", 500.0, 5,"T3.jpg"),
   Tundra( 2, "moose", "Animals", 400.0,  4,"T4.jpg"),
   Tundra( 3, "wild yak", "Animals",  400,  5,"T5.jpg"),
   Tundra( 4, "Penguin", "Animals",300.00,  5,"T6.jpg"),
   Tundra( 5, "Elk","Animals", 200.00, 4,"T7.jpg"),
   Tundra( 6, "Baiko seal","Animals", 150.00, 5,"T8.jpg"),
   Tundra( 7, "Rabit","Animals",100.00, 5,"T9.jpg"),
   Tundra( 8, "Harbor seal","Animals",100.00, 5,"T10.jpg"),
                 ];
 
