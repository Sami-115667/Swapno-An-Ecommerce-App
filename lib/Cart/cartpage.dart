import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Dashboard/homepage.dart';
import '../ProductHandelling/productpage.dart';
import '../Purchase/purchagepage.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});
  //final String productId;

  // CartPage({required this.productId});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  int totalcost = 0;

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
            title: Text("My Cart",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            backgroundColor: Colors.purple,
            actions: [],
            iconTheme: IconThemeData(color: Colors.white),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {


                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PurchasePage(),
                  ),
                );
              },

              child: Text('BUY PRODUCTS'),
            ),
          ),
          body: Column(
            children: [

              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(

                    'BUY PRODUCTS',
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
                height: 400,
                width: double.infinity,
                child:StreamBuilder<QuerySnapshot>(
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
                    final cartDocs = snapshot.data?.docs ?? [];
                    List<int> quantities = List.filled(cartDocs.length, 1);

                    return ListView.builder(
                      itemCount: cartDocs.length,
                      itemBuilder: (context, index) {
                        final cartData = cartDocs[index];
                        int quantity = quantities[index];

                        return Container(

                          padding: EdgeInsets.all(10),
                          height: 140,
                          child: Row(
                            children: [

                              CircleAvatar(
                                backgroundImage:
                                NetworkImage(cartData['Product Image'] ?? ''),
                                radius: 35,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(



                                      cartData['Product Name'] ?? '',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    ),
                                    Text(
                                      '\$${cartData['Product Price'] ?? ''}',
                                      style: TextStyle(color: Colors.grey, fontSize: 16),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.delete),
                                          onPressed: () {
                                            String deleteItem =
                                                '${cartData['Product Id']}${cartData['User Id']}';
                                            FirebaseFirestore.instance
                                                .collection('Cart')
                                                .doc(deleteItem)
                                                .delete();
                                          },
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.remove),
                                              onPressed: () {
                                                String deleteItem =
                                                    '${cartData['Product Id']}${cartData['User Id']}';
                                                String q =  '${cartData['Product Quantity']}';
                                                int quantity = int.parse(q);
                                                if(quantity>1){
                                                  quantity--;
                                                  q=quantity.toString();
                                                  FirebaseFirestore.instance.collection("Cart").doc(deleteItem).update({
                                                    'Product Quantity': q,
                                                  });
                                                }
                                              },
                                            ),
                                            Text(
                                              cartData['Product Quantity'] ?? '',
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.add),
                                              onPressed: () {
                                                String deleteItem =
                                                    '${cartData['Product Id']}${cartData['User Id']}';
                                                String q =  '${cartData['Product Quantity']}';
                                                int quantity = int.parse(q);
                                                quantity++;
                                                q=quantity.toString();
                                                FirebaseFirestore.instance.collection("Cart").doc(deleteItem).update({
                                                  'Product Quantity': q,
                                                });

                                              },
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
                height: 150,
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
      ),
    );
  }
}
