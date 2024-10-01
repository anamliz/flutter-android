
import 'package:flutter/material.dart';
import 'package:hidden/model/booking.dart';
import 'package:hidden/model/gameparks.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'model/accommondation.dart';
import 'model/attraction.dart';
import 'model/flight.dart';
import 'model/hotel.dart';
import 'model/place.dart';
import 'model/review.dart';
import 'model/session_token.dart';
import 'model/taxi.dart';
import 'model/users.dart';
import 'screens/home_page.dart';
import 'screens/landing.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(SessionTokenAdapter());
  Hive.registerAdapter(PlaceAdapter());
  Hive.registerAdapter(HotelAdapter());
  Hive.registerAdapter(AccommodationAdapter());
  Hive.registerAdapter(FlightAdapter());
  Hive.registerAdapter(TaxiAdapter());
  Hive.registerAdapter(BookingAdapter());
  Hive.registerAdapter(UsersAdapter());
  Hive.registerAdapter(ParkAdapter());
  Hive.registerAdapter(DestinationAdapter());
  

  // Open Hive boxes
  await Hive.openBox('session_box');
  await Hive.openBox<Flight>('flightsBox');
  await Hive.openBox<Taxi>('taxisBox');
  await Hive.openBox<Booking>('bookingsBox');
   await Hive.openBox<Park>('parksBox');
  await Hive.openBox<Place>('PlacesBox');
  await Hive.openBox<Accommodation>('AccommodationsBox');
  await Hive.openBox<Hotel>('hotelsBox');
  await Hive.openBox<Review>('reviewsBox');
  await Hive.openBox<Users>('Destination');
  await Hive.openBox<Users>('usersBox');
  await Hive.openBox<String>('TokenBox');



  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Box sessionBox;
  late Widget initialRoute;

  @override
  void initState() {
    super.initState();
    sessionBox = Hive.box('session_box');
    initialRoute = _checkSession() ?  HomePage() : const Landing();
  }

  bool _checkSession() {
    var sessionToken = sessionBox.get('session');
    return sessionToken != null && sessionToken.token.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      // home: Landing()
      home: HomePage()
    );
  }
}
