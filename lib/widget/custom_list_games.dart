import 'package:flutter/material.dart';
import 'package:pethhealth/constant/color.dart';

Widget ListGame({
  required String imagePath,
  required String name,
  required String ratings,
  required int price,
  String? discount,
  required String des,
}) {
  return Card(
    elevation: 3,
    child: Stack(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              height: 125,
              width: 110,
              padding: const EdgeInsets.only(left: 0, top: 10, bottom: 70, right: 20),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: const TextStyle(
                      color: mainColor2,
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    des,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '$price JOD',
                    style: const TextStyle(
                      fontSize: 14,
                      color: mainColor2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Text(
                        ratings,
                        style: const TextStyle(
                          fontSize: 13,
                          color: mainColor2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        "Ratings",
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        if (discount != null)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8.0), // Adjust the radius as needed
                ),
                color: mainColor2,
              ),
              width: 90,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    '$discount Discount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        Positioned(
          bottom: 10,
          right: 8,
          child: IconButton(
            icon: const Icon(Icons.add_shopping_cart, color: mainColor2,),
            onPressed: () {
              // Implement your add to cart functionality here
            },
          ),
        ),
      ],
    ),
  );
}
