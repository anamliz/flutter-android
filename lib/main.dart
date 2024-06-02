

import 'package:flutter/material.dart';

import 'package:hidden/screens/home_page.dart';
//import 'package:hidden/screens/landing.dart';
import 'package:hive_flutter/adapters.dart';



import 'model/accommondation.dart';
import 'model/biome.dart';
import 'model/datum.dart';
import 'model/place.dart';
import 'model/review.dart';
import 'model/tundra.dart';



//import 'screens/landing.dart'; // Import the Places class

void main() async  {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  Hive.registerAdapter(PlaceAdapter());
  Hive.registerAdapter(BiomeAdapter());
  Hive.registerAdapter(TundraAdapter());
  Hive.registerAdapter(DatumAdapter());
  Hive.registerAdapter(HotelAdapter());
 
  // Open the 'searchHistory' box
   await Hive.openBox<String>('searchHistory');
   await Hive.openBox<Datum>('datumsBox');
   await Hive.openBox<Place>('PlacesBox');
   await Hive.openBox<Biome>('biomesBox'); // Initialize _biomesBox
   await Hive.openBox<Tundra>('tundrasBox');
   await Hive.openBox<Hotel>('hotelsBox'); 
   await Hive.openBox<Review>('reviewsBox'); 
   
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
   // final size = MediaQuery.of(context).size;
    return   MaterialApp(
      //home: Gameparkpage()
     //  home: Reviewpage()
      home: HomePage()
        );
  }
}

/*import 'package:flutter/material.dart';
import 'package:hidden/screens/gamepark_page.dart';
import 'package:hidden/screens/home_page.dart';
import 'package:hidden/screens/review_page.dart';

import 'model/users.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 1, 73, 4),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                   IconButton(
                    icon: const Icon(Icons.menu),
                    color: Colors.white,
                    onPressed: () {
                      // Add functionality for home icon
                      print('Home icon pressed!');
                    },
                  ),

                
                  SizedBox(width: 8.0),
                 Text("Park",
            //user.userfirstName, // Assuming 'user' is an instance of Users
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),

                ],
              ),
              Row(
                children: [

                     IconButton(
                    icon: const Icon(Icons.search),
                    color: Colors.white,
                    onPressed: () {
                      // Add functionality for notifications icon
                      print('search icon pressed!');
                    },
                  ),

                   IconButton(
                    icon: const Icon(Icons.notifications),
                    color: Colors.white,
                    onPressed: () {
                      // Add functionality for notifications icon
                      print('Notifications icon pressed!');
                    },
                  ),
                 
                 CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 10,
                    child: Icon(Icons.person, color: Colors.black),
                  ),
                   
                ],
              ),
            ],
          ),
        ),
      
        body: Gameparkpage(), // Set the body to your Gameparkpage widget
      ),
    );
  }
}*/



