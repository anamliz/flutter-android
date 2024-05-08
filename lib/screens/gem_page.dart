import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';

import '../model/gem.dart';
import '../model/users.dart';
//import 'booking_page.dart';



class GemPage extends StatefulWidget {
  final String title;

  const GemPage({Key? key, required this.title}) : super(key: key);

  
  

  bool get isLiked => false;

  @override
  State<GemPage> createState() => _GemPageState();
}

class _GemPageState extends State<GemPage> {
int _currentPage = 0;
  final PageController _pageController = PageController();
  
  get park => null;



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
                "Hidden gem",
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
                   

                    const SizedBox(height: 1),
      const Text(
                      'Discover hidden gem All over the world',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 1),

Container(
  height: 700,
  child: GridView.count(
    crossAxisCount: 1,
    shrinkWrap: true,
    primary: false,
    physics: const BouncingScrollPhysics(),
    children: List.generate(gems.length, (index) {
      final Gem = gems[index];
      final assetPath = 'assets/images/${Gem.imageurl}';
      return Card(
        //padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
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
                      height: 145,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: -10.0,
                    right: -10.0,
                    child: IconButton(
                      icon: Icon(
                        Gem.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: Gem.isLiked ? Colors.red : Colors.yellow,
                      ),
                      onPressed: () {
                        setState(() {
                          // Toggle the like status for this place
                          Gem.isLiked = !Gem.isLiked;
                        });
                      },
                    ),
                  ),
                ],
              ),
             
                 SizedBox(
                   width:400,
                 child:Container(
                  margin:const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Gem.name,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                   /*  ElevatedButton(
  onPressed: () {
    // Navigate to the booking screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BookingPage(park: park)),
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
),*/
 ],
                ),




                      const SizedBox(height: 1.0),
                      Text(
                        Gem.description,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 1.0),
                      Text(
                        '\$${Gem.price.toStringAsFixed(1)}',
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
                                              index: Gem.rating > index ? 1 : 0,
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

