import 'package:flutter/material.dart';
import 'package:pethhealth/components/applocal.dart';
import 'package:pethhealth/constant/color.dart';
import 'package:pethhealth/constant/images.dart';
import 'package:pethhealth/screen/auth/login_screen.dart';

class Intro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Stack(
        children: [
          // Full-screen image
          Image.asset(
            imageBack, // Replace this with your own image
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          // Container with image and text at the bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(0.6), // Add opacity to make text readable
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
              ),
              height: 275.0,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Image.asset(
                    imageLogo,
                    height: 120,
                  ),
                  //SizedBox(width: 20.0),
                   Text(
                    

                    getLang(context, 'welcome'), // Your text here
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                   Text(
                      getLang(context, 'family'), // Your text here
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                 ),
                 SizedBox(height:  12.0),
                  Container(
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: BorderRadius.circular(12)
      ),
      width: double.infinity,
      child: TextButton(
        onPressed: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));

        },
        child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      
                      Text(
                       getLang(context, 'next'),
                        style: TextStyle(color: Colors.white),
                      ) ,
                      // SizedBox(
                      //   width: 10,
                      // ),

                      Icon(
                        Icons.navigate_next_outlined,
                        color: Colors.white,
                      ),
                    ],
                  ),
      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
