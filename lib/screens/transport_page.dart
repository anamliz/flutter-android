import 'package:flutter/material.dart';
import '../model/flight.dart';
import '../model/taxi.dart';
import '../model/users.dart';
import '../widgets/common_scaffold.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class TransportPage extends StatefulWidget {
  const TransportPage({super.key});

  bool get isLiked => false;

  @override
  State<TransportPage> createState() => _TransportPageState();
}

class _TransportPageState extends State<TransportPage> {
  
  late Box<Flight> _flightsBox;
  late Box<Taxi> _taxisBox;
  List<Map<String, dynamic>> _flightsList = [];
  List<Map<String, dynamic>> _taxisList = [];

  final logger = Logger();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      _flightsBox = await Hive.openBox<Flight>('FlightsBox');
      //_flightsBox.clear();
      // Add a print statement to log the contents of _placesBox
      print('Flights Box Initialized: $_flightsBox');

       _taxisBox = await Hive.openBox<Taxi>('TaxisBox');
      //_flightsBox.clear();
      print('Taxis Box Initialized: $_taxisBox');

        await _fetchFlights();
        await _fetchTaxis();
        
      setState(() {
        _isLoading = false;
      });

    } catch (e) {
      logger.e('Error initializing data: $e');
    }
  }

//fetch flights
  Future<void> _fetchFlights() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost/phalc/flight'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse["status"] == "success") {
          setState(() {
            _flightsList = (jsonResponse["data"] as List<dynamic>)
                .map((item) => item as Map<String, dynamic>)
                .toList();
          });

          // Store the fetched data in Hive
          for (var flightData in _flightsList) {
            try {
              final flight = Flight.fromJson(flightData);
              _flightsBox.put(flight.flights_id, flight);
            } catch (e) {
              logger.e('Error parsing flight data: $e');
              logger.d('Flight data: $flightData');
            }
          }
        } else {
          throw Exception("Unable to get flight.");
        }
      } else {
        logger.e('Failed to fetch flights: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error fetching flights: $e');
    }
  }

// fetch taxi
  Future<void> _fetchTaxis() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost/phalc/taxi'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse["status"] == "success") {
          setState(() {
            _taxisList = (jsonResponse["data"] as List<dynamic>)
                .map((item) => item as Map<String, dynamic>)
                .toList();
          });

          // Store the fetched data in Hive
          for (var taxiData in _taxisList) {
            try {
              final taxi = Taxi.fromJson(taxiData);
              _taxisBox.put(taxi.id, taxi);
            } catch (e) {
              logger.e('Error parsing taxi data: $e');
              logger.d('Taxi data: $taxiData');
            }
          }
        } else {
          throw Exception("Unable to get taxi.");
        }
      } else {
        logger.e('Failed to fetch taxis: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error fetching taxis: $e');
    }
  }

  void updateLikedStatus(int index) {
    final flight = _flightsBox.getAt(index);
    if (flight != null) {
      setState(() {
        flight.isLiked = !flight.isLiked;
        _flightsBox.putAt(index, flight);
      });
    }
    final taxi = _taxisBox.getAt(index);
    if (taxi != null) {
      setState(() {
        taxi.isLiked = !taxi.isLiked;
        _taxisBox.putAt(index, taxi);
      });
    }
  }

  void updateFlightRating(Flight flight,Taxi taxi, int newRating) {
    if (newRating >= 1 && newRating <= 5) {
      setState(() {
        flight.rating = newRating;
        _flightsBox.put(flight.id, flight);
      });
    } else {
      logger.w('Invalid rating. Rating should be between 1 and 5.');
    }

    if (newRating >= 1 && newRating <= 5) {
      setState(() {
        taxi.rating = newRating;
        _taxisBox.put(taxi.id, taxi);
      });
    } else {
      logger.w('Invalid rating. Rating should be between 1 and 5.');
    }
  }

  void updateBookmarkedStatus(int index) {
    final flight = _flightsBox.getAt(index);
    if (flight != null) {
      setState(() {
        flight.isBookmarked = !flight.isBookmarked;
        _flightsBox.putAt(index, flight);
      });
    } else {
      logger.e('Error: Flight is null at index $index');
    }

    final taxi = _taxisBox.getAt(index);
    if (taxi != null) {
      setState(() {
        taxi.isBookmarked = !taxi.isBookmarked;
        _taxisBox.putAt(index, taxi);
      });
    } else {
      logger.e('Error: taxi is null at index $index');
    }
  }

