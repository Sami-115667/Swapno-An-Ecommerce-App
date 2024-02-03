


import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  final CarouselController _carouselController = CarouselController();
  int _currentIndex = 0;


  int currentIndex = 0;


  void bottomchange(int index) {
    if (index == 0) {
      // Navigate to the Home page (if needed)
      // You can replace this with the appropriate route for your Home page.
    } else if (index == 2) {
      // Navigate to the Profile page
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfilePage()));

    }
  }


  @override
  Widget build(BuildContext context) {



    return SafeArea(
      child: Scaffold(

        appBar: AppBar(
          title: Text("Home",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
          backgroundColor: Colors.purple,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.settings,color: Colors.white,)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.notifications,color: Colors.white,)),
            //IconButton(onPressed: () {}, icon: const Icon(Icons.filter_alt)),
          ],
          iconTheme: IconThemeData(color: Colors.white),
        ),

        drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.all(0),
            children: [
              /*    child: Column(
              children: [
                    ClipOval(child: Image(image: AssetImage('assets/d.png'),fit:BoxFit.contain,width: 80,height: 80,
                    )),
                Padding(padding: EdgeInsets.all(15.0),
                  child: Text("Profile",),)
              ],
            )*/

              UserAccountsDrawerHeader(
                accountName: Text("Md Shamsur Rahman Sami"),
                accountEmail: Text("shamsurrahman07052001@gmail.com"),
                decoration: BoxDecoration(color: Colors.purple),
                currentAccountPicture: Container(
                  width: 80.0,
                  height: 80.0,
                  child: Align(
                    alignment: Alignment.center,
                    child: ClipOval(
                      child: Image(
                        image: AssetImage('assets/d.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text("Home"),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.dashboard),
                title: Text("Dashboard"),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.task),
                title: Text("Notes"),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.calculate),
                title: Text("Calculator"),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Logout"),
                onTap: () {
                  signOut();

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
                          stream: FirebaseFirestore.instance.collection('Top Products').snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CircularProgressIndicator();
                            }
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                              return Center(child: Text('No data available'));
                            }

                            var imageDocuments = snapshot.data!.docs;
                            List<String> imageUrls = [];

                            for (var document in imageDocuments) {
                              var imageUrl = document['Image'];
                              imageUrls.add(imageUrl);
                            }

                            return Column(
                              children: [
                                CarouselSlider(
                                  items: imageUrls.map((imageUrl) {
                                    return GestureDetector(
                                      onTap: () {
                                        // Handle image click as needed
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
                                      // Use the index directly
                                      _currentIndex = index;

                                      //  setState(() { });
                                      // print('$_currentIndex');

                                    },
                                  ),
                                ),
                                SizedBox(height: 20),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: List.generate(imageUrls.length, (index) {
                                //     return GestureDetector(
                                //       onTap: () {
                                //         // Handle dot click as needed
                                //         print('Dot clicked: $index');
                                //         print('$_currentIndex');
                                //        // _carouselController.animateToPage(index);
                                //       },
                                //       child: Container(
                                //         width: 8,
                                //         height: 8,
                                //         margin: EdgeInsets.symmetric(horizontal: 2),
                                //         decoration: BoxDecoration(
                                //           shape: BoxShape.circle,
                                //           color: index == _currentIndex ? Colors.blue : Colors.grey,
                                //         ),
                                //       ),
                                //     );
                                //   }),
                                // ),

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
                                crossAxisSpacing: 1.0,
                                mainAxisSpacing: 8.0,
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
                                                data?['Product Image'] ?? '',
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
                                                  child: Text('${data?['Product Name'] ?? ''}\n৳${data?['Product Price'] ?? ''}',
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
    );
  }




  void signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('User signed out successfully.');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

}