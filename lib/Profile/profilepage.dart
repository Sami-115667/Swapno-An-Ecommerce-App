import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swapno/Dashboard/homepage.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class UserData {
  final String name;
  final String email;
  final String phone;
  final String image;

  UserData({
    required this.name,
    required this.email,
    required this.phone,
    required this.image,
  });
}

class _ProfilePageState extends State<ProfilePage> {
  late String ProfileImage = '';
  UserData? dataa;

  @override
  void initState() {
    super.initState();
    // Call the retrieveUserData function when the widget is initialized
    fetchData();
  }

  // Function to call retrieveUserData and update the state with the retrieved data
  Future<void> fetchData() async {
    UserData? user = await retrieveUserData();
    if (user != null) {
      setState(() {
        dataa = user;
      });
    }
  }

  File? pickedImage;

  void imagePickerOption() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Photo Library'),
                onTap: () {
                  pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String?> uploadImageToFirebaseStorage(XFile imageFile) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Upload image to Firebase Storage
      Reference storageReference = FirebaseStorage.instance.ref().child('user_images').child('$userId.jpg');
      UploadTask uploadTask = storageReference.putFile(File(imageFile.path));
      TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      // Update image URL in Firestore
      await FirebaseFirestore.instance.collection('Users').doc(userId).update({'Image': imageUrl});

      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);

      setState(() {
        pickedImage = File(pickedFile!.path);
      });

      if (pickedImage != null) {
        // Upload the picked image to Firebase Storage and update Firestore
        String? imageUrl = await uploadImageToFirebaseStorage(pickedFile!);
        if (imageUrl != null) {
          print('Image uploaded successfully. URL: $imageUrl');
          // Optionally, you can update the UI with the new image
        } else {
          print('Failed to upload image.');
          // Handle failure if needed
        }
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }


  // Future<void> pickImage(ImageSource source) async {
  //   try {
  //     final pickedFile = await ImagePicker().pickImage(source: source);
  //
  //     setState(() {
  //       pickedImage = File(pickedFile!.path);
  //     });
  //   } catch (e) {
  //     print('Error picking image: $e');
  //   }
  // }

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
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Profile"),
        ),
        body: FutureBuilder<UserData?>(
          future: retrieveUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              dataa = snapshot.data;
              return SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: imagePickerOption,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: ClipOval(
                                child: pickedImage != null
                                    ? Image.file(
                                  pickedImage!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                                    : dataa != null && dataa!.image.isNotEmpty
                                    ? Image.network(
                                  dataa!.image,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                                    : Image.asset(
                                  'assets/profile.png',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),

                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(5),
                            child: IntrinsicWidth(
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/edit.png',
                                      width: 20,
                                      height: 20,
                                    ),
                                    SizedBox(width: 8,),
                                    Text("Edit Profile"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/name.png',
                                  width: 20,
                                  height: 20,
                                ),
                                SizedBox(width: 8,),
                                Text(
                                  "Name",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: 4, left: 40),
                            child: Text(
                              dataa?.name ?? 'No Name',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        height: 15,
                        color: Colors.black,
                      ),
                      Container(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/email.png',
                                  width: 20,
                                  height: 20,
                                ),
                                SizedBox(width: 8,),
                                Text(
                                  "Email",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: 4, left: 40),
                            child: Text(
                              dataa?.email ?? 'No Email',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        height: 15,
                        color: Colors.black,
                      ),
                      Container(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/phone.png',
                                  width: 20,
                                  height: 20,
                                ),
                                SizedBox(width: 8,),
                                Text(
                                  "Phone",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.only(top: 4, left: 40),
                            child: Text(
                              dataa?.phone ?? 'No Phone',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        height: 15,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<UserData?> retrieveUserData() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        print('User not authenticated');
        return null;
      }
      print(userId);

      DocumentSnapshot userSnapshot =
      await FirebaseFirestore.instance.collection('Users').doc(userId).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        String userName = userData['name'];
        String userEmail = userData['email'];
        String userPhone = userData['phone'];
        String userImage = userData['Image'];

        print('User Name: $userName');
        print('User Email: $userEmail');
        print('User Phone: $userPhone');
        print('User Image: $userImage');

        return UserData(
          name: userName,
          email: userEmail,
          phone: userPhone,
          image: userImage,
        );
      } else {
        print('User not found');
        return null;
      }
    } catch (e) {
      print('Error retrieving user data: $e');
      return null;
    }
  }

}
