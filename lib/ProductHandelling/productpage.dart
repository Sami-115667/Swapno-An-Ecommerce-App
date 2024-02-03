import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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


  ProductData({
    required this.productname,
    required this.productdescription,
    required this.productprice,
    required this.productimage,
    required this.productimage1,
    required this.productimage2,
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
              // Handle add to cart button click
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
      String userName = userData['Product Name'];
      String userPrice = userData['Product Price'];
      String userDescription = userData['Product Description'];
      String userImage = userData['Product Image'];
      String userImage1 = userData['Product Image1'];
      String userImage2 = userData['Product Image2'];

      // print('User Name: $userName');
      // print('User Email: $userEmail');
      // print('User Phone: $userPhone');

      return ProductData(productname: userName, productdescription: userDescription, productprice: userPrice, productimage: userImage,productimage1: userImage1,productimage2: userImage2);
    } else {
      print('User not found');
      return null;
    }
  }





}