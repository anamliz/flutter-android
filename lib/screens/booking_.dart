import 'package:flutter/material.dart';
import 'package:hidden/widgets/common_scaffold.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';


class RoomBookingPage extends StatefulWidget {
  const RoomBookingPage({super.key});

  @override
  State<RoomBookingPage> createState() => _RoomBookingPageState();
}

class _RoomBookingPageState extends State<RoomBookingPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Room Booking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BookingPage(),
    );
  }
}

class RoomType {
  final String name;
  final double price;
  final String description;

  RoomType(this.name, this.price, this.description);
}

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _numAdults = 2;
  int _numChildren = 0;
  int numberOfRooms = 1;
  String selectedRoomType = 'Superior Double Room';
  double baseRoomPrice = 1000.0;
  List<RoomType> roomTypes = [
    RoomType('Superior Double Room', 1000.0, 'Luxurious room with an extra-large double bed.'),
    RoomType('Deluxe Room', 1200.0, 'Spacious room with a scenic view.'),
    RoomType('Executive Suite', 1500.0, 'Exclusive suite with premium amenities.'),
    RoomType('Three-Bedroom Villa', 2000.0, 'Private villa with multiple bedrooms and living space.'),
  ];

  Future<void> _selectDate(BuildContext context, bool isCheckInDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckInDate ? _checkInDate ?? DateTime.now() : _checkOutDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (picked != null) {
      setState(() {
        if (isCheckInDate) {
          _checkInDate = picked;
        } else {
          _checkOutDate = picked;
        }
      });
    }
  }

  void _showDropdownMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Guests and Rooms'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text('Adults'),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            _numAdults -= 1;
                            if (_numAdults < 0) _numAdults = 0;
                          });
                        },
                      ),
                      Text(_numAdults.toString()),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _numAdults += 1;
                          });
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Children'),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            _numChildren -= 1;
                            if (_numChildren < 0) _numChildren = 0;
                          });
                        },
                      ),
                      Text(_numChildren.toString()),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _numChildren += 1;
                          });
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Rooms'),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            numberOfRooms -= 1; // Update numberOfRooms here
                            if (numberOfRooms < 1) numberOfRooms = 1;
                          });
                        },
                      ),
                      Text(numberOfRooms.toString()),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            numberOfRooms += 1;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Done'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPrice() {
    // Find the selected roomtype
    RoomType selectedType = roomTypes.firstWhere((type) => type.name == selectedRoomType);
    // Calculate total price for the selected room type and number of rooms
    double totalPrice = numberOfRooms * selectedType.price;

    // Display total price for the selected room type
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Total Price'),
          content: Text('Total Price for $numberOfRooms room(s) of ${selectedType.name}: \$${totalPrice.toStringAsFixed(2)}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _proceedToUserDetails() async {
    if (_checkInDate != null && _checkOutDate != null) {
      RoomType selectedType = roomTypes.firstWhere((type) => type.name == selectedRoomType);
      double totalPrice = numberOfRooms * selectedType.price;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingConfirmationScreen(
            checkInDate: _checkInDate!,
            checkOutDate: _checkOutDate!,
            numAdults: _numAdults,
            numChildren: _numChildren,
            numRooms: numberOfRooms,
            selectedRoomType: selectedRoomType,
            totalPrice: totalPrice,
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please select both check-in and check-out dates.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      body: Card(
        color: Color.fromARGB(255, 220, 221, 220),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Check-in Date',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      InkWell(
                        onTap: () {
                          _selectDate(context, true);
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Select Check-in Date',
                          ),
                          child: Text(
                            _checkInDate == null ? 'Select Check-in Date' : DateFormat.yMMMd().format(_checkInDate!),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Check-out Date',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      InkWell(
                        onTap: () {
                          _selectDate(context, false);
                        },
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Select Check-out Date',
                          ),
                          child: Text(
                            _checkOutDate == null ? 'Select Check-out Date' : DateFormat.yMMMd().format(_checkOutDate!),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          _showDropdownMenu(context);
                        },
                        child: const Text('Select Guests and Rooms'),
                      ),
                      const SizedBox(height: 16.0),
                      DropdownButtonFormField<String>(
                        value: selectedRoomType,
                        items: roomTypes.map((roomType) {
                          return DropdownMenuItem<String>(
                            value: roomType.name,
                            child: Text(roomType.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedRoomType = value!;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Select Room Type',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _showPrice,
                        child: const Text('Show Price'),
                      ),
                      const SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _proceedToUserDetails,
                child: const Text('Proceed to Booking'),
              ),
            ),
          ],
        ),
      ), currentIndex: 6, userfirstName: '', places: [],
    );
  }
}

