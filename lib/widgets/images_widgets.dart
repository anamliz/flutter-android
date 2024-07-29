import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../model/users.dart';

class CircularItem extends StatelessWidget {
  final IconData icon;
  final String text;
   final VoidCallback onTap;

  const CircularItem({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    //return Column(
          return GestureDetector(
      onTap: onTap,
      child: Column(

      children: [
        Container(
          width: 75,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color.fromARGB(255, 179, 177, 177)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                color: const Color.fromARGB(255, 60, 94, 60),
              ),
              const SizedBox(height: 4),
              Text(
                text,
                 style: const TextStyle(
                        //color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 6,
                      ),
                
                
              ),
            ],
          ),
        ),
      ],
      ),
    );
  }
  
}




