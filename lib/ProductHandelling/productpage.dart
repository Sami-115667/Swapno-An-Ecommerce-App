import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';

import 'package:swapno/Cart/cartpage.dart';

class Product extends StatelessWidget {
  const Product({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductPage(productId: '',),
      debugShowCheckedModeBanner: false,
    );
  }
}


class ProductPage extends StatefulWidget {
  //const ProductPage({super.key});
  final String productId;

  ProductPage({required this.productId});




  @override
  State<ProductPage> createState() => _ProductPageState();
}




class ProductData {
  final String productname;
  final String productdescription;
  final String productprice;
  final String productimage;
  final String productimage1;
  final String productimage2;
  final String productid;

  final String productcategory;


  ProductData({
    required this.productname,
    required this.productdescription,
    required this.productprice,
    required this.productimage,
    required this.productimage1,
    required this.productimage2,
    required this.productid, required this.productcategory,
  });
}





class _ProductPageState extends State<ProductPage> {


  ProductData? data;


  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    // Call the retrieveUserData function when the widget is initialized
    fetchData();
  }

  // Function to call retrieveUserData and update the state with the retrieved data
  Future<void> fetchData() async {
    ProductData? user = await retrieveUserData();
    if (user != null) {
      setState(() {
        data = user;
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Items",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
          backgroundColor: Colors.purple,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.favorite,color: Colors.white,)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart,color: Colors.white,)),
            //IconButton(onPressed: () {}, icon: const Icon(Icons.filter_alt)),
          ],
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,

          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  child: CarouselSlider(
                    items: [
                      Image.network(data?.productimage ?? ''),
                      Image.network(data?.productimage1 ?? ''),
                      Image.network(data?.productimage2 ?? ''),
                    ],
                    options: CarouselOptions(
                      height: 200.0,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      aspectRatio: 17 / 9,
                      onPageChanged: (index, reason) {
                        // Handle page change if needed
                      },
                      
                      // Add dot indicator
                      enableInfiniteScroll: true,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      viewportFraction: 0.8,
                      //aspectRatio: 2.0,
                      // onPageChanged: (index, reason) {
                      //   // Handle page change if needed
                      // },
                    ),
                  ),
                ),
            
            
            
            
            
            
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all( 10),
                    child: Text('${data?.productprice} টাকা' ?? 'No Description' ,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22,color: Colors.green),),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(data?.productname ?? 'No name',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  ),
                ),
            
            
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all( 10),
                    child: Text('Product Description:\n${data?.productdescription} ' ?? 'No Description' ,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 18,color: Colors.black),),
                  ),
                ),
            
              ],
            ),
          ),




        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              onPressed: () {
                String? uid = FirebaseAuth.instance.currentUser?.uid;

                FirebaseFirestore.instance.collection("Cart").doc(widget.productId + uid!).set({
                  'Product Name': data?.productname,
                  'Product Description': data?.productdescription,
                  'Product Price': data?.productprice,
                  'Product Image': data?.productimage,
                  'Product Image1': data?.productimage1,
                  'Product Image2': data?.productimage2,
                  'Product Id': data?.productid,
                  'Product Category': data?.productcategory, // Is 'Product Category' supposed to be the same as 'Product Id'?
                  'User Id': uid,
                  'Product Quantity': "1",// Is 'Product Category' supposed to be the same as 'Product Id'?
                }).then((value) {
                  // Document added successfully
                  print('Product added to cart successfully!');
                }).catchError((error) {
                  // Error adding document
                  print('Failed to add product to cart: $error');
                });

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(),
                  ),
                );
              },

              child: Text('Add to Cart'),
          ),
        ),

























      ),

    );

  }



  Future<ProductData?> retrieveUserData() async {
    // try {
    //   String? userId = FirebaseAuth.instance.currentUser?.uid;
    //   if (userId == null) {
    //     print('User not authenticated');
    //     return null;
    //   }
    //print(widget.productId + "sasssami");

    DocumentSnapshot userSnapshot =
    await FirebaseFirestore.instance.collection('All Products').doc(widget.productId).get();

    // Check if the document exists
    if (userSnapshot.exists) {
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
      // Access specific fields from userData
      String userName = userData['ProductName'];
      String userPrice = userData['ProductPrice'];
      String userDescription = userData['ProductDescription'];
      String userImage = userData['ProductImage'];
      String userImage1 = userData['ProductImage1'];
      String userImage2 = userData['ProductImage2'];
      String userProductId = userData['AllProductId'];
      String userProductCategory = userData['ProductCategory'];

      // print('User Name: $userName');
      // print('User Email: $userEmail');
      // print('User Phone: $userPhone');

      return ProductData(productname: userName, productdescription: userDescription, productprice: userPrice, productimage: userImage
          ,productimage1: userImage1,productimage2: userImage2,productid: userProductId,productcategory: userProductCategory);
    } else {
      print('User not found');
      return null;
    }
  }





}