class BookingConfirmationScreen extends StatefulWidget {
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int numAdults;
  final int numChildren;
  final int numRooms;
  final String selectedRoomType;
  final double totalPrice;

  const BookingConfirmationScreen({
    super.key,
    required this.checkInDate,
    required this.checkOutDate,
    required this.numAdults,
    required this.numChildren,
    required this.numRooms,
    required this.selectedRoomType,
    required this.totalPrice,
  });

  @override
  _BookingConfirmationScreenState createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  String selectedPaymentMethod = 'Mpesa';
  bool _isBookingConfirmed = false; // Add this line to track booking confirmation
  Logger logger = Logger();

  Future<void> _submitBooking() async {
    
    final bookingData = {
      'checkInDate': widget.checkInDate.toIso8601String(),
      'checkOutDate': widget.checkOutDate.toIso8601String(),
      'numAdults': widget.numAdults,
      'numChildren': widget.numChildren,
      'numRooms': widget.numRooms,
      'selectedRoomType': widget.selectedRoomType,
      'totalPrice': widget.totalPrice,
      'paymentMethod': selectedPaymentMethod,
    };

    try {
      logger.d('Sending booking request to  with data: $bookingData');
      
      final response = await http.post(
       Uri.parse('http://127.0.0.1/phalc/booking'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bookingData),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isBookingConfirmed = true; // Mark booking as confirmed
        });
        _showSuccessDialog();
      } else {
        logger.e('Failed to submit booking: ${response.body}');
        throw Exception('Failed to submit booking: ${response.body}');
      }
    } catch (e) {
      logger.e('Error submitting booking: $e');
      _showErrorDialog('Failed to submit booking. Please try again.');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Booking Confirmed'),
          content: const Text('Your booking has been successfully submitted.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Close the confirmation screen
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _confirmBooking() {
    if (selectedPaymentMethod != 'Mpesa' && selectedPaymentMethod != 'Card') {
      _showErrorDialog('Invalid payment method selected. Please choose a valid payment method.');
      return;
    }

    // Show a confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Booking'),
          content: const Text('Are you sure you want to confirm the booking?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _submitBooking(); // Call the booking submission method
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      body: Card(
        color: Color.fromARGB(255, 220, 221, 220),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Confirm Booking',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              Text('Check-in Date: ${DateFormat.yMMMd().format(widget.checkInDate)}'),
              const SizedBox(height: 8.0),
              Text('Check-out Date: ${DateFormat.yMMMd().format(widget.checkOutDate)}'),
              const SizedBox(height: 8.0),
              Text('Number of Adults: ${widget.numAdults}'),
              const SizedBox(height: 8.0),
              Text('Number of Children: ${widget.numChildren}'),
              const SizedBox(height: 8.0),
              Text('Number of Rooms: ${widget.numRooms}'),
              const SizedBox(height: 8.0),
              Text('Room Type: ${widget.selectedRoomType}'),
              const SizedBox(height: 8.0),
              Text('Total Price: \$${widget.totalPrice.toStringAsFixed(2)}'),
              const SizedBox(height: 16.0),
              const Text(
                'Payment Method',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              DropdownButtonFormField<String>(
                value: selectedPaymentMethod,
                items: ['Mpesa', 'Card'].map((method) {
                  return DropdownMenuItem<String>(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPaymentMethod = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Select Payment Method',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: _isBookingConfirmed ? null : _confirmBooking,
                  child: const Text('Book Room'),
                ),
              ),
            ],
          ),
        ),
      ), currentIndex: 6, userfirstName: '', places: [],
    );
  }
}


void main() {
  runApp(const MaterialApp(
    title: 'Hotel Booking App',
    home: RoomBookingPage(),
  ));
}
