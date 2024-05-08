/*
import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hidden/model/place.dart';
import 'package:hidden/model/profile.dart';
import 'package:hidden/model/users.dart';
import 'package:hidden/screens/acc_screen.dart';
import 'package:hidden/screens/accommodation_page.dart';
import 'package:hidden/screens/bookmark_page.dart';
import 'package:hidden/screens/favorites_page.dart';
import 'package:hidden/screens/gamepark_page.dart';
import 'package:hidden/screens/gem_page.dart';
import 'package:hidden/screens/settings_page.dart';
import 'package:hidden/screens/transport_page.dart';
import 'package:hidden/widgets/images_widgets.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PlaceAdapter());

  runApp(
    ChangeNotifierProvider<Profile>(
      create: (_) => Profile(),
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(),
      ),
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  bool get isLiked => false;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Box<Place> _placesBox;
  late TextEditingController _searchController;
  bool _isLoading = true;
  List<Place> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
    _searchController = TextEditingController();
  }

  Future<void> _initializeData() async {
    _placesBox = await Hive.openBox<Place>('PlacesBox');

    // Clear the box to remove any duplicate data
    _placesBox.clear();

    for (final place in places) {
      // Check if the place ID already exists in the box
      final existingPlace = _placesBox.get(place.placeId);
      if (existingPlace == null) {
        // Insert new place into the box
        _placesBox.put(place.placeId, place);
        print('Place with ID ${place.placeId} inserted.');
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  void updateLikedStatus(int index) {
    final place = _placesBox.getAt(index);
    if (place != null) {
      setState(() {
        place.isLiked = !place.isLiked;
        _placesBox.putAt(index, place);
      });
    }
  }

  void updateBookmarkedStatus(int index) {
    final place = _placesBox.getAt(index);
    if (place != null) {
      setState(() {
        place.isBookmarked = !place.isBookmarked;
        _placesBox.putAt(index, place);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Profile>(
      builder: (_, profile, __) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 1, 73, 4),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "HiddenHaven",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>  ProfilePage(profiles: profile)),
                            );
                          },
                          child: const CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 12,
                            child: Icon(
                              Icons.person,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 2.0),
                        Text(
                          profile.userfirstName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : NotificationListener<QuotesNotification>(
                    onNotification: (notification) {
                      if (notification.type == QuoteChange && mounted) {
                        setState(() {
                          _quotes = notification.quotes;
                        });
                      }
                      return true;
                    },
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              Container(
                                height: 410,
                                margin: const EdgeInsets.symmetric(vertical: 0),
                                padding: const EdgeInsets.symmetric(horizontal: 0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color.fromARGB(255, 216, 209, 209),
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.search),
                                    const SizedBox(width: 10.0),
                                    Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: 'Search...',
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: const Color.fromARGB(255, 92, 91, 91),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          handleSearch(value);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            separatorBuilder: (context, index) => const Divider(thickness: 1),
                            itemCount: _quotes.length + 1,
                            itemBuilder: (context, index) {
                              if (index > _quotes.length) {
                                return const SizedBox();
                              } else if (index == _quotes.length) {
                                return const LoadMoreQuotesButton();
                              } else {
                                final quote = _quotes[index];
                                return ListTile(
                                  leading: Text(
                                    "${quote.symbol}: ${quote.price}",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: LikeButton(quote: quote),
                                  title: Text(quote.description),
                                  subtitle: Text("Timestamp: ${quote.timestamp}"),
                                  onTap: () => selectQuote(_quotes[index]),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              
              bottomNavigationBar: BottomBar(
                selectedIndex: _currentPage,
                onTap: (int index) {
                  setState(() => _currentPage = index);
                  switch (index) {
                    case 0:
                      _pageController.jumpToPage(index);
                      break;
                    case 1:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FavoritesPage()),
                      );
                      break;
                    case 2:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BookmarksPage(quotes: quotes)),
                      );
                      break;
                    case 3:
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsPage()),
                      );
                      break;
                  }
                },
                items: <BottomBarItem>[
                  BottomBarItem(
                    icon: const Icon(Icons.home),
                    title: const Text('Home'),
                    activeColor: Colors.blue,
                  ),
                  BottomBarItem(
                    icon: const Icon(Icons.favorite),
                    title: const Text('Favorites'),
                    activeColor: Colors.red,
                  ),
                  BottomBarItem(
                    icon: const Icon(Icons.bookmark),
                    title: const Text('Bookmark'),
                    activeColor: Colors.greenAccent.shade700,
                  ),
                  BottomBarItem(
                    icon: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    activeColor: Colors.orange,
                  ),
                ],
              ),
            );
          },
        ),
      );
}





*/












