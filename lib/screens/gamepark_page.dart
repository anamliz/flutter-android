
import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import '../model/gameparks.dart';
import '../model/users.dart';


class Gameparkpage extends StatefulWidget {
  final String title;

  // ignore: use_key_in_widget_constructors
  const Gameparkpage({Key? key, required this.title});

  bool get isLiked => false;

  @override
  State<Gameparkpage> createState() => _GameparkpageState();
}

class _GameparkpageState extends State<Gameparkpage> {
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
                "Gamepark",
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
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 12,
                      child: Icon(Icons.person, color: Colors.black),
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...Parks.map((park) => ParkCard(park: park)),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: _currentPage,
        onTap: (int index) {
          if (index == 0) {
            // Add functionality for home icon navigation
            Navigator.pop(context); // Navigate back to the previous screen
          } else {
          _pageController.jumpToPage(index);
          setState(() => _currentPage = index);
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

class ParkCard extends StatelessWidget {
  final Park park;

  const ParkCard({super.key, required this.park});

  @override
  Widget build(BuildContext context) {
    final assetPath = 'assets/images/${park.animalimageurl}';
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
       
      //crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.asset(
                                          assetPath,
                                          width: 400,
                                          //height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                top: -10.0,
                right: -10.0,
                child: IconButton(
                  icon: Icon(
                    park.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: park.isLiked ? Colors.red:Colors.yellow,
                  ),
                  onPressed: (){
                    // Toggle the like status for this place
                    park.isLiked = !park.isLiked;
                    setState(() {}); // Update the UI
                   
  },
                  
                ),
              ),
                                    ],
                                  ),
        
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      park.gameparkname,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),

                  
                
  ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => bookingPage(park: park)),
    );
  },

  style: ElevatedButton.styleFrom(
   backgroundColor:  const Color.fromARGB(255, 1, 58, 105),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(4.0), // Set corner radius to 4
    ),
  ),
  child: const Text(
    'BOOK NOW',
    style: TextStyle(
      fontSize: 14, // Set font size to 14
      color: Colors.white, // Set text color to white
    ),
  ),
),
 ],
                ),
                  
                const SizedBox(height: 4.0),
                Text(park.animalname),
                const SizedBox(height: 4.0),
               // Text('Entry Fee: \$${park.entryfee}'),
                const SizedBox(height: 4.0),
                Text(park.animaldescription),

                 const SizedBox(height: 1.0),
                      Text(
                        '\$${park.entryfee.toStringAsFixed(1)}',
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
                                              index: park.rating > index ? 1 : 0,
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
        ],
      ),
    );
  }
  
  void setState(Null Function() param0) {}
  
  bookingPage({required Park park}) {}
  
  
}


