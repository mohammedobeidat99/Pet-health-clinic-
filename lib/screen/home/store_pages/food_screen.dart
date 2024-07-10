// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/widgets.dart';
// import 'package:pethhealth/components/applocal.dart';
// import 'package:pethhealth/constant/color.dart';
// import 'package:pethhealth/widget/custom_prodact.dart'; // Make sure this is the correct path

// class FoodScreen extends StatefulWidget {
//   const FoodScreen({Key? key}) : super(key: key);

//   @override
//   State<FoodScreen> createState() => _FoodScreenState();
// }

// class _FoodScreenState extends State<FoodScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Column(
//       children: [
//         Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   getLang(context, "recfood"),
//                   style: TextStyle(
//                       color: mainColor,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 16.0),
//                 ),
//                 Container(
//                   padding: EdgeInsets.all(7),
//                   decoration: BoxDecoration(
//                       color: mainColor,
//                       borderRadius: BorderRadius.circular(10)),
//                   child: Text(getLang(context, "check"),
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                           fontSize: 10.0)),
//                 )
//               ],
//             )),
//         Expanded(
//           child: FutureBuilder(
//             future: FirebaseFirestore.instance.collection('foodpet').get(),
//             builder:
//                 (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(
//                     child: CircularProgressIndicator(
//                   color: mainColor2,
//                 ));
//               } else if (snapshot.hasError) {
//                 return Center(child: Text('Error: ${snapshot.error}'));
//               } else {
//                 return SafeArea(
//                   child: GridView.builder(
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       mainAxisExtent: 320,
//                     ),
//                     itemCount: snapshot.data!.docs.length,
//                     itemBuilder: (context, index) {
//                       var document = snapshot.data!.docs[index];
//                       return ProductCard(
//                         context: context,
//                         imagePath: document['imagePath'],
//                         name: document['name'],
//                         price: document['price'],
//                         weight: document['weight'],
//                       );
//                     },
//                   ),
//                 );
//               }
//             },
//           ),
//         ),
//       ],
//     ));
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pethhealth/constant/color.dart';
import 'package:pethhealth/screen/home/store_pages/cart_screen.dart';
import 'package:pethhealth/widget/custom_prodact.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({Key? key}) : super(key: key);

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  List<Map<String, dynamic>> _cartItems = [];

  void addToCart(String imagePath, String name, int price, int weight) {
    setState(() {
      bool found = false;
      for (var item in _cartItems) {
        if (item['name'] == name) {
          item['quantity'] += 1;
          found = true;
          break;
        }
      }
      if (!found) {
        _cartItems.add({
          'imagePath': imagePath,
          'name': name,
          'price': price,
          'weight': weight,
          'quantity': 1,
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recommended Food',
                  style: TextStyle(
                    color: mainColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CartFoodScreen(cartItems: _cartItems,),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.shopping_cart_checkout,
                      color: mainColor,
                    )),
                Container(
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Check Retail Stores',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 10.0,
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: FirebaseFirestore.instance.collection('foodpet').get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return SafeArea(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 320,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var document = snapshot.data!.docs[index];
                        return ProductCard(
                          imagePath: document['imagePath'],
                          name: document['name'],
                          price: document['price'],
                          weight: document['weight'],
                          addToCart: addToCart,
                          context: context,
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
