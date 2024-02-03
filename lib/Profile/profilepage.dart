


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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


  UserData({
    required this.name,
    required this.email,
    required this.phone,
  });
}


class _ProfilePageState extends State<ProfilePage> {



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




  @override
  Widget build(BuildContext context) {
    //dataa = retrieveUserData() as UserData?;



    return Scaffold(
      appBar:  AppBar(title:  Text( "My Profile"),),

      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(

                width: double.infinity,
                height: 150,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/profile.png',  // Replace with your image path
                        width: 100,               // Set the desired width of the image
                        height: 100,              // Set the desired height of the image
                        fit: BoxFit.cover,        // You can use different BoxFit options
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

                          onPressed:(){},
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/edit.png'
                                ,width: 20,
                                height: 20,
                              ),
                              SizedBox(width: 8,),
                              Text("Edit Profile")

                            ],
                          )

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
                          'assets/name.png'
                          ,width: 20,
                          height: 20,
                        ),
                        SizedBox(width: 8,),


                        Text("Name",style: (
                            TextStyle( fontSize: 12, fontWeight: FontWeight.bold,)

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
                    child: Text(dataa?.name ?? 'No Name',style: (
                        TextStyle( fontSize: 16, fontWeight: FontWeight.bold,)

                    ),

                    ),
                  ),
                ),
              ),
              Divider(
                height:15, // Adjust the height of the divider
                color: Colors.black, // You can change the color to your preference
              ),

              Container(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Row(

                      children: [
                        Image.asset(
                          'assets/email.png'
                          ,width: 20,
                          height: 20,
                        ),
                        SizedBox(width: 8,),


                        Text("Email",style: (
                            TextStyle( fontSize: 12, fontWeight: FontWeight.bold,)

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
                    child: Text(dataa?.email ?? 'No Email',style: (
                        TextStyle( fontSize: 16, fontWeight: FontWeight.bold,)

                    ),

                    ),
                  ),
                ),
              ),
              Divider(
                height: 15, // Adjust the height of the divider
                color: Colors.black, // You can change the color to your preference
              ),

              Container(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/phone.png'
                          ,width: 20,
                          height: 20,
                        ),
                        SizedBox(width: 8,),


                        Text("Phone",style: (
                            TextStyle( fontSize: 12, fontWeight: FontWeight.bold,)

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
                    child: Text(dataa?.phone ?? 'No Phone',style: (
                        TextStyle( fontSize: 16, fontWeight: FontWeight.bold,)

                    ),

                    ),
                  ),
                ),
              ),
              Divider(
                height: 15, // Adjust the height of the divider
                color: Colors.black, // You can change the color to your preference
              ),

            ],
          ),
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

      DocumentSnapshot userSnapshot =
      await FirebaseFirestore.instance.collection('Users').doc(userId).get();

      // Check if the document exists
      if (userSnapshot.exists) {
        Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
        // Access specific fields from userData
        String userName = userData['name'];
        String userEmail = userData['email'];
        String userPhone = userData['phone'];

        print('User Name: $userName');
        print('User Email: $userEmail');
        print('User Phone: $userPhone');

        return UserData(name: userName, email: userEmail, phone: userPhone);
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