/*


import 'package:bottom_bar/bottom_bar.dart';

import 'package:flutter/material.dart';
import 'package:hidden/screens/accommodation_page.dart';
import 'package:hidden/screens/gem_page.dart';
import 'package:hidden/screens/gamepark_page.dart';
import 'package:hidden/screens/profile_page.dart';
import 'package:hidden/screens/transport_page.dart';
import 'package:hidden/screens/favorites_page.dart';
import 'package:hidden/screens/bookmark_page.dart';
import 'package:hidden/screens/settings_page.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/biome.dart';
import '../model/places.dart';

import '../model/profile.dart';
import '../model/tundra.dart';
import '../model/users.dart';
import '../widgets/images_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  bool get isLiked => false;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
int _currentPage = 0;
  final PageController _pageController = PageController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 73, 4),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(children: [
              Text(
                "HiddenHaven",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ]),
            Row(
              children: [
                Column(
                  children: [
                     GestureDetector(
      onTap: () {
       
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  ProfilePage(profiles: profile)),
                    );
                  },

      
      child:
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 12,
                      child: Icon(Icons.person, color: Colors.black),
                    ),
                    ),
                    const SizedBox(width: 2.0),
                    Text(
                      user.userfirstName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                     
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
        
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  
        children: [
         
                    const SizedBox(height: 0),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 0),
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color.fromARGB(255, 216, 209, 209)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 92, 91, 91),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search...',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: const Color.fromARGB(255, 49, 49, 49)
                                      .withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 1),
                    
                    const Text(
                      'TravelScape',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 1),
                     Container(
  padding: const EdgeInsets.all(4),
  child:  SingleChildScrollView(
    scrollDirection: Axis.horizontal, 
    child: Row(
      children:[
        CircularItem(
          icon: Icons.visibility,
          text: 'Hidden gem',
           onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GemPage(title: 'Hidden Gem Details')),
                    );
                  },
        ),
        const SizedBox(width: 15), 

        CircularItem(
          icon: Icons.hotel_class,
          text: 'Accommodations',
          onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Accommodationpage(title: 'accommodatio Details')),
                    );
                  },
        ),
        const SizedBox(width: 15), 
        CircularItem(
          icon: Icons.video_call,
          text: 'Forum',
          onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GemPage(title: 'Forum/live chart')),
                    );
                  },
        ),
        const SizedBox(width: 15), 
        CircularItem(
          icon: Icons.explore,
          text: 'Documentaries',
          onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GemPage(title: 'Documentaries')),
                    );
                  },
        ),
        const SizedBox(width: 15), // Add spacing between circular items
        CircularItem(
          icon: Icons.landscape,
          text: 'Game parks',
          onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Gameparkpage(title: 'Gamepark Details')),
                    );
                  },
        ),
        const SizedBox(width: 15), // Add spacing between circular items
        CircularItem(
          icon: Icons.book_online,
          text: 'Transportation',
          onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TransportPage()),
                    );
                  },
        ),
      ],
    ),
  ),
),
                    const SizedBox(height: 1),
                    const Text(
                      'Discover places',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Container(
                      height: 410,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: places.length,
                        itemBuilder: (context, index) {
                          final place = places[index];
                          final assetPath =
                              'assets/images/${place.placeimageurl}';
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0,  vertical: 5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 3,
                                    offset: const Offset(0, 3),
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
                                        child: Image.asset(
                                          assetPath,
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
                                            place.isLiked
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: place.isLiked
                                                ? Colors.red
                                                : Colors.yellow,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              // Toggle the like status for this place
                                              place.isLiked = !place.isLiked;
                                            });
                                            
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                         Row(
                      children: [
                                        Text(
                                          place.placename,
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                         const SizedBox(width: 200.0),
                                        IconButton(
  icon: Icon(
    place.isBookmarked
        ? Icons.bookmark
        : Icons.bookmark_border,
    color: place.isBookmarked ? Colors.blue : Colors.green,
  ),
  onPressed: () {
    setState(() {
      // Toggle the bookmark status for this place
      place.isBookmarked = !place.isBookmarked;
    });
  },
),
                      ],
                                         ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          place.placedescription,
                                          style: const TextStyle(fontSize: 16.0),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          '\$${place.placeprice.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Row(
                                          children: List.generate(
                                            place.rating,
                                            (index) => const Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                            ),
                                          ),
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
                    const SizedBox(height: 1),
                    const Text(
                      'Preference',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Container(
                      height: 400,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: biomes.length,
                        itemBuilder: (context, index) {
                          final Biome = biomes[index];
                          final assetPath =
                              'assets/images/${Biome.imageurl}';
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0,  vertical: 5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 7,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Image.asset(
                                        assetPath,
                                        width: 170,
                                        height: 150,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        top: -10.0,
                                        right: -10.0,
                                        child: IconButton(
                                          icon: Icon(
                                            Biome.isLiked
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: Biome.isLiked
                                                ? Colors.red
                                                : Colors.yellow,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              // Toggle the like status for this biome
                                              Biome.isLiked =
                                                  !Biome.isLiked;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 0.0),
                                  SizedBox(
                                    width: 170,
                                    child: Container(
                               margin: const EdgeInsets.all(16.0),  
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          Biome.biomename,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(Biome.description),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          '\$${Biome.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                            color: Colors.green,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          'Latitude: ${Biome.latitude}, Longitude: ${Biome.longitude}',
                                          style: const TextStyle(
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Row(
                                          children: List.generate(
                                            5,
                                            (index) => IndexedStack(
                                              alignment: Alignment.topRight,
                                              index: Biome.rating > index ? 1 : 0,
                                              children: const [
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.grey,
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.yellow,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 1),
      const Text(
                      'Recommandation',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 1),

Container(
  height: 400,
  child: GridView.count(
    crossAxisCount: 1,
    shrinkWrap: true,
    primary: false,
    physics: const BouncingScrollPhysics(),
    children: List.generate(tundras.length, (index) {
      final Tundra = tundras[index];
      final assetPath = 'assets/images/${Tundra.imageurl}';
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 3),
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
                    child: Image.asset(
                      assetPath,
                       width: 400,
                      //width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: -10.0,
                    right: -10.0,
                    child: IconButton(
                      icon: Icon(
                        Tundra.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: Tundra.isLiked ? Colors.red : Colors.yellow,
                      ),
                      onPressed: () {
                        setState(() {
                          // Toggle the like status for this place
                          Tundra.isLiked = !Tundra.isLiked;
                        });
                      },
                    ),
                  ),
                ],
              ),
             
                 SizedBox(
                   width:170,
                 child:Container(
                  margin:const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Tundra.tundraname,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 1.0),
                      Text(
                        Tundra.description,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 1.0),
                      Text(
                        '\$${Tundra.price.toStringAsFixed(1)}',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 0.0),
                      Row(
                                          children: List.generate(
                                            5,
                                            (index) => IndexedStack(
                                              alignment: Alignment.topRight,
                                              index: Tundra.rating > index ? 1 : 0,
                                              children: const [
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.grey,
                                                ),
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.yellow,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                    ],
                  ),
                ),
                 ),
            ],
          ),
        ),
      );
    }),
  ),
        
),






        ],
    ),
            ),
            ),
  ],
        ),
      ),


                    
                    
                
bottomNavigationBar: BottomBar(
  selectedIndex: _currentPage,
  onTap: (int index) {
    setState(() => _currentPage = index);
    switch (index) {
      case 0:
        // Navigate to Home page
        _pageController.jumpToPage(index);
        break;
      case 1:
        // Navigate to Favorites page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FavoritesPage()), // 
        );
        break;
      case 2:
        // Navigate to Bookmark page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookmarkPage(places: places)), // Navigate to BookmarkPage
        );
        break;
      case 3:
        // Navigate to Settings page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()), 
        );
        break;
    }
  },
  items: <BottomBarItem>[
    const BottomBarItem(
      icon: Icon(Icons.home),
      title: Text('Home'),
      activeColor: Colors.blue,
    ),
    const BottomBarItem(
      icon: Icon(Icons.favorite),
      title: Text('Favorites'),
      activeColor: Colors.red,
    ),
    BottomBarItem(
      icon: const Icon(Icons.bookmark),
      title: const Text('Bookmark'),
      activeColor: Colors.greenAccent.shade700,
    ),
    const BottomBarItem(
      icon: Icon(Icons.settings),
      title: Text('Settings'),
      activeColor: Colors.orange,
    ),
  ],
),

    );
  }
}




*/