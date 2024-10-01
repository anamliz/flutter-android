import 'package:flutter/material.dart';

import 'signup_page.dart';

import 'login_page.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HiddenHaven'),
      ),
      body: SingleChildScrollView(
        //child: Container(
          //margin: const EdgeInsets.all(20), 
          child: Padding(
            padding: const EdgeInsets.all(16.0), 

        child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
         
         const Text('Uncovering Earth’s hidden ecological gem and natural treasure. ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const LoginPage(),
    ),
  );
                },
                child: const Image(
                  image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzb6A5q16lkAUfturiK-flSBUmqiu0c81jcw&usqp=CAU'),

                            width: 340,     // Width of the image
                            height: 600,    // Height of the image
                            fit: BoxFit.contain,
                          ),
              ),
               //const SizedBox(width: 16.0),

         // SizedBox(height: 2), // Add spacing between image and text
          const Text('Embark on a journey of Exploration, where you will delve into unique biome',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          
            Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          },
          child: const Text('Login'),
        ),
      ),
    ),
    const SizedBox(width: 16.0), // Add space between buttons if needed
    Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SignupPage(),
              ),
            );
          },
          child: const Text('Sign Up'),
        ),
      ),
    ),
  ],
),

        ],
      ),
          ),
      ),
      //),
    );
  }
}



