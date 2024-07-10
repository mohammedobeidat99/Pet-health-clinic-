

//new code 

import 'package:flutter/material.dart';
import 'package:pethhealth/constant/color.dart';

Widget ProductCard({
  required String imagePath,
  required String name,
  required int price,
  required int weight,
  required Function(String, String, int, int) addToCart,
  required BuildContext context,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(18.0),
                width: 150,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imagePath,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "$weight Kg",
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "$price JOD",
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(mainColor),
                ),
                onPressed: () {
                  addToCart(imagePath, name, price, weight);
                },
                child: Text(
                  'Add to Cart',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            width: 70.0,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Color.fromARGB(146, 243, 117, 108),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
            ),
            child: Text(
              'Certified',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
