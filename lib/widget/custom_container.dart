import 'package:flutter/material.dart';
import 'package:pethhealth/constant/color.dart';

Widget buildContainer(String name, String uriImage, int index, int selectedIndex, PageController pageController) {
  return GestureDetector(
    onTap: () {
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    },
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: selectedIndex == index
                ? mainColor2 // Use mainColor for selected container

                : const Color.fromARGB(255, 238, 236, 236),
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: const EdgeInsets.all(10),
          width: 70,
          height: 70,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.asset(uriImage),
          ),
        ),
        Text(
          name,
          style: const TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
            color: mainColor,
          ),
        ),
      ],
    ),
  );
}
