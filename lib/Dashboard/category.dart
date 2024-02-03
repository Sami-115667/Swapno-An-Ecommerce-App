import 'package:flutter/material.dart';
import 'package:swapno/Category/categoriproductpage.dart';

class CategoryWidget extends StatelessWidget {
  final String categoryName;
  final String imageUrl;

  CategoryWidget({
    required this.categoryName,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryProductPage(categoryName: categoryName),
          ),
        );


        // Handle the click event here
        print('Category Clicked: $categoryName');
        // Add your navigation logic or other actions
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,  // Adjust the width as needed
              height: 50, // Adjust the height as needed
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              categoryName,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}