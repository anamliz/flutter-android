class Gem {
  final int id;
  final String name;
  final String description;
  final double price;
  final int rating;
  final String imageurl;
   bool isLiked;

 Gem(this.id,this.name,this.description,this.price,this.rating, this.imageurl,{this.isLiked = false,});

 factory Gem.fromJson(dynamic json){
          return Gem(
            json['id'],
            json['name'],
            json['description'],
            json['price'],
            json['imageurl'],
            json['rating'],
          );
        }
      
}

 List<Gem> gems= [
   Gem( 1, "mountain ", " ", 500.0, 5,"G13.jpg"),
   Gem( 2, "caves", "", 400.0,  4,"G4.jpg"),
   Gem( 3, "waterfalls", "",  400,  5,"G11.jpg"),
   Gem( 4, "waterfall", "",300.00,  5,"G6.jpg"),
   Gem( 5, "waterfall","water bodies", 200.00, 4,"G7.jpg"),
   Gem( 6, "water bodies","", 150.00, 5,"G8.jpg"),
   Gem( 7, "water bodies","",100.00, 5,"G9.jpg"),
   Gem( 8, "water bodies","",100.00, 5,"G10.jpg"),
   Gem( 9, "fruits", "farming", 500.0, 5,"G19.jpg"),
   Gem( 10, "", "", 400.0,  4,"G12.jpg"),
   Gem( 11, "", "",  400,  5,"G13.jpg"),
   Gem( 12, "", "",300.00,  5,"G14.jpg"),
   Gem( 13, "","", 200.00, 4,"G15.jpg"),
   Gem( 14, "","", 150.00, 5,"G16.jpg"),
   Gem( 15, "","",100.00, 5,"G3.jpg"),
   Gem( 16, "","",100.00, 5,"G1.jpg"),
   Gem( 17, "","", 200.00, 4,"G5.jpg"),
   Gem( 18, "","", 150.00, 5,"G18.jpg"),
   Gem( 19, "","",100.00, 5,"G2.jpg"),
   Gem( 20, "","",100.00, 5,"G17.jpg"),
                 ];
 
