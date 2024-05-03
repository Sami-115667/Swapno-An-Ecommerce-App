import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Order/OrderPage.dart';
import '../ProductHandelling/productpage.dart';

class PurchasePage extends StatefulWidget {
  const PurchasePage({Key? key}) : super(key: key);

  @override
  State<PurchasePage> createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  int totalcost = 0;
  String order="";

  @override
  void initState() {
    super.initState();
    _calculateTotalCost(); // Calculate total cost initially
  }

  void _calculateTotalCost() {
    FirebaseFirestore.instance
        .collection('Cart')
        .where('User Id', isEqualTo: uid)
        .get()
        .then((querySnapshot) {
      int tempTotal = 0;
      String tempOrder = ""; // Initialize tempOrder string
      querySnapshot.docs.forEach((doc) {
        int productPrice = int.tryParse(doc['Product Price'] ?? '0') ?? 0;
        int productQuantity = int.tryParse(doc['Product Quantity'] ?? '0') ?? 0;
        String productName = doc['Product Name']; // Get product name from document
        tempTotal += (productPrice * productQuantity);
        tempOrder += productName + ", "; // Append product name to tempOrder
      });

      setState(() {
        totalcost = tempTotal;
        order = tempOrder.isNotEmpty ? tempOrder.substring(0, tempOrder.length - 2) : ""; // Remove trailing comma and space
      });
    }).catchError((error) {
      print('Error: $error');
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "PURCHASE",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.purple,
          actions: [],
          iconTheme: IconThemeData(color: Colors.white),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => PurchasePage(),
              //   ),
              // );

              _showAddressDialog(context);
            },
            child: Text('PROCEED TO BUY'),
          ),
        ),
        body: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  'TOTAL PRODUCTS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 250,
              width: double.infinity,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Cart')
                    .where('User Id', isEqualTo: uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      final cartData = snapshot.data?.docs[index];

                      return Container(
                        padding: EdgeInsets.all(10),
                        height: 100,
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(cartData?['Product Image'] ?? ''),
                              radius: 15,
                            ),
                            SizedBox(width: 2),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    cartData?['Product Name'] ?? '',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    '\$${cartData?['Product Price'] ?? ''}',
                                    style: TextStyle(color: Colors.grey, fontSize: 10),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // IconButton(
                                      //   icon: Icon(Icons.delete),
                                      //   iconSize: 10,
                                      //   onPressed: () {
                                      //     String deleteItem = '${cartData?['Product Id']}${cartData?['User Id']}';
                                      //     FirebaseFirestore.instance.collection('Cart').doc(deleteItem).delete();
                                      //   },
                                      // ),
                                      Row(
                                        children: [
                                          Text(
                                            "Quantity: " + (cartData?['Product Quantity'] ?? ''),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height:50,
              child: Text(
                "Total Cost: ${totalcost.toString()} TAKA",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

            ),
            SizedBox(
              height: 10,
            ),

            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Text(

                  'SUGGESTED PRODUCTS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              height: 200,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('All Products').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  var documents = snapshot.data?.docs;

                  return GridView.builder(
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0,
                        mainAxisExtent: 135
                    ),
                    //physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: documents?.length ?? 0,
                    itemBuilder: (context, index) {
                      var data = documents?[index].data() ?? Map<String, dynamic>();
                      double imageAspectRatio = 1.0; // Default aspect ratio
                      // Check if the image height and width are available in your data
                      if (data.containsKey('imageHeight') && data.containsKey('imageWidth')) {
                        imageAspectRatio = data['imageWidth'] / data['imageHeight'];
                      }


                      return GestureDetector(
                        onTap: () {
                          //  print('Tapped on product at index $index');
                          String documentId = snapshot.data?.docs[index].id ?? '';
                          //  print('Document ID: $documentId');
                          // Navigate to the product details page when tapped
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductPage(productId: documentId),

                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Card(

                            child: Container(
                              // height: 300,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 70.0,
                                      height: 40.0,
                                      child: Image.network(
                                        data?['Product Image'] ?? '',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text('${data?['Product Name'] ?? ''}\n৳${data?['Product Price'] ?? ''}',
                                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),)
                                      ),
                                    )

                                    // Add more widgets to display other data as needed
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _showAddressDialog(BuildContext context) {
    String address = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Delivery Address'),
          content: TextField(
            onChanged: (value) {
              address = value;
            },
            decoration: InputDecoration(labelText: 'Address'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (address.isNotEmpty) {
                  await _storeAddressInFirestore(address);
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrderPage()),
                  );
                } else {
                  // Show an error message or handle empty address
                }
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _storeAddressInFirestore(String address) async {
    try {
      await FirebaseFirestore.instance.collection('Orders').add({
        'userId': uid,
        'deliveryAddress': address,
        'totalcost': totalcost,
        'productnames': order,
        'orderstatus': "Pending",
        // Add other relevant order details
      });
      print('Address stored successfully in Firestore: $address');
    } catch (error) {
      print('Error storing address in Firestore: $error');
    }
  }
}

