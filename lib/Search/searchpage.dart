import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ProductHandelling/productpage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  late List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _performSearch(''); // Call performSearch with an empty query initially
  }

  void _performSearch(String query) {
    // Convert the query to lowercase for case-insensitive search
    String formattedQuery = query.toLowerCase();

    // Implement your Firestore search logic here
    // For demonstration, let's assume you have a 'All Products' collection
    FirebaseFirestore.instance
        .collection('All Products')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        _searchResults = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .where((data) =>
        data['Product Name'].toString().toLowerCase().contains(formattedQuery) ||
            data['Product Category'].toString().toLowerCase().contains(formattedQuery))
            .toList();
      });
    });
  }




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              color: Colors.white38,
              height: 55,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _searchController,
                          onChanged: (value) {
                            _performSearch(value);
                          },
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () {
                                // Handle tap on the search icon here
                                print('Search icon tapped');
                              },
                              child: Icon(Icons.search),
                            ),
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
            Expanded(
              child: SingleChildScrollView(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 1.0,
                    mainAxisSpacing: 8.0,
                    mainAxisExtent: 250,
                  ),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    var data = _searchResults[index];
                    double imageAspectRatio = 1.0; // Default aspect ratio
                    // Check if the image height and width are available in your data
                    if (data.containsKey('imageHeight') && data.containsKey('imageWidth')) {
                      imageAspectRatio = data['imageWidth'] / data['imageHeight'];
                    }
                
                    return GestureDetector(
                      onTap: () {
                        // Navigate to the product details page when tapped
                        // Replace this with your navigation logic
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductPage(productId: data['All Product Id']),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Card(
                          child: Container(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 100.0,
                                    height: 100.0,
                                    child: Image.network(
                                      data['Product Image'] ?? '',
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
                                      child: Text(
                                        '${data['Product Name'] ?? ''}\n৳${data['Product Price'] ?? ''}',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
