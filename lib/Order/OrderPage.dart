import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Dashboard/homepage.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        // Navigate to your desired page here
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        return true; // Return true to prevent default back button behavior
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "ORDER",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.purple,
            actions: [],
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Orders')
                .where('userId', isEqualTo: uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              // If there's no data, display a message
              if (snapshot.data?.docs.isEmpty ?? true) {
                return Center(child: Text('No orders available'));
              }

              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  // Extract data from each document
                  var orderData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  String productName = orderData['productnames'];
                  int totalCost = orderData['totalcost'];
                  String status = orderData['orderstatus'];
                  String deliveryAddress = orderData['deliveryAddress'];

                  // Determine the text color based on order status
                  Color statusColor = Colors.black;
                  if (status == 'Pending') {
                    statusColor = Colors.red;
                  } else if (status == 'Delivered') {
                    statusColor = Colors.green;
                  } else if (status == 'in progress') {
                    statusColor = Colors.black;
                  }

                  // Build a widget to display order information
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productName,
                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                                ),
                                Text('Delivery Address: $deliveryAddress'),
                                Text(
                                  'Total Cost: ',
                                  style: TextStyle(fontWeight: FontWeight.normal),
                                ),
                                Text('$totalCost Taka', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                              ],
                            ),
                          ),
                          Text(
                            status,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,fontSize: 14
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
        ),
      ),
    );
  }
}
