import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pethhealth/constant/color.dart'; 

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Order History', style: TextStyle(fontWeight: FontWeight.w600),),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('user_email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No orders found.'),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var order = snapshot.data!.docs[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.history_outlined, color: mainColor2,),
                          SizedBox(width: 5,), 
                          Text(
                            'Order ${index + 1}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: mainColor2
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Date: ${order['timestamp'].toDate()}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Total: ${order['total_price']} JOD',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Products:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: mainColor2
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: (order['products'] as List<dynamic>)
                            .map((product) => Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2),
                                  child: Text(
                                    '${product['name']} - Quantity: ${product['quantity']} - Price: ${product['price']} JOD',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Status: Not Delivered Yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red, // Display status in red color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Expected Arrival: ${_calculateExpectedArrival(order['timestamp'].toDate())}',
                        style: TextStyle(
                          fontSize: 16,
                          color: mainColor2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _calculateExpectedArrival(DateTime orderDate) {
    DateTime expectedDate = orderDate.add(Duration(days: 2)); // Assuming 48 hours delivery time
    Duration difference = expectedDate.difference(DateTime.now());
    if (difference.isNegative) {
      return 'Already Delivered';
    } else {
      int hours = difference.inHours;
      int minutes = difference.inMinutes % 60;
      return '${hours}h ${minutes}m';
    }
  }
}
