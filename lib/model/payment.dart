import 'package:hive/hive.dart';

part 'payment.g.dart';

@HiveType(typeId:5)
class Payment extends HiveObject {

  @HiveField(0)
  final int payments_id;

  @HiveField(1)
  final int booking_id;

  @HiveField(2)
  final String payment_method;

  @HiveField(3)
  final double amount;

  @HiveField(4)
  final DateTime transaction_date;

  @HiveField(5)
  final String status;

          

  Payment(
    this.payments_id,
    this.booking_id,
    this.payment_method,
    this.amount,
    this.transaction_date,
    this.status,
    
  );

  factory  Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      json['payments_id']as int,
      json['Booking_id']as int,
      json['payment_method'] as String,
      json['amount']as double,
      json['transaction_date']as DateTime ,
      json['status']as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payments_id': payments_id,
      'booking_id':booking_id,
      'payment_method': payment_method,
      'amount': amount,
      'transaction_date': transaction_date,
      'status': status,
    };
  }
}
