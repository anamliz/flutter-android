class Booking {
  final int userId;
  final String bookingType;
  final int locationId;
  final int eventId;
  final int accommodationId;
  final int transportId;
  final double pricePerPerson;
  final int numPeople;
  final double totalPrice;
  final String paymentMethods;
  final String paymentStatus;

  Booking({
    required this.userId,
    required this.bookingType,
    required this.locationId,
    required this.eventId,
    required this.accommodationId,
    required this.transportId,
    required this.pricePerPerson,
    required this.numPeople,
    required this.totalPrice,
    required this.paymentMethods,
    required this.paymentStatus,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      userId: json['User_id'],
      bookingType: json['Booking_type'],
      locationId: json['Location_id'],
      eventId: json['Event_id'],
      accommodationId: json['Accommodation_id'],
      transportId: json['Transport_id'],
      pricePerPerson: json['Price_perperson'].toDouble(),
      numPeople: json['Num_people'],
      totalPrice: json['Total_price'].toDouble(),
      paymentMethods: json['P_methods'],
      paymentStatus: json['P_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'User_id': userId,
      'Booking_type': bookingType,
      'Location_id': locationId,
      'Event_id': eventId,
      'Accommodation_id': accommodationId,
      'Transport_id': transportId,
      'Price_perperson': pricePerPerson,
      'Num_people': numPeople,
      'Total_price': totalPrice,
      'P_methods': paymentMethods,
      'P_status': paymentStatus,
    };
  }
}
