import 'package:flutter/material.dart';

import '../constant/color.dart';

Widget AccessoriesList({
  required String imagePath,
  required String name,
  required int price,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      padding: const EdgeInsets.all(10),
      
      
      
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      //padding: EdgeInsets.all(15),
      width: 150,
      height: 180, // Increased height for better symmetry
      // /margin: EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: 16 / 10, // Set aspect ratio for image
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imagePath,
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(height: 12), // Increased spacing between image and text
          Text(
            name,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: mainColor
            ),
            maxLines: 2, // Limit name text to 2 lines
            overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
          ),
          //SizedBox(height: 4),
         Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [ Text(
            '\$$price JOD',
            style: const TextStyle(
              fontSize: 16,
              color: mainColor,
              fontWeight: FontWeight.bold,
            ),
          ), IconButton(onPressed: (){}, icon: const Icon(Icons.add_shopping_cart, color: mainColor2,),) ],)
          
          
        ],
      ),
    ),
  );
}