// ignore: non_constant_identifier_names
final _flight_dateController = TextEditingController();
  // ignore: non_constant_identifier_names
  final _departure_timeController = TextEditingController();
  // ignore: non_constant_identifier_names
  final _number_of_ticketsController = TextEditingController();
	

  String? _selectedFrom;
  String? _selectedTo;
  // ignore: non_constant_identifier_names
  String? _selectedflight_type;
  final bool _isSearching = false;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Dummy data for dropdown menus
  final Map<String, String> _citiesToCountry = {
    'Kenya, Nairobi': 'Kenya',
    'Kenya, Mombasa': 'Kenya',
    'Kenya, Kisumu': 'Kenya',
    'Uganda, Kampala': 'Uganda',
    'Uganda, Entebbe': 'Uganda',
    'Uganda, Jinja': 'Uganda',
    'Tanzania, Dar es Salaam': 'Tanzania',
    'Tanzania, Arusha': 'Tanzania',
    'Tanzania, Dodoma': 'Tanzania',
  };

  // ignore: non_constant_identifier_names
  final List<String> _flight_types = ['Economy', 'Business', 'First Class'];

  Future<void> _searchFlights() async {
    //setState(() {
     // _isSearching = true;
    //});


    final String fromLocation = _selectedFrom ?? '';
    final String toLocation = _selectedTo ?? '';
    final String flightDate = _flight_dateController.text;
    final String departureTime = _departure_timeController.text;
    final String flightType = _selectedflight_type ?? '';
     final String numberOfTickets = _number_of_ticketsController.text;
    
    if (fromLocation.isEmpty ||
        toLocation.isEmpty ||
        flightDate.isEmpty ||
        departureTime.isEmpty ||
        flightType.isEmpty ||
        numberOfTickets.isEmpty) {
      _showErrorDialog('All fields are required');
      return;
    }

          Map<String, dynamic> payload = {
          'from_location': fromLocation,
          'to_location': toLocation,
          'flight_date': flightDate,
          'departure_time': departureTime,
          'flight_type': flightType,
          'number_of_tickets': numberOfTickets,
          };
      
      try {
      final response = await flight(payload);

      if (response['status'] == 'Success') {
        logger.i('booking added successfully');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('booking added successfully')),
        );


      } else {
        logger.e('Failed to add booking: ${response['message']}');
        _showErrorDialog('Failed to add booking: ${response['message']}');
      }
    } catch (e) {
      logger.e('Error occurred: $e');
      _showErrorDialog('An error occurred while adding booking: $e');
    }
  }
Future<Map<String, dynamic>> flight(Map<String, dynamic> payload) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1/phalc/searchflight'),
    body: jsonEncode(payload),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
      return jsonDecode(response.body);
  } else {
    var json = jsonDecode(response.body);
    if (json["message"] != null) {
      throw Exception(json["message"]);
    }
    throw Exception('Failed to add booking: ${response.statusCode}');
  }
}

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _flight_dateController.text = "${picked.toLocal()}".split(' ')[0]; // Format date
      });
    }
  }	

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _departure_timeController.text = picked.format(context);
      });
    }
  }


// ignore: non_constant_identifier_names
final _departure_dateController = TextEditingController();
 
  String? _selectedvehicle_type;
  
 final List<String> _vehicle_types = ['Taxi', 'Buses'];
  Future<void> _searchvehicle() async {
    

    final String fromLocation = _selectedFrom ?? '';
    final String toLocation = _selectedTo ?? '';
    final String departureDate = _departure_dateController.text;
    final String departureTime = _departure_timeController.text;
    final String vehicleType = _selectedvehicle_type ?? '';
     final String numberOfTickets = _number_of_ticketsController.text;
    
    if (fromLocation.isEmpty ||
        toLocation.isEmpty ||
        departureDate.isEmpty ||
        departureTime.isEmpty ||
        vehicleType.isEmpty ||
        numberOfTickets.isEmpty) {
      _showErrorDialog('All fields are required');
      return;
    }

          Map<String, dynamic> payload = {
          'from_location': fromLocation,
          'to_location': toLocation,
          'departure_date': departureDate,
          'departure_time': departureTime,
          'vehicle_type': vehicleType,
          'number_of_tickets': numberOfTickets,
          };
      
      try {
      final response = await vehicle(payload);

      if (response['status'] == 'Success') {
        logger.i('booking added successfully');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('booking added successfully')),
        );


      } else {
        logger.e('Failed to add booking: ${response['message']}');
        _showErrorDialog('Failed to add booking: ${response['message']}');
      }
    } catch (e) {
      logger.e('Error occurred: $e');
      _showErrorDialog('An error occurred while adding booking: $e');
    }
  }
