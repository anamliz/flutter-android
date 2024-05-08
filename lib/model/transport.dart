

class Transport{

        final int id;
        final String Transport_mode;
        final String Mode_type;
        final double Transport_cost;
        final DateTime Departure_date;
        final DateTime Departure_time;
        final String Direction;
        final  Duration duration;
        final int rating;
        final String imageurl;
         bool isLiked;
        

       Transport(this.id,this.Transport_mode,  this.Mode_type,  this.Transport_cost,
       this.Departure_date,this.Departure_time,this.Direction,this.duration,this.rating,this.imageurl, 
        {this.isLiked = false,});

 
        factory Transport.fromJson(dynamic json){
          return Transport(
            json['id'],
            json['Transport_mode'],
            json['Mode_type'],
            json['Transport_cost'],
            json['Departure_date'], 
            json['Departure_time'],
            json['Direction'],
            json['Duration'],
            json['rating'], 
            json['imageurl']
          );
        }
}

            
List<Transport> transportation = [
  Transport(1, "Flight", "JKIA", 2000.00, DateTime(2024, 1, 30), DateTime(0, 0, 0, 6, 0, 30), "Nairobi-kisumu", Duration(hours: 1), 5, "f1.jpg"),
  Transport(2, "Flight", "Jambo jet", 2000.00, DateTime(2024, 1, 30), DateTime(0, 0, 0, 6, 0, 30), "Nairobi-kisumu", Duration(hours: 1), 5, "f2.jpg"),
  Transport(3, "Bus", "Guardian angel", 2000.00, DateTime(2024, 1, 30), DateTime(0, 0, 0, 6, 0, 30), "Nairobi-kisumu", Duration(hours: 1), 5, "Bus1.jpg"),
  Transport(4, "Shuttle", "Guardian", 2000.00, DateTime(2024, 1, 30), DateTime(0, 0, 0, 6, 0, 30), "Nairobi-kisumu", Duration(hours: 1), 5, "bus2.jpg"),
  Transport(5, "Bus", "Easy couch", 2000.00, DateTime(2024, 1, 30), DateTime(0, 0, 0, 6, 0, 30), "Nairobi-kisumu", Duration(hours: 1), 5, "bus3.jpg"),
  Transport(6, "Bus", "Ena couch", 2000.00, DateTime(2024, 1, 30), DateTime(0, 0, 0, 6, 0, 30), "Nairobi-kisumu", Duration(hours: 1), 5, "bus4.jpg"),
  Transport(7, "Shuttle", "Ena couch", 2000.00, DateTime(2024, 1, 30), DateTime(0, 0, 0, 6, 0, 30), "Nairobi-kisumu", Duration(hours: 1), 5, "bus3.jpg"),
  Transport(6, "Train", "JSR", 2000.00, DateTime(2024, 1, 30), DateTime(0, 0, 0, 6, 0, 30), "Nairobi-kisumu", Duration(hours: 1), 5, "f3.jpg"),
  Transport(7, "Train", "Train", 2000.00, DateTime(2024, 1, 30), DateTime(0, 0, 0, 6, 0, 30), "Nairobi-kisumu", Duration(hours: 1), 5, "f4.jpg"),
];


