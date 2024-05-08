class Users {

        final String userfirstName;
        final String userlastName;
        final String useremail;
        final String userphoneNumber;
        final String useruserName;
        final String userpassword;
        final String userconfirmPassword;

        Users(this.userfirstName,this.userlastName, this.useremail, this.userphoneNumber, this.useruserName, 
        this.userpassword, this.userconfirmPassword,);

        factory Users.fromJson(dynamic json){
          return Users(
            json['userfirstName'],
          json['userlastName'],
            json['useremail'],
          json['userphoneNumber'],
            json['useruserName'],
            json['userpassword'],
          json['userconfirmPassword'],
          );
        }

}


var user = Users("Elizabeth", "Anam", " Ea@gmail.com", "+25476814200","Liz", "Liz222222", "Liz222222");



List<Users> users = [
  Users("Reindeer", "Animals", "reindeer@example.com", "1234567890", "reindeer123", "password123", "password123"),
  Users("Moose", "Animals", "moose@example.com", "9876543210", "moose456", "password456", "password456"),
  Users("Wild yak", "Animals", "wildyak@example.com", "1112223333", "wildyak789", "password789", "password789"),
  Users("Penguin", "Animals", "penguin@example.com", "4445556666", "penguin000", "password000", "password000"),
  Users("Elk", "Animals", "elk@example.com", "7778889999", "elk123", "password123", "password123"),
  Users("Baiko seal", "Animals", "baikoseal@example.com", "9998887777", "baikoseal456", "password456", "password456"),
  Users("Rabbit", "Animals", "rabbit@example.com", "6665554444", "rabbit789", "password789", "password789"),
  Users("Harbor seal", "Animals", "harborseal@example.com", "3332221111", "harborseal000", "password000", "password000"),
];
 
