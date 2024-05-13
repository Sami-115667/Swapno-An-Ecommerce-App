


import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swapno/Login_Signup/loginpage.dart';
import 'package:swapno/Order/OrderPage.dart';

import '../Cart/cartpage.dart';
import '../Firebase/firebaseauthservices.dart';
import '../ProductHandelling/productpage.dart';
import '../Profile/profilepage.dart';
import '../Search/searchpage.dart';
import 'category.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}



class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final FirebaseAuthServices _authenticationService = FirebaseAuthServices();


  final CarouselController _carouselController = CarouselController();
  int _currentIndex = 0;


  int currentIndex = 0;


  void bottomchange(int index) {
    if (index ==1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CartPage(),
        ),
      );
    } else if (index == 2) {
      // Navigate to the Profile page
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OrderPage()));

    }

    else if (index == 3) {
      // Navigate to the Profile page
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfilePage()));

    }

  }


  @override
  Widget build(BuildContext context) {



    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App'),
            content: Text('Are you sure you want to exit the app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes'),
              ),
            ],
          ),
        ) ?? false;
      },
      child: SafeArea(
        child: Scaffold(

          appBar: AppBar(
            title: Text("Home",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
            backgroundColor: Colors.purple,
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'logout') {
                    // Handle logout action
                    // For example, log out the user and navigate to login screen
                    // Your logout logic goes here
                  }
                },
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: Row(
                        children: [
                          Icon(Icons.logout),
                          SizedBox(width: 8),
                          Text('Logout'),
                        ],
                      ),
                    ),
                  ];
                },
              ),
              IconButton(
                onPressed: () {
                  // Handle notifications button press
                  // For example, show notifications
                },
                icon: const Icon(Icons.notifications, color: Colors.white),
              ),
              // IconButton(
              //   onPressed: () {
              //     // Handle filter button press
              //   },
              //   icon: const Icon(Icons.filter_alt),
              // ),
            ],

            iconTheme: IconThemeData(color: Colors.white),
          ),

          drawer: Drawer(
            backgroundColor: Colors.white,
            child: ListView(
              padding: EdgeInsets.all(0),
              children: [
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    var userData = snapshot.data!.data() as Map<String, dynamic>?; // Explicit cast
                    if (userData == null) {
                      return SizedBox(); // Return an empty widget if userData is null
                    }
                    var name = userData['name'] as String?;
                    var email = userData['email'] as String?;
                    var profileImageUrl = userData['Image'] as String?;

                    return UserAccountsDrawerHeader(
                      accountName: Text(name ?? ''),
                      accountEmail: Text(email ?? ''),
                      decoration: BoxDecoration(color: Colors.purple),
                      currentAccountPicture: Container(
                        width: 100.0,
                        height: 100.0,
                        child: Align(
                          alignment: Alignment.center,
                          child: ClipOval(
                            child: Image.network(
                              profileImageUrl ?? '',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text("Home"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.shopping_bag),
                  title: Text("Order"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text("Cart"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Profile"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                  onTap: () {
                    signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                          (route) => false, // Remove all routes from the stack.
                    );
                  },
                )
              ],
            ),
          ),



          bottomNavigationBar: BottomNavigationBar(
            iconSize: 30,
            showUnselectedLabels: true,
            selectedItemColor: Colors.blue,
            elevation: 100, // Change the selected item icon color
            unselectedItemColor:
            Colors.black, // Change the unselected item icon color
            currentIndex: currentIndex, // Use currentIndex here
            onTap: (int index) {
              setState(() {
                currentIndex = index; // Update currentIndex when an item is tapped
                bottomchange(currentIndex);

              });
            },


            items: const [

              BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard), label: "Dashboard"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart), label: "Cart"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag), label: "Order"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Profile"
              ),
              // BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
            ],
          ),

          body: Container(
            color: Colors.white38,

            child: Column(

              children: [

                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage()));
                  },
                  child: Container(
                    color: Colors.white38,
                    height: 55,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage()));
                                },
                                decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.search),
                                  hintText: "Search here...",
                                  alignLabelWithHint: true,
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 14.3),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black, width: 5.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  counterText: "",
                                  suffixIconConstraints: BoxConstraints(minWidth: 40),
                                  prefixIconConstraints: BoxConstraints(minWidth: 40),
                                  counterStyle: TextStyle(fontSize: 0),
                                  hintMaxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),



                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [

                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(

                              'TOP PRODUCTS',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 130,

                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('All Products')
                                .where('ProductType', isEqualTo: 'Top')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              }
                              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                return Center(child: Text('No data available'));
                              }

                              var imageDocuments = snapshot.data!.docs;
                              List<String> imageUrls = [];

                              for (var document in imageDocuments) {
                                var imageUrl = document['ProductImage'];
                                imageUrls.add(imageUrl);
                              }

                              return Column(
                                children: [
                                  CarouselSlider(
                                    items: imageUrls.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final imageUrl = entry.value;
                                      return GestureDetector(
                                        onTap: () {
                                          final documentId = imageDocuments[index].id;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ProductPage(productId: documentId),
                                            ),
                                          );
                                          print('Image clicked: $imageUrl');
                                        },
                                        child: Image.network(imageUrl),
                                      );
                                    }).toList(),
                                    carouselController: _carouselController,
                                    options: CarouselOptions(
                                      height: 100.0,
                                      autoPlay: true,
                                      autoPlayInterval: Duration(seconds: 3),
                                      aspectRatio: 16 / 9,
                                      onPageChanged: (index, reason) {
                                        _currentIndex = index;
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              );
                            },
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

                              'CATEGORIES',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),

                        Container(
                          width: double.infinity,
                          height: 130,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('Category').snapshots(),
                            builder: (context, snapshot) {
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

                              var documents = snapshot.data?.docs;

                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: documents!.length,
                                itemBuilder: (context, index) {
                                  var document = documents[index];
                                  return CategoryWidget(
                                    categoryName: document['Name'],
                                    imageUrl: document['Image'],
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

                              'DISCOUNT PRODUCTS',
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
                        height: 400,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('All Products')
                              .where('ProductType', isEqualTo: 'Discount')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            }

                            var documents = snapshot.data?.docs;

                            return GridView.builder(
                              scrollDirection: Axis.horizontal,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
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
                                                width: 80.0,
                                                height: 50.0,
                                                child: Image.network(
                                                  data?['ProductImage'] ?? '',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(15),
                                                child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text('${data?['ProductName'] ?? ''}\n৳${data?['ProductPrice'] ?? ''}',
                                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),)
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



                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(

                              'ALL PRODUCTS',
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
                        StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('All Products').snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            }

                            var documents = snapshot.data?.docs;

                            return GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 0,
                                  mainAxisSpacing: 6.0,
                                  mainAxisExtent: 250
                              ),
                              physics: NeverScrollableScrollPhysics(),
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
                                                width: 100.0,
                                                height: 100.0,
                                                child: Image.network(
                                                  data?['ProductImage'] ?? '',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(15),
                                                child: Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text('${data?['ProductName'] ?? ''}\n৳${data?['ProductPrice'] ?? ''}',
                                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)
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
                      ],
                    ),
                  ),
                )







              ],

            ),
          ),


        ),
      ),
    );
  }




  void signOut() async {
    await _authenticationService.signOut();

    print('User signed out successfully.');
  }

}