Future<Map<String, dynamic>> vehicle(Map<String, dynamic> payload) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1/phalc/vehicle'),
    body: jsonEncode(payload),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
      return jsonDecode(response.body);
  } else {
    var json = jsonDecode(response.body);
    if (json["message"] != null) {
      throw Exception(json["message"]);
    }
    throw Exception('Failed to add booking: ${response.statusCode}');
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
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!_isSearching) ...[
                      const Text(
                            'Book flights',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 10),

              // From Location Dropdown
              _buildDropdown('From', _selectedFrom, (value) {
                setState(() {
                  _selectedFrom = value;
                });
              }),
              const SizedBox(height: 10),

              // To Location Dropdown
              _buildDropdown('To', _selectedTo, (value) {
                setState(() {
                  _selectedTo = value;
                });
              }),
              const SizedBox(height: 10),

              // Date Picker
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: _flight_dateController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Departure Time Picker
              GestureDetector(
                onTap: () => _selectTime(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: _departure_timeController,
                    decoration: InputDecoration(
                      labelText: 'Departure Time',
                      prefixIcon: const Icon(Icons.access_time),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Number of Tickets
              TextField(
                controller: _number_of_ticketsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Number of Tickets',
                  prefixIcon: const Icon(Icons.confirmation_number),
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
              ),
              const SizedBox(height: 10),


              // Flight Type Dropdown
              DropdownButtonFormField<String>(
                value: _selectedflight_type,
                hint: const Text('Select Flight Type'),
                items: _flight_types.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedflight_type = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'flight Type',
                  prefixIcon: const Icon(Icons.flight),
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: _searchFlights,
                icon: const Icon(Icons.search),
                label: const Text('Search Flights'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                _fetchFlights();
              },
              child: Text('Search'),
            ),

                    Container(
                      height: 455,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: _flightsBox.length,
                        itemBuilder: (context, index) {
                          final flight = _flightsBox.getAt(index);

                          if (flight == null) {
                            return const SizedBox();
                          }
                          final String photoUri = flight.photoUri;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.network(
                                          photoUri,
                                          width: 350,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: -10.0,
                                        right: -10.0,
                                        child: IconButton(
                                          icon: Icon(
                                            flight.isLiked ? Icons.favorite : Icons.favorite_border,
                                            color: flight.isLiked ? Colors.red : const Color.fromARGB(255, 250, 226, 7),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              flight.isLiked = !flight.isLiked;
                                              _flightsBox.putAt(index, flight);
                                            });
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        bottom: -10.0,
                                        left: -10.0,
                                        child: IconButton(
                                          icon: Icon(
                                            flight.isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                                            color: flight.isBookmarked ? Colors.orange : Colors.yellow,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              flight.isBookmarked = !flight.isBookmarked;
                                              _flightsBox.putAt(index, flight);
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'flights_id: ${flight.flights_id}',
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 1.0),
                                        Text(
                                          'id: ${flight.id}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16.0),
                                        ),
                                        const SizedBox(height: 1.0),
                                        Text(
                                          'type: ${flight.type}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16.0),
                                        ),
                                        const SizedBox(height: 1.0),
                                        Text(
                                          'name: ${flight.name}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16.0),
                                        ),
                                        const SizedBox(height: 1.0),
                                        Text(
                                          'code:${flight.code}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16.0),
                                        ),
                                        const SizedBox(height: 1.0),
                                        Text(
                                          'city:${flight.city}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16.0),
                                        ),
                                        const SizedBox(height: 1.0),
                                        Text(
                                          'country:${flight.country}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16.0),
                                        ),
                                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (starIndex) {
                        return IconButton(
                          icon: Icon(
                            starIndex < (flight.rating) ? Icons.star : Icons.star_border,
                            color: starIndex < (flight.rating) ? Colors.yellow : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                             flight.rating = starIndex + 1;
                              _flightsBox.putAt(index, flight);
                            });
                          },
                        );
                      }),
                                    ),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10.0),
                   
                          const Text(
                            'Book Taxi and buses',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 10),
// From Location Dropdown
              _buildDropdown('From', _selectedFrom, (value) {
                setState(() {
                  _selectedFrom = value;
                });
              }),
              const SizedBox(height: 10),

              // To Location Dropdown
              _buildDropdown('To', _selectedTo, (value) {
                setState(() {
                  _selectedTo = value;
                });
              }),
              const SizedBox(height: 10),

              // Date Picker
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: _departure_dateController,
                    decoration: InputDecoration(
                      labelText: 'Date',
                      prefixIcon: const Icon(Icons.calendar_today),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Departure Time Picker
              GestureDetector(
                onTap: () => _selectTime(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: _departure_timeController,
                    decoration: InputDecoration(
                      labelText: 'Departure Time',
                      prefixIcon: const Icon(Icons.access_time),
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Number of Tickets
              TextField(
                controller: _number_of_ticketsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Number of Tickets',
                  prefixIcon: const Icon(Icons.confirmation_number),
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
              ),
              const SizedBox(height: 10),


              // Flight Type Dropdown
              DropdownButtonFormField<String>(
                value: _selectedvehicle_type,
                hint: const Text('Select vehicle Type'),
                items: _vehicle_types.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedvehicle_type = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'vehicle Type',
                  prefixIcon: const Icon(Icons.flight),
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton.icon(
                onPressed: _searchFlights,
                icon: const Icon(Icons.search),
                label: const Text('Search vehicle'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            

                     Container(
                      height: 500,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: _taxisBox.length,
                        itemBuilder: (context, index) {
                          final taxi = _taxisBox.getAt(index);

                          if (taxi == null) {
                            return const SizedBox();
                          }
                          final String imageUrl = taxi.image_url;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.network(
                                          imageUrl,
                                          width: 350,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: -10.0,
                                        right: -10.0,
                                        child: IconButton(
                                          icon: Icon(
                                            taxi.isLiked ? Icons.favorite : Icons.favorite_border,
                                            color: taxi.isLiked ? Colors.red : const Color.fromARGB(255, 250, 226, 7),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              taxi.isLiked = !taxi.isLiked;
                                              _taxisBox.putAt(index, taxi);
                                            });
                                          },
                                        ),
                                      ),
                                      Positioned(
                                        bottom: -10.0,
                                        left: -10.0,
                                        child: IconButton(
                                          icon: Icon(
                                            taxi.isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                                            color: taxi.isBookmarked ? Colors.orange : Colors.yellow,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              taxi.isBookmarked = !taxi.isBookmarked;
                                              _taxisBox.putAt(index, taxi);
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'id: ${taxi.id}',
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 1.0),
                                        Text(
                                          'Latitude: ${taxi.latitude}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16.0),
                                        ),
                                        const SizedBox(height: 1.0),
                                        Text(
                                          'Types: ${taxi.types}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16.0),
                                        ),
                                        const SizedBox(height: 1.0),
                                        Text(
                                          'Longitude: ${taxi.longitude}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16.0),
                                        ),
                                        const SizedBox(height: 1.0),
                                        Text(
                                          'country:${taxi.country}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16.0),
                                        ),
                                        const SizedBox(height: 1.0),
                                        Text(
                                          'iata:${taxi.iata}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16.0),
                                        ),
                                        const SizedBox(height: 1.0),
                                        Text(
                                          'name:${taxi.name}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16.0),
                                        ),
                                        const SizedBox(height: 1.0),
                                        Text(
                                          'countryCode:${taxi.countryCode}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16.0),
                                        ),
                                        const SizedBox(height: 1.0),
                                        Text(
                                          'city:${taxi.city}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16.0),
                                        ),
                                         Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (starIndex) {
                        return IconButton(
                          icon: Icon(
                            starIndex < (taxi.rating) ? Icons.star : Icons.star_border,
                            color: starIndex < (taxi.rating) ? Colors.yellow : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                            taxi .rating = starIndex + 1;
                              _taxisBox.putAt(index, taxi);
                            });
                          },
                        );
                      }),

                                         ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ), currentIndex: 7, userFirstName: user.userfirstName, places: [],
    );
  }


  Widget _buildDropdown(String label, String? selectedValue, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      hint: Text('Select $label location'),
      items: _citiesToCountry.keys.map((location) {
        return DropdownMenuItem(
          value: location,
          child: Text(location),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(label == 'From' ? Icons.flight_takeoff : Icons.flight_land),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      ),
    );
  }
}
