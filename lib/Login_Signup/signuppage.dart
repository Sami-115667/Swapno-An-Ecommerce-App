




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../Firebase/firebaseauthservices.dart';
import 'loginpage.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Signup()

    );
  }
}

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  final FirebaseAuthServices _auth= FirebaseAuthServices();
  final DatabaseReference userRef = FirebaseDatabase.instance.reference().child("Users");

  TextEditingController emailcon = TextEditingController();
  TextEditingController passwordcon = TextEditingController();
  TextEditingController phonecon = TextEditingController();
  TextEditingController namecon = TextEditingController();
  bool _showProgressBar = false;


  @override
  void dispose() {
    emailcon.dispose();
    passwordcon.dispose();
    phonecon.dispose();
    namecon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(

              //overflow:overflow.visible;

              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    elevation: 8,
                    child: Container(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 150,
                                  height: 70,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    elevation: 10,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        "SIGNUP",
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15),
                                TextField(
                                  controller: namecon,
                                  decoration: InputDecoration(
                                    labelText: "Full Name",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: 20),
                                TextField(
                                  controller: emailcon,
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: 20),
                                TextField(
                                  controller: phonecon,
                                  decoration: InputDecoration(
                                    labelText: "Phone Number",
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.phone,
                                ),
                                SizedBox(height: 20), // Add some spacing
                                TextField(
                                  controller: passwordcon,
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    border: OutlineInputBorder(),
                                  ),
                                  obscureText: true, // If it's a password field
                                ),
                                SizedBox(height: 20), // Add some spacing
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: "Re-enter password",
                                    border: OutlineInputBorder(),
                                  ),
                                  obscureText: true, // If it's a password field
                                ),

                                ElevatedButton(
                                    onPressed: _signup,
                                    child: Text(
                                      "Sign Up",
                                      style: TextStyle(fontSize: 18),
                                    )),
                                Align(
                                  alignment: Alignment
                                      .center, // Align the TextButton to the right
                                  child: Container(
                                    width:
                                    null, // Let the Container take minimum required width
                                    child: TextButton(
                                      onPressed: () {

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginPage(),
                                          ),
                                        );

                                      },
                                      child: Text(
                                        "Already have an account!",
                                        style: TextStyle(color: Colors.black),
                                        textAlign: TextAlign
                                            .center, // Add your text style
                                      ),
                                    ),
                                  ),
                                ),

                                //SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }


  void _signup() async{
    String user_name=namecon.text.toString().trim();
    String user_email=emailcon.text.toString().trim();
    String user_phone=phonecon.text.toString().trim();
    String user_password=passwordcon.text.toString().trim();


    User? user = await _auth.signupWithEmailAndPassword(user_email, user_password);

    if(user!=null) {
      print("Successfully created the User");

      userRef.child(user.uid).set({
        'name': user_name,
        'email': user_email,
        'phone': user_phone,
        'password': user_password,
        'id': user.uid,
      });

      Map<String,String> userdata={
        'name': user_name,
        'email': user_email,
        'phone': user_phone,
        'password': user_password,
        'id': user.uid,
      };

      try {
        await FirebaseFirestore.instance.collection('Users').doc(user.uid).set(userdata);
        print('Data added to Firestore successfully!');
      } catch (e) {
        print('Error adding data to Firestore: $e');
      }



      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );


    } else
      print("Error occured");
  }




}
