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

  // void _cancelOrder(String orderId) {
  //   // Perform cancellation logic here
  //   // For example, you can update the order status to "Cancelled"
  //   FirebaseFirestore.instance.collection('Orders').doc(orderId).update({
  //     'orderstatus': 'Cancelled',
  //   }).then((_) {
  //     // Show a confirmation message or handle the cancellation
  //     print('Order cancelled successfully');
  //   }).catchError((error) {
  //     // Handle error if cancellation fails
  //     print('Error cancelling order: $error');
  //   });
  // }

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
                  String orderId = snapshot.data!.docs[index].id; // Get the order ID
                  String productName = orderData['productnames'];
                  int totalCost = orderData['totalcost'];
                  String status = orderData['orderstatus'];
                  String deliveryAddress = orderData['deliveryAddress'];

                  // Extract orderDateTime if available
                  Timestamp? orderDateTime = orderData['orderDateTime'] as Timestamp?;

                  // Determine the text color based on order status
                  Color statusColor = Colors.black;
                  if (status == 'Pending') {
                    statusColor = Colors.red;
                  } else if (status == 'Delivered') {
                    statusColor = Colors.green;
                  } else if (status == 'In Progress') {
                    statusColor = Colors.blue;
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
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text('Delivery Address: $deliveryAddress'),
                                Text(
                                  'Total Cost: ',
                                  style: TextStyle(fontWeight: FontWeight.normal),
                                ),
                                Text('$totalCost Taka', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                                if (orderDateTime != null)
                                  Text('Order Date: ${orderDateTime.toDate().toString()}', style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),),
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
                          if (status == 'Pending') // Show cancel button only if the order is pending
                            IconButton(
                              onPressed: () {
                                _showCancelConfirmationDialog(context, orderId);
                              },
                              icon: Icon(Icons.cancel),
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



  void _showCancelConfirmationDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cancel Order'),
          content: Text('Are you sure you want to cancel this order?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Dismiss the dialog and return false
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Dismiss the dialog and return true
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    ).then((confirmed) {
      if (confirmed ?? false) {
        _cancelOrder(orderId); // Cancel the order if confirmed
      }
    });
  }

  void _cancelOrder(String orderId) {
    // Perform cancellation logic here
    // For example, you can update the order status to "Cancelled"
    FirebaseFirestore.instance.collection('Orders').doc(orderId).update({
      'orderstatus': 'Cancelled',
    }).then((_) {
      // Show a confirmation message or handle the cancellation
      print('Order cancelled successfully');
    }).catchError((error) {
      // Handle error if cancellation fails
      print('Error cancelling order: $error');
    });
  }

}
