import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pethhealth/constant/color.dart';
import 'package:pethhealth/widget/custom_list_games.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('gamespet').get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: mainColor2));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SafeArea(
              child: ListView.builder(
              
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var document = snapshot.data!.docs[index];
                  return ListGame(
                    discount: document['discount'],
                    ratings: document['ratings'],
                    imagePath: document['imagePath'],
                    name: document['name'],
                    price: document['price'],
                    des: document['des'],
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
