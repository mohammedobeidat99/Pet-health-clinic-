import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pethhealth/components/applocal.dart';
import 'package:pethhealth/constant/color.dart';
import 'package:pethhealth/constant/images.dart';
import 'package:pethhealth/screen/auth/login_screen.dart';
import 'package:pethhealth/widget/add_pet_screen.dart';
import 'package:pethhealth/screen/home/profile/recommendation%20_screen.dart';
import 'package:pethhealth/widget/custom_location.dart';
import 'package:pethhealth/widget/image_slide.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return  Text(
                getLang(context, "loading"),
              ); // Show loading indicator
            }
            if (snapshot.hasError) {
              return const Text(
                  'Error'); // Show error message if there's an error
            }
            // Data is successfully retrieved, extract the username
            final username = snapshot.data!['username'];
            return Text(
              '${getLang(context, "hey")} $username',
              style: const TextStyle(fontSize: 18.0),
            ); // Show username in AppBar
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImageCarousel(),
            Container(
              margin: const EdgeInsets.all(10),
              height: 200.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 4,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.pets,
                          color: mainColor,
                        ),
                         Text(
                          getLang(context, 'pet'),
                          style: TextStyle(
                              color: mainColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddPetScreen(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.add,
                              color: mainColor,
                            ))
                      ],
                    ),
                  ),

                  ///
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('pets')
                        .where('owner_email', isEqualTo: user!.email)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(); // Show loading indicator
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      final petDocs = snapshot.data!.docs;
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: petDocs.map((doc) {
                            final petName = doc['name'];
                            final petImageUrl = doc['image_url'];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              width: 125,
                              height: 130,
                              child: Column(
                                children: [
                                  Container(
                                    width: 110,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        petImageUrl,
                                        fit: BoxFit
                                            .cover, // Ensure the image covers the entire container
                                      ),
                                    ),
                                  ),
                                  //SizedBox(height: 10),
                                  Text(
                                    petName,
                                    style: const TextStyle(
                                      color: mainColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AnimatedLocationWidget(
                      imageLink: imageIrbid,
                      name1: getLang(context, "loc2"),
                      name2: getLang(context, "track"),
                      uriMap: 'https://maps.app.goo.gl/UpPUAHcquV8Fx29v5'),
                  AnimatedLocationWidget(
                    imageLink: imageAmman,
                    name1: getLang(context, "loc1"),
                    name2: getLang(context, "track"),
                    uriMap: 'https://maps.app.goo.gl/GUddodUsCXedRXA7A',
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecommendationsScreen(),
                    ));
              },
              child: Container(
               margin: const EdgeInsets.all(10),
      //height: 200.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 4,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],),
                child:  ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  leading: Icon(Icons.pets),
                  title: Text(getLang(context, "recommendation"),),
                  subtitle: Text(
                    getLang(context, "rectitele"),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
