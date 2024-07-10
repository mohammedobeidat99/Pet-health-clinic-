import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pethhealth/constant/images.dart';

class ImageCarousel extends StatefulWidget {
  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  // List of images
  List<String> imagePaths = [
    imageSlide1,
    imageSlide2,
    imageSlide3,
    imageSlide4,
    imageSlide5,
  ];

  // Index to keep track of current image
  int currentIndex = 0;

  // Timer for changing images
  late Timer timer;

  @override
  void initState() {
    super.initState();
    // Start the timer to change images every 3 seconds
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
      setState(() {
        currentIndex = (currentIndex + 1) % imagePaths.length;
      });
    });
  }

  @override
  void dispose() {
    // Dispose the timer when the widget is removed
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 200.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Image.asset(
          imagePaths[currentIndex],
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
