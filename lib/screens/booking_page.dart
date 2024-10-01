
import 'package:flutter/material.dart';
import 'package:hidden/widgets/common_scaffold.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:convert';
import '../model/booking.dart';
import '../model/users.dart';


final Logger logger = Logger();

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
  late Box<Booking> _bookingsBox;
  List<Map<String, dynamic>> _bookingsList = [];
   
  late Box<Users> _usersBox;
  late Box<String> _tokenBox;
  
  bool _isLoading = true;
 

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      _bookingsBox = await Hive.openBox<Booking>('BookingsBox');
      //_bookingsBox.clear();
            // Access the already initialized Hive boxes

      _usersBox = Hive.box<Users>('UsersBox');
      _tokenBox = Hive.box<String>('TokenBox');
     
      print('Bookings Box Initialized: $_bookingsBox');
      await _fetchBookings();
      setState(() {
        _isLoading = false;
         _usersBox.get('userid');
         _tokenBox.get('jwtToken');
      });

    } catch (e) {
      logger.e('Error initializing data: $e');
    }
  }


  Future<void> _fetchBookings() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost/phalc/booking'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse["status"] == "success") {
          setState(() {
            _bookingsList = (jsonResponse["data"] as List<dynamic>)
                .map((item) => item as Map<String, dynamic>)
                .toList();
          });

          for (var bookingData in _bookingsList) {
            try {
              final booking = Booking.fromJson(bookingData);
              _bookingsBox.put(booking.booking_id, booking);
              logger.i('booking added to _bookingsBox: ${booking.toJson()}');
            } catch (e) {
              logger.e('Error parsing booking data: $e');
              logger.d('Booking data: $bookingData');
            }
          }
          logger.i('bookingsBox now has ${_bookingsBox.length} entries');
        } else {
          throw Exception("Unable to get booking.");
        }
      } else {
        logger.e('Failed to fetch booking: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error fetching booking: $e');
    }
  }

final checkInDateController = TextEditingController();
final checkOutDateController = TextEditingController();

  DateTime? checkInDate;
  DateTime? checkOutDate;
  int numAdults = 2;
  int numChildren = 0;
  int numRooms = 1;
  double totalPrice = 0.0;
  
  
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
      initialDate: isCheckInDate ? checkInDate ?? DateTime.now() : checkOutDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (picked != null) {
      setState(() {
        if (isCheckInDate) {
          checkInDate = picked;
          checkInDateController.text = DateFormat('yyyy-MM-dd').format(checkInDate!);
        } else {
          checkOutDate = picked;
          checkOutDateController.text = DateFormat('yyyy-MM-dd').format(checkOutDate!);
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
                            numAdults -= 1;
                            if (numAdults < 0) numAdults = 0;
                          });
                        },
                      ),
                      Text(numAdults.toString()),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            numAdults += 1;
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
                            numChildren -= 1;
                            if (numChildren < 0) numChildren = 0;
                          });
                        },
                      ),
                      Text(numChildren.toString()),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            numChildren += 1;
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
                            numRooms -= 1;
                            if (numRooms < 1) numRooms = 1;
                          });
                        },
                      ),
                      Text(numRooms.toString()),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            numRooms += 1;
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
    RoomType selectedType = roomTypes.firstWhere((type) => type.name == selectedRoomType);
    double totalPrice = numRooms * selectedType.price;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Total Price'),
          content: Text('Total Price for $numRooms room(s) of ${selectedType.name}: \$${totalPrice.toStringAsFixed(2)}'),
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

Future<void> _submitForm() async {
 if (checkInDate != null && checkOutDate != null) {
    RoomType selectedType =
        roomTypes.firstWhere((type) => type.name == selectedRoomType);
    double totalPrice = numRooms * selectedType.price;

    if (numAdults < 1 || numRooms < 1) {
      print('Number of adults and rooms must be at least 1.');
      return;
    }

    if (selectedRoomType.isEmpty) {
      print('Please select a room type.');
      return;
    }

    if (totalPrice <= 0) {
      print('Total price must be greater than zero.');
      return;
    }
final String checkInDateStr = DateFormat('yyyy-MM-dd').format(checkInDate!);
      final String checkOutDateStr = DateFormat('yyyy-MM-dd').format(checkOutDate!);


    Map<String, dynamic> payload = {
      "checkInDate": checkInDateStr,
      "checkOutDate": checkOutDateStr,
      "numAdults": numAdults,
      "numChildren": numChildren,
      "numRooms": numRooms,
      "roomType": selectedRoomType,
      "totalPrice": totalPrice,
    };

    var _tokenBox = Hive.box<String>('TokenBox');
    String? token = _tokenBox.get('jwtToken');

    print('Token retrieved from Hive: $token');
    print('Payload for booking request: $payload');

    if (token == null) {
      //print('User not authenticated. Token missing.');
      logger.e('User not authenticated. Token missing.');
      throw Exception('User not authenticated. Token missing.');
    }

    try {
      //print('Proceeding with booking request.');
      //print('Payload: $payload');
      //print('Token: $token');

      final response = await booking(payload, token);

      if (response['status'] == 'Success') {
        logger.i(' booking successfully');

        Navigator.push( context,
          MaterialPageRoute(
            builder: (context) => BookingConfirmationScreen(
              checkInDate: checkInDate!,
              checkOutDate: checkOutDate!,
              numAdults: numAdults,
              numChildren: numChildren,
              numRooms: numRooms,
              selectedRoomType: selectedRoomType,
              totalPrice: totalPrice,
            ),
          ),
        );
      } else {
        logger.e('Failed to book room: ${response['message']}');
        _showErrorDialog('Failed to book room: ${response['message']}');
      }
    } catch (e) {
      logger.e('Error booking room: $e');
      _showErrorDialog('Error booking room: $e');
    }
  } else {
    logger.e('Please select both check-in and check-out dates.');
    _showErrorDialog('Please select both check-in and check-out dates.');
  }
}

