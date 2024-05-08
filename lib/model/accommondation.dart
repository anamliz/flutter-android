
import 'package:hive/hive.dart';
part 'accommondation.g.dart';


@HiveType(typeId: 6)
class Hotel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final String imageurl;

  @HiveField(5)
  bool isLiked;

  @HiveField(6)
  bool isBookmarked;

 @HiveField(7)
  int rating;

  @HiveField(8)
  List<String> comments; 


  Hotel(
    this.id,
    this.name,
    this.description,
    this.price,
    this.imageurl, {
    this.isLiked = false,
    this.isBookmarked = false,
     this.rating = 0,
    this.comments = const [],
    
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      json['id'],
      json['name'],
      json['description'],
      json['price'],
      json['imageurl'],
      isLiked: json['isLiked'] ?? false,
      isBookmarked: json['isBookmarked'] ?? false,
      rating: json['rating'] ?? 0,
      comments: json['comments'] ?? [],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageurl': imageurl,
      'isLiked': isLiked,
      'isBookmarked': isBookmarked,
      'rating': rating,
      'comments': comments,

    };
  }
}

List<Hotel> hotels = [
  Hotel(1, "Nairobi Serena",  "Luxurious hotel in Nairobi Kenya", 200, "H1.jpg"),
  Hotel(2, "Sarova Stanley",  "Iconic hotel in the heart of Nairobi kenya", 1000,  "H2.jpg"),
  Hotel(3, "Villa Rosa Kempinski", "Elegant hotel with modern amenities in Kenya", 1000.00, "H3.jpg"),
  Hotel(4, "SAROVA MARA",  "Safari experience in the wilderness,Masai mara National Reserve", 600,  "H4.jpg"),
  Hotel(5, "Fairmont",  "Luxury and comfort in Nairobi Kenya", 200,  "H5.jpg"),
  Hotel(6, "Sankara hotel", "Contemporary luxury in Nairobi kenya", 1000,  "H6.jpg"),
  Hotel(7, "Crown Plaza",  "Convenient stay in Nairobi", 100,  "H7.jpg"),
  Hotel(8, "Windsor Golf",  "Golf resort in Nairobi", 500, "H8.jpg"),
  Hotel(9, "Tribe Hotel",  "Unique cultural experience", 500,  "H9.jpg"),
  Hotel(10, "Safari Park",  "Wildlife and nature retreat", 500,  "H10.jpg"),
  Hotel(11, "InterContinental",  "International luxury in Nairobi", 500,  "H11.jpg"),
];
