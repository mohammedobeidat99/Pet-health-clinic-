import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:pethhealth/constant/color.dart';

class CartFoodScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  //final String userEmail; // Add user email

  const CartFoodScreen({
    Key? key,
    required this.cartItems,
  }) : super(key: key);

  @override
  _CartFoodScreenState createState() => _CartFoodScreenState();
}

class _CartFoodScreenState extends State<CartFoodScreen> {
  TextEditingController discountController = TextEditingController();

  void updateQuantity(int index, int newQuantity) {
    setState(() {
      widget.cartItems[index]['quantity'] = newQuantity;
    });
  }

  void removeFromCart(int index) {
    setState(() {
      widget.cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Food Cart',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          //SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: mainColor),
                ),
                Text(
                  calculateTotal().toStringAsFixed(2) + ' JOD',
                  style: TextStyle(
                    color: mainColor2,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                var item = widget.cartItems[index];
                return Dismissible(
                  key: Key(item['name']),
                  onDismissed: (direction) {
                    removeFromCart(index);
                  },
                  background: Container(color: Colors.red),
                  child: Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 12, horizontal: 2),
                    child: ListTile(
                      leading: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(item['imagePath']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        item['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        ' ${item['price']} JOD ',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              if (item['quantity'] > 1) {
                                updateQuantity(index, item['quantity'] - 1);
                              }
                            },
                          ),
                          Text(
                            '${item['quantity']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              updateQuantity(index, item['quantity'] + 1);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              removeFromCart(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          uploadToFirestore(); // Call function to upload to Firestore
        },
        label: Text('Checkout'),
        icon: Icon(Icons.shopping_cart),
        backgroundColor: mainColor,
      ),
    );
  }

  double calculateTotal() {
    double total = 0;
    widget.cartItems.forEach((item) {
      total += item['price'] * item['quantity'];
    });
    return total;
  }

  void uploadToFirestore() async {
    try {
      // Create a list to hold the details of each product in the order
      List<Map<String, dynamic>> products = [];

      // Add details of each product to the list
      widget.cartItems.forEach((item) {
        products.add({
          'name': item['name'],
          'price': item['price'],
          'quantity': item['quantity'],
        });
      });

      

      // Upload order details to Firestore
      await FirebaseFirestore.instance.collection('orders').add({
        'user_email': FirebaseAuth.instance.currentUser!.email,
        'products': products,
        'total_price': calculateTotal(),
        'timestamp': Timestamp.now(),
      });

      // Clear the cart after uploading to Firestore
      widget.cartItems.clear();
      setState(() {});

      // Show success notification
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            'Your products have been sent successfully. We will contact you soon. Thank you.'),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      print('Error uploading to Firestore: $e');
      // Show error notification
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred. Please try again later.'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