Future<Map<String, dynamic>> booking(
    Map<String, dynamic> payload, String token) async {
  try {
   // print('Making booking request with payload: $payload');
   // print('Using token: $token');

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    //print('Headers: $headers');

    final response = await http.post(
      Uri.parse('http://127.0.0.1/phalc/booking'),
      body: jsonEncode(payload),
     headers: headers,
        
    );

    //print('Booking Response status code: ${response.statusCode}');
   // print('Booking Response body: ${response.body}');
    
   // print('Header response: ${response.headers}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);

    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized request: ${response.body}');
   
    } else {
      var json = jsonDecode(response.body);
      if (json["message"] != null) {
        throw Exception(json["message"]);
      }
      throw Exception('Failed to Add booking: ${response.statusCode}');
    }
  } catch (e) {
   // print('Error occurred in booking function: $e');
    throw Exception('Error booking room: $e');
  }
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

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      body: Card(
        color: const Color.fromARGB(255, 220, 221, 220),
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
                            checkInDate == null ? 'Select Check-in Date' : DateFormat.yMMMd().format(checkInDate!),
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
                            checkOutDate == null ? 'Select Check-out Date' : DateFormat.yMMMd().format(checkOutDate!),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Room Type',
                        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      DropdownButton<String>(
                        value: selectedRoomType,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedRoomType = newValue!;
                          });
                        },
                        items: roomTypes.map<DropdownMenuItem<String>>((RoomType value) {
                          return DropdownMenuItem<String>(
                            value: value.name,
                            child: Text(value.name),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Guests & Rooms',
                            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _showDropdownMenu(context);
                            },
                            child: const Text('Edit'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _showPrice,
                        child: const Text('Show Total Price'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Book Now'),
              ),
            ),
          ],
        ),
      ), currentIndex: 6, userfirstName: user.userfirstName, places: [],
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
    Key? key,
    required this.checkInDate,
    required this.checkOutDate,
    required this.numAdults,
    required this.numChildren,
    required this.numRooms,
    required this.selectedRoomType,
    required this.totalPrice,
  }) : super(key: key);

  @override
  _BookingConfirmationScreenState createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  String _mpesaPin = '';
  bool _isTransactionConfirmed = false;

  void _confirmTransaction() {
    if (_mpesaPin.isEmpty) {
      _showErrorDialog('Please enter your MPESA PIN.');
      return;
    }

    setState(() {
      _isTransactionConfirmed = true;
      print('Transaction confirmed with PIN: $_mpesaPin');
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Confirm Booking Details',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12.0),
              Text('Check-in Date: ${DateFormat.yMMMd().format(widget.checkInDate)}'),
              Text('Check-out Date: ${DateFormat.yMMMd().format(widget.checkOutDate)}'),
              Text('Adults: ${widget.numAdults}'),
              Text('Children: ${widget.numChildren}'),
              Text('Rooms: ${widget.numRooms}'),
              Text('Selected Room Type: ${widget.selectedRoomType}'),
              Text('Total Price: \$${widget.totalPrice.toStringAsFixed(2)}'),
              const SizedBox(height: 24.0),
              const Text(
                'Confirm MPESA Payment',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12.0),
              Text('Amount to be Paid: \$${widget.totalPrice.toStringAsFixed(2)}'),
              const SizedBox(height: 24.0),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _mpesaPin = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'MPESA PIN',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _confirmTransaction();
                      if (_isTransactionConfirmed) {
                        _processPayment('MPESA', _mpesaPin);
                      }
                    },
                    child: const Text('Confirm'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              if (_isTransactionConfirmed)
                const Text(
                  'Transaction Confirmed!',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ), currentIndex: 0, userfirstName: '', places: [],
    );
  }

  void _processPayment(String paymentMethod, String mpesaPin) {
    if (mpesaPin.isEmpty) {
      _showErrorDialog('Please enter your MPESA PIN.');
      return;
    }

    print('Processing payment...');
    print('Payment Method: $paymentMethod');
    print('MPESA PIN: $mpesaPin');
    
    Future.delayed(const Duration(seconds: 2), () {
      print('Payment successful!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const PaymentSuccessScreen(),
        ),
      );
    });
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
}


class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  CommonScaffold(
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 80.0,
            ),
            SizedBox(height: 16.0),
            Text(
              'Payment Successful!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ), currentIndex: 5, userfirstName: user.userfirstName, places: [],
    );
  }
}