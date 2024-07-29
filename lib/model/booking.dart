import 'package:hive/hive.dart';

part 'booking.g.dart';

@HiveType(typeId:4 )
class Booking extends HiveObject {

  @HiveField(0)
  final int booking_id;

  @HiveField(1)
  final int userid;

  @HiveField(2)
  final DateTime checkInDate;

  @HiveField(3)
  final DateTime checkOutDate;

  @HiveField(4)
  final int numAdults;

  @HiveField(5)
  final int numChildren;

  @HiveField(6)
  final int numRooms;

  @HiveField(7)
  final String roomType;

  @HiveField(8)
  final double totalPrice;

  @HiveField(9)
  final DateTime bookingDate;

  @HiveField(10)
  final String status;

          

  Booking(
    this.booking_id,
    this.userid,
    this.checkInDate,
    this.checkOutDate,
    this.numAdults,
    this.numChildren,
    this.numRooms,
    this.roomType,
    this.totalPrice,
    this.bookingDate,
    this.status,
  );

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      
      json['booking_id']as int? ?? 0,
      json['userid'] as int? ?? 0,
      DateTime.parse(json['checkInDate'] ?? '1970-01-01'),
      DateTime.parse(json['checkOutDate'] ?? '1970-01-01'),
      json['numAdults'] as int? ?? 0,
      json['numChildren']as int? ?? 0,
      json['numRooms']as int? ?? 0,
      json['roomType'] as String? ?? '',
      double.parse(json['totalPrice'].toString()),
      DateTime.parse(json['bookingDate'] ?? '1970-01-01T00:00:00Z'),
      json['status'] ?? 'pending',
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking_id':booking_id,
      'userid': userid,
      'checkInDate': checkInDate.toIso8601String(),
      'checkOutDate': checkOutDate.toIso8601String(),
      'numAdults': numAdults,
      'numChildren': numChildren,
      'numRooms': numRooms,
      'roomType': roomType,
      'totalPrice': totalPrice,
      'bookingDate': bookingDate.toIso8601String(),
      'status': status,
    };
  }
}
