import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pethhealth/constant/color.dart';
import 'package:pethhealth/widget/custom_list_accessories.dart';

class AccessoriesScreen extends StatelessWidget {
  const AccessoriesScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('Accessories').get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: mainColor2));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SafeArea(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 225,
                ),
                // Number of items to display
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var document = snapshot.data!.docs[index];
                  return AccessoriesList(
                    imagePath: document['imagePath'],
                    name: document['name'], // Use the appropriate name
                    price: document['price'], // Use the appropriate price
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
