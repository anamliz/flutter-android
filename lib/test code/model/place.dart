/*

class Place {

        final int placeid;
        final String placename;
        final String placedescription;
        final double placeprice;
        final int rating;
        final String placeimageurl;
         bool isLiked;
         bool isBookmarked;
        
       
        

        Place(this.placeid,this.placename,  this.placedescription,  this.placeprice,this.rating,this.placeimageurl, 
        {this.isLiked = false ,this.isBookmarked = false});

 
        factory Place.fromJson(dynamic json){
          return Place(
            json['placeid'],
            json['placename'],
            json['placedescription'],
            json['placeprice'],
            json['rating'], 
            json['placeimageurl']
            
          );
        }


}


                   
   List<Place> places = [
          Place( 1, "USA", "Tundra", 200, 3,"T1.jpg"),
          Place( 2, "Cananda", " Tundra", 1000,2,"T2.jpg"),
          Place( 3, "Diani Beach", "white sand", 1000.00, 5,"r2.jpg"),
          Place( 4, "Mombasa","diving",600, 4, "img7.jpg"),
          Place( 5, "Thika", " chaina waterfall", 200, 3,"img6.jpg"),
          Place( 6, "kisumu", " beach", 1000,2,"r1.jpg"),
          Place( 7, "Nairobi", " gamepark", 100, 3,"img1.jpg"),
          Place( 8, "karura", "waterfall",  500, 4,"img4.jpg"),
          Place( 9, "Nanyuki", "waterfall", 500, 5,"img3.jpg"),
          Place( 10, "Nanyuki", "beach", 500, 5,"r3.jpg"),
          Place( 11, "Nanyuki", "beach", 500, 5,"img5.jpg"),
                 ];

 



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
  Place(1, "USA", "Tundra", 200, 3, "T1.jpg"),
  Place(2, "Cananda", " Tundra", 1000, 2, "T2.jpg"),
  Place(3, "Diani Beach", "white sand", 1000.00, 5, "r2.jpg"),
  Place(4, "Mombasa", "diving", 600, 4, "img7.jpg"),
  Place(5, "Thika", " chaina waterfall", 200, 3, "img6.jpg"),
  Place(6, "kisumu", " beach", 1000, 2, "r1.jpg"),
  Place(7, "Nairobi", " gamepark", 100, 3, "img1.jpg"),
  Place(8, "karura", "waterfall", 500, 4, "img4.jpg"),
  Place(9, "Nanyuki", "waterfall", 500, 5, "img3.jpg"),
  Place(10, "Nanyuki", "beach", 500, 5, "r3.jpg"),

];*/

