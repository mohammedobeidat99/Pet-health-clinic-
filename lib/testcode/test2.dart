// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:pethhealth/constant/color.dart';
// import 'package:pethhealth/widget/custom_prodact.dart';

// class FoodScreen extends StatefulWidget {
//   const FoodScreen({Key? key}) : super(key: key);

//   @override
//   State<FoodScreen> createState() => _FoodScreenState();
// }

// class _FoodScreenState extends State<FoodScreen> {
//   List<Map<String, dynamic>> _cartItems = [];

//   void addToCart(String imagePath, String name, int price, int weight) {
//     setState(() {
//       bool found = false;
//       for (var item in _cartItems) {
//         if (item['name'] == name) {
//           item['quantity'] += 1;
//           found = true;
//           break;
//         }
//       }
//       if (!found) {
//         _cartItems.add({
//           'imagePath': imagePath,
//           'name': name,
//           'price': price,
//           'weight': weight,
//           'quantity': 1,
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Recommended Food',
//                   style: TextStyle(
//                     color: mainColor,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16.0,
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.all(7),
//                   decoration: BoxDecoration(
//                     color: mainColor,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   child: Text(
//                     'Check Retail Stores',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 10.0,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//           Expanded(
//             child: FutureBuilder(
//               future: FirebaseFirestore.instance.collection('foodpet').get(),
//               builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else {
//                   return SafeArea(
//                     child: GridView.builder(
//                       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         mainAxisExtent: 320,
//                       ),
//                       itemCount: snapshot.data!.docs.length,
//                       itemBuilder: (context, index) {
//                         var document = snapshot.data!.docs[index];
//                         return ProductCard(
//                           imagePath: document['imagePath'],
//                           name: document['name'],
//                           price: document['price'],
//                           weight: document['weight'],
//                           addToCart: addToCart,
//                         );
//                       },
//                     ),
//                   );
//                 }
//               },
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => CartScreen(cartItems: _cartItems),
//                 ),
//               );
//             },
//             child: Text('View Cart'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class CartScreen extends StatelessWidget {
//   final List<Map<String, dynamic>> cartItems;

//   const CartScreen({Key? key, required this.cartItems}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Shopping Cart'),
//       ),
//       body: ListView.builder(
//         itemCount: cartItems.length,
//         itemBuilder: (context, index) {
//           var item = cartItems[index];
//           return ListTile(
//             leading: Image.network(item['imagePath']),
//             title: Text(item['name']),
//             subtitle: Text('${item['weight']} Kg - ${item['price']} JOD'),
//             trailing: Text('Quantity: ${item['quantity']}'),
//           );
//         },
//       ),
//     );
//   }
// }

// Widget ProductCard({
//   required String imagePath,
//   required String name,
//   required int price,
//   required int weight,
//   required Function(String, String, int, int) addToCart,
// }) {
//   return Padding(
//     padding: const EdgeInsets.all(8.0),
//     child: Stack(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: Colors.grey.withOpacity(0.2)),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.5),
//                 spreadRadius: 2,
//                 blurRadius: 5,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 margin: const EdgeInsets.all(18.0),
//                 width: 150,
//                 height: 120,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Image.network(
//                     imagePath,
//                     width: double.infinity,
//                     height: double.infinity,
//                     fit: BoxFit.fill,
//                   ),
//                 ),
//               ),
//               Text(
//                 name,
//                 style: const TextStyle(
//                   fontSize: 18.0,
//                   color: mainColor,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 5),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Text(
//                     "${weight} Kg",
//                     style: const TextStyle(
//                       fontSize: 15.0,
//                       color: Colors.blueGrey,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   Text(
//                     "${price} JOD",
//                     style: const TextStyle(
//                       fontSize: 15.0,
//                       color: Colors.blueGrey,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 15.0),
//               ElevatedButton.icon(
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all(mainColor),
//                 ),
//                 onPressed: () {
//                   addToCart(imagePath, name, price, weight);
//                 },
//                 label: const Text(
//                   'Add Cart',
//                   style: TextStyle(color: Colors.white),
//                 ),
//                 icon: const Icon(
//                   Icons.shopping_bag_outlined,
//                   color: Colors.white,
//                 ),
//               )
//             ],
//           ),
//         ),
//         Align(
//           alignment: Alignment.topLeft,
//           child: Container(
//             width: 70.0,
//             padding: const EdgeInsets.all(4),
//             decoration: const BoxDecoration(
//               color: Color.fromARGB(146, 243, 117, 108),
//               borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
//             ),
//             child: const Text(
//               'Certified',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
