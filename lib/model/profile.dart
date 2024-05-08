class Profile{
  final int id;
  final String username;
  final String bio;
  final int followersCount;
  final int followingCount;
  final String posts;

  Profile(

     this.id,
     this.username,
     this.bio,
    this.followersCount,
    this.followingCount,
     this.posts); 

 factory Profile.fromJson(dynamic json){
          return Profile(
            json['id'],
            json['username'],
            json['bio'],
            json['followersCount'],
            json['followingCount'],
            json['posts'],
            
            
          );
        }
      
}

 List<Profile> profile= [
   Profile( 1, "Liz","i love coding", 5, 8, "p1.jpg"),
   //Profile( 2, "Rainforest", "beautiful", 400.0, 34.0, 4.0, 4,"b2.jpg"),
   //Profile( 3, "Savanna", "nature",  400, 35.42, 5.0, 5,"b3.jpg"),
   //Profile( 4, "minecraft", "mining",300.00, 37.45, 6.6, 5,"b4.jpg"),
   //Profile( 5, "Aquatic","worderful", 200.00, 37.46, 6.7,4,"b5.jpg"),
   //Profile( 6, "Derserts","", 150.00,30.09, 3.5, 5,"b6.jpg"),
   //Profile( 7, "water bodies","",100.00,38.49, 4.0, 5,"b7.jpg"),
                 ];