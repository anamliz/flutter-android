
 import 'package:hive/hive.dart';

part 'users.g.dart';

@HiveType(typeId: 11)
class Users  extends HiveObject {
  @HiveField(0)
   final int userid;

  @HiveField(1)
  final String userfirstName;

  @HiveField(2)
  final String userlastName;

  @HiveField(3)
  final String useremail;

  @HiveField(4)
  final String userphoneNumber;

  @HiveField(5)
  final String useruserName;

  @HiveField(6)
  final String userpassword;

  @HiveField(7)
  final String userconfirmpassword;

  @HiveField(8)
  final bool is_logged_in;

  Users (
    this.userid,
    this.userfirstName,
    this.userlastName,
    this.useremail,
    this.userphoneNumber,
    this.useruserName,
    this.userpassword,
    this.userconfirmpassword,
    this.is_logged_in,
  );

  factory Users .fromJson(Map<String, dynamic> json) {
    return Users (
      //json['userid'] as String? ?? '',
       int.tryParse(json['userid']?.toString() ?? '0') ?? 0,
      json['userfirstName'] as String? ?? '',
      json['userlastName'] as String? ?? '',
      json['useremail'] as String? ?? '',
      json['userphoneNumber'] as String? ?? '',
      json['useruserName'] as String? ?? '',
      json['userpassword'] as String? ?? '',
      json['userconfirmpassword'] as String? ?? '',
      json['is_logged_in'] == '1', // Assuming 'is_logged_in' is a string "1" or "0"
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userid': userid,
      'userfirstName': userfirstName,
      'userlastName': userlastName,
      'useremail': useremail,
      'userphoneNumber': userphoneNumber,
      'useruserName': useruserName,
      'userpassword': userpassword,
      'userconfirmpassword': userconfirmpassword,
      'is_logged_in': is_logged_in ? '1' : '0', // Convert bool to string "1" or "0"
    };
  }
  
}

var user = Users(1, "Elizabeth", "Anam", "Ea@gmail.com", "+25476814200", "Liz", "Liz222222", "Liz222222", true); // or false for not logged in

//var user = Users("1","Elizabeth", "Anam", " Ea@gmail.com", "+25476814200","Liz", "Liz222222", "Liz222222", );

/*

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
 */
