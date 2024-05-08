class Park {

        final int gameparkid;
        final String gameparkname;
        final String animalname;
        final String animaldescription;
        final int entryfee;
        final int rating;
        final String animalimageurl;
        bool isLiked;
        

        Park(this.gameparkid,this.gameparkname, this.animalname, this.animaldescription, this.entryfee, 
        this.rating,this.animalimageurl,{this.isLiked = false,});

 
        factory Park.fromJson(dynamic json){
          return Park(
            json['gameparkid'],
            json['gameparkname'],
            json['animalname'],
            json['animaldescription'],
             json['entryfee'],
            json['animalimageurl'],
             json['rating'],
          );
        }

}

   // ignore: non_constant_identifier_names
   List<Park> Parks = [
         Park( 1, "Kora National Park", "elephants, Lesser Kudus, wild dogs, striped and spotted hyenas, leopards, lions and cheetahs. There are about 500 species of insects, 40 reptiles in the park. Visitors can enjoy bird watching, hiking, river rafting, fishing, rock climbing, camping and visits to the George Adamson's grave.","Kora National Park is located in Tana River County,Kenya. The park covers an area of 1,788 square kilometres. It is located 125 kilometres east of Mount Kenya. The park was initially gazetted as a nature reserve in 1973.", 100, 4,"A1.jpg"),
         Park( 2, "Lake Nakuru ","Rhino","", 100,5,"A2.jpg"),
         Park( 3, "Amboseli  Park", " Lion","", 100,5,"A3.jpg"),
         Park( 4, "Aberdare  Park", "Leopard","", 100,5,"A4.jpg"),
         Park( 5, "Masai Mara","buffelo", "", 100,5,"A5.jpg"),
         Park( 6, "Bwindi National Park", "Giraffe","", 100,4,"A6.jpg"),
         Park( 7, "Tsavo National Park", "Zebra","", 100,5,"A7.jpg"),
                 ];

 

