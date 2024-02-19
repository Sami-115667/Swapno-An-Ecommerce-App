import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    return SafeArea(
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
          child: Container(



            child: Text('Procced to buy'),
          ),
        ),
        body: Container(
          height: 350,
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
      ),
    );
  }
}
