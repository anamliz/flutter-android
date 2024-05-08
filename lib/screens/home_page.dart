


import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:hidden/model/tundra.dart';
import 'package:hidden/screens/profile_page.dart';
import 'package:hidden/screens/review_page.dart';
 
import 'package:hive_flutter/adapters.dart';
import 'package:hive/hive.dart';
import '../model/biome.dart';
import '../model/place.dart';
import '../model/profile.dart';
import '../model/users.dart';
import '../screens/accommodation_page.dart';
import '../screens/bookmark_page.dart';
import '../screens/favorites_page.dart';
import '../screens/gamepark_page.dart';
import '../screens/gem_page.dart';
import '../screens/settings_page.dart';
import '../screens/transport_page.dart';
import '../widgets/images_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  bool get isLiked => false;


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   List<String> comments = [];
// buttomappbar
  int _currentPage = 0;
  final PageController _pageController = PageController();


  //place box
  late Box<Biome> _biomesBox;
  late Box<Place> _placesBox;
  late Box<Tundra> _tundrasBox;
  bool _isLoading = true;



  @override
  void initState() {
    super.initState();
    
    _initializeData();
    
  }
  
   
  Future<void> _initializeData() async {
    try {
      _placesBox = await Hive.openBox<Place>('PlacesBox');
     // _placesBox.addAll(places); //only insert the places that dont exist
      // Clear the box to remove any duplicate data
 // _placesBox.clear();
   
   _biomesBox = await Hive.openBox<Biome>('biomesBox'); // Initialize _biomesBox
  // _biomesBox. clear();

   _tundrasBox = await Hive.openBox<Tundra>('tundrasBox'); 
    //_tundrasBox.clear();

       for (var place in places) {
      // Check if the place ID already exists in the box
      
      final existingPlace = _placesBox.get(place.placeId);
      if (existingPlace == null) {
        // Insert new place into the box
        _placesBox.put(place.placeId, place);
        print('Place with ID ${place.placeId} inserted.');
      }
    }

     // Insert biomes if they don't already exist
    for (var biome in biomes) {
      final existingBiome = _biomesBox.get(biome.biomeid);
      if (existingBiome == null) {
        _biomesBox.put(biome.biomeid, biome);
        print('Biome with ID ${biome.biomeid} inserted.');
      }
    }

    // Insert biomes if they don't already exist
    for (var tundra in tundras) {
      final existingTundra = _tundrasBox.get(tundra.tundraid);
      if (existingTundra == null) {
        _tundrasBox.put(tundra.tundraid, tundra);
        print('Tundra with ID ${tundra.tundraid} inserted.');
      }
    }
     
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  void updateLikedStatus(int index) {
    final place = _placesBox.getAt(index);
    if (place != null) {
      setState(() {
        place.isLiked = !place.isLiked;
        _placesBox.putAt(index, place);
      });
    }

    final Biome? biome = _biomesBox.getAt(index);
    if (biome != null) {
  setState(() {
    biome.isLiked = !biome.isLiked; // Modify isLiked property of the biome object
    _biomesBox.putAt(index, biome); // Update the biome object in _biomesBox
  });
}

final Tundra? tundra = _tundrasBox.getAt(index);
    if (tundra != null) {
  setState(() {
    tundra.isLiked = !tundra.isLiked; // Modify isLiked property of the biome object
    _tundrasBox.putAt(index, tundra); // Update the biome object in _biomesBox
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
   final Biome? biome = _biomesBox.getAt(index); // Retrieve biome from _biomesBox

if (biome != null) { // Checking  if biome is not null
  setState(() {
    biome.isBookmarked = !biome.isBookmarked; 
    _biomesBox.putAt(index, biome); // Update biome in _biomesBox
  });
}

final Tundra? tundra = _tundrasBox.getAt(index); // Retrieve biome from _biomesBox

if (tundra != null) { // Checking  if biome is not null
  setState(() {
    tundra.isBookmarked = !tundra.isBookmarked; 
    _tundrasBox.putAt(index, tundra); // Update biome in _biomesBox
  });
}

  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
       child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height:20),
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
                      MaterialPageRoute(builder: (context) =>  ReviewPage(onCommentAdded: (String ) {  },)),
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

                                 /* _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )*/
    
            Container(
                height: 410,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _placesBox.length,
                  itemBuilder: (context, index) {
                    final place = _placesBox.getAt(index);
                    final assetPath = 'assets/images/${place?.placeImageUrl ?? ''}';

                    if (place == null) {
                      return SizedBox(); // Return an empty widget if place is null
                    }

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
                                      place.isLiked ? Icons.favorite : Icons.favorite_border,
                                      color: place.isLiked ? Colors.red : Colors.yellow,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        place.isLiked = !place.isLiked;
                                        _placesBox.putAt(index, place);
                                      });
                                    },
                                  ),
                                ),
                                Positioned(
                                  bottom: -10.0,
                                  left: -10.0,
                                  child: IconButton(
                                    icon: Icon(
                                      place.isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                                      color: place.isBookmarked ? Colors.orange : Colors.yellow,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        place.isBookmarked = !place.isBookmarked;
                                        _placesBox.putAt(index, place);
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
                                    place.placeName,
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    place.placeDescription,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Text(
                                    '\$${place.placePrice}',
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
                                        size: 16.0,
                                        color: Colors.amber,
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
                      height: 410,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _biomesBox.length,
                        itemBuilder: (context, index) {
                          //final Biome? = _biomesBox?.getAt(index);

                          final Biome? biome = _biomesBox?.getAt(index); 

                          final assetPath = 'assets/images/${biome?.imageurl ?? ''}';


                         if (Biome == null) {
                      return SizedBox(); // Return an empty widget if place is null
                    }
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
                                    spreadRadius: 2,
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
                                           biome != null && biome.isLiked
    ? Icons.favorite
    : Icons.favorite_border,
color: biome != null && biome.isLiked
    ? Colors.red
    : Colors.yellow,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              
                                             final Biome? biome = _biomesBox.getAt(index); // Use ? for null safety

if (biome != null) { // Check if biome is not null
  setState(() {
    biome.isLiked = !biome.isLiked; 
    _biomesBox.putAt(index, biome); // Update 
  });
}
                                            });
                                          },
                                        ),
                                      ),
                                       Positioned(
                                  bottom: -10.0,
                                  left: -10.0,
                                 child: IconButton(
  icon: Icon(
    biome?.isBookmarked ?? false ? Icons.bookmark : Icons.bookmark_outline,
    color: biome?.isBookmarked ?? false ? Colors.orange : Colors.yellow,
  ),
  onPressed: () {
    setState(() {
      if (biome != null) {
        biome.isBookmarked = !biome.isBookmarked;
        _biomesBox.putAt(index, biome);
      }
    });
  },
),

                                       ),
                                       
                                    ],
                                  ),
                                  
                                  SizedBox(
                                    width: 170,
                                    child: Container(
                               margin: const EdgeInsets.all(16.0),  
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          biome!.biomename,
                                          
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        
                                        Text(
                                   biome.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          '\$${biome.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                            color: Colors.green,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          'Latitude: ${biome.latitude}, Longitude: ${biome.longitude}',
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
                                              index: biome.rating > index ? 1 : 0,
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
    height: 3200,
  child:GridView.count(
      crossAxisCount: 1,
      shrinkWrap: true,
      primary: false,
     // physics: const BouncingScrollPhysics(),
      physics: NeverScrollableScrollPhysics(),
      children: List.generate(_tundrasBox.length, (index) {
        final Tundra? tundra = _tundrasBox.getAt(index);
        final assetPath = 'assets/images/${tundra?.imageurl}';
        if (tundra == null) {
          return SizedBox(); // Placeholder for null items
        }
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
                  blurRadius: 2,
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
                      child: Image.asset(
                        assetPath,
                         width: 400,
                        //width: double.infinity,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: -10.0,
                      right: -10.0,
                      child: IconButton(
                        icon: Icon(
                            tundra != null && tundra.isLiked
      ? Icons.favorite
      : Icons.favorite_border,
  color: tundra != null && tundra.isLiked
      ? Colors.red
      : Colors.yellow,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                              
                                               final Tundra? tundra = _tundrasBox.getAt(index); // Use ? for null safety
  
  if (tundra != null) { // Check if not null
    setState(() {
      tundra.isLiked = !tundra.isLiked; 
      _tundrasBox.putAt(index, tundra); 
    });
  }
                          });
                        },
                      ),
                    ),
                   Positioned(
                                    bottom: -10.0,
                                    left: -10.0,
                                   child: IconButton(
    icon: Icon(
      tundra?.isBookmarked ?? false ? Icons.bookmark : Icons.bookmark_outline,
      color: tundra?.isBookmarked ?? false ? Colors.orange : Colors.yellow,
    ),
    onPressed: () {
      setState(() {
        if (tundra != null) {
          tundra.isBookmarked = !tundra.isBookmarked;
          _tundrasBox.putAt(index, tundra);
        }
      });
    }
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
                          tundra.tundraname,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 1.0),
                        Text(
                          tundra.description,
                            overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                        const SizedBox(height: 0.0),
                        Text(
                          '\$${tundra.price.toStringAsFixed(1)}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 0.4),
                        Row(
                                            children: List.generate(
                                              5,
                                              (index) => IndexedStack(
                                                alignment: Alignment.topRight,
                                                index: tundra.rating > index ? 1 : 0,
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
      }
      ),
                    ),
      
    ),
  
    Container(
      height: 450,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _biomesBox.length,
        itemBuilder: (context, index) {
          final Biome? biome = _biomesBox.getAt(index);

          final assetPath = 'assets/images/${biome?.imageurl ?? ''}';

          if (biome == null) {
            return const SizedBox();
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
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
                            biome.isLiked ? Icons.favorite : Icons.favorite_border,
                            color: biome.isLiked ? Colors.red : Colors.yellow,
                          ),
                          onPressed: () {
                            setState(() {
                              biome.isLiked = !biome.isLiked;
                              _biomesBox.putAt(index, biome);
                                                        });
                          },
                        ),
                      ),
                      Positioned(
                        bottom: -10.0,
                        left: -10.0,
                        child: IconButton(
                          icon: Icon(
                            biome.isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                            color: biome.isBookmarked ? Colors.orange : Colors.yellow,
                          ),
                          onPressed: () {
                            setState(() {
                              biome.isBookmarked = !biome.isBookmarked;
                              _biomesBox.putAt(index, biome);
                                                        });
                          },
                        ),
                      ),
                      Positioned(
                        bottom: -10.0,
                        right: -10.0,
                        child: IconButton(
                          icon: const Icon(Icons.comment),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Add Comment'),
                                content: TextField(
                                  onChanged: (value) {
                                    // Update comment text
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Enter your comment',
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        // Add comment to the list
                                        comments.add('New Comment: ${DateTime.now()}');
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Add'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 170,
                    child: Container(
                      margin: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            biome.biomename,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            biome.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            '\$${biome.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Latitude: ${biome.latitude}, Longitude: ${biome.longitude}',
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
                                index: biome.rating > index ? 1 : 0,
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
                          const SizedBox(height: 4.0),
                          // Display comments
                           
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
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
          MaterialPageRoute(builder: (context) => const FavoritesPage()), // 
        );
        break;
      case 2:
        // Navigate to Bookmark page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookmarkPage(places:places, tundras: tundras, biomes: biomes)), // Navigate to BookmarkPage
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

