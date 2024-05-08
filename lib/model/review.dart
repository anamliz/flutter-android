
import 'package:hive/hive.dart';
part 'review.g.dart';

@HiveType(typeId:5)
class Review extends HiveObject{

   @HiveField(0)
  final int reviewid;

   @HiveField(1)
  final String useruserName;

   @HiveField(2)
  final String comment;

   @HiveField(3)
  final int rating;

   @HiveField(4)
  final  String profileImage;
  
  
  

  Review(this.reviewid,this.useruserName,this.comment,this.rating,this.profileImage,);

 factory Review.fromJson(dynamic json){
          return Review(
            json['reviewid'] as int,
            json['useruserName']as String,
            json['comment']as String,
            json['rating'] as int,
            json['profileImage'] as String,
            
          );
        }
      Map<String, dynamic> toJson() {
    return {
      'reviewid':reviewid,
      'useruserName':useruserName,
      'comment':comment,
      'rating':rating,
      'profileImage':profileImage,
    };
      }
}

 List<Review> reviews= [
   Review( 1, "janet", "Great, i will definatly visit this place", 5,  "A1.jpg"),
   Review( 2, "Job", "must visit",4, "A5.jpg"),
   Review( 3, "Saraah","nature", 5,"A5.jpg"),
   Review( 4, "joel", "mining", 5,"A5.jpg"),
   Review( 5, "JOVIN","worderful", 4,"A5.jpg"),
   Review( 6, "Gold","", 5,"A5.jpg"),
   Review( 7, "Soniah","", 5,"A5.jpg"),
                 ];
 
