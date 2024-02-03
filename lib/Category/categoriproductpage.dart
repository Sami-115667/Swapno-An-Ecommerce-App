import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../ProductHandelling/productpage.dart';


class CategoryProductPage extends StatefulWidget {
  final String categoryName;

  const CategoryProductPage({super.key, required this.categoryName});




  @override
  State<CategoryProductPage> createState() => _CategoryProductPageState();
}

class _CategoryProductPageState extends State<CategoryProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('All Products').where('Product Category', isEqualTo: widget.categoryName).snapshots(),
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


      ),
    );
  }
}
