



import 'package:flutter/material.dart';
import 'package:hidden/model/transport.dart';
import 'package:hidden/screens/accommodation_page.dart';
import 'package:hidden/screens/gem_page.dart';





import '../model/users.dart';
import '../widgets/images_widgets.dart';

class TransportPage extends StatefulWidget {
  const TransportPage({super.key});

  bool get isLiked => false;

  @override
  State<TransportPage> createState() => _TransportPageState();
}

class _TransportPageState extends State<TransportPage> {

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
                      'Mode of transportation',
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
          icon: Icons.flight,
          text: 'flight',
           onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GemPage(title: 'Hidden Gem Details')),
                    );
                  },
        ),
        const SizedBox(width: 15), 

        CircularItem(
          icon: Icons.bus_alert,
          text: 'Bus',
          onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Accommodationpage(title: 'accommodatio Det')),
                    );
                  },
        ),
        const SizedBox(width: 15), 
        CircularItem(
          icon: Icons.train,
          text: 'Train',
          onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const GemPage(title: 'Hidden Gem Details')),
                    );
                  },
        ),
        
      ],
    ),
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
   child: ListView.builder(
   scrollDirection: Axis.horizontal,
  physics: const BouncingScrollPhysics(),
  itemCount: transportation.length,
    itemBuilder: (context, index) {
      final Transport = transportation[index];
      final assetPath = 'assets/images/${Transport.imageurl}';
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
                        Transport.isLiked ? Icons.favorite : Icons.favorite_border,
                        color: Transport.isLiked ? Colors.red : Colors.yellow,
                      ),
                      onPressed: () {
                        setState(() {
                          // Toggle the like status for this place
                          Transport.isLiked = !Transport.isLiked;
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
                        Transport.Transport_mode,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 1.0),
                      Text(
                        Transport.Mode_type,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(height: 1.0),
                      Text(
                        '\$${Transport.Transport_cost.toStringAsFixed(1)}',
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
                                              index: Transport.rating > index ? 1 : 0,
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
        
      
        ]

        
    ),
            ),
            ),
          ],
            ),
        ),

    );
  }

  }

