






import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:swapno/Login_Signup/signuppage.dart';
import '../Dashboard/homepage.dart';
import '../Firebase/firebaseauthservices.dart';
import '../firebase_options.dart';



class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    // Decide whether to show the login page or home page based on authentication status
    return user != null ? HomePage() : Login();
  }
}


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuthServices _auth= FirebaseAuthServices();


  TextEditingController emailcon = TextEditingController();
  TextEditingController passwordcon = TextEditingController();

  bool _showProgressBar = false;


  @override
  void dispose() {
    emailcon.dispose();
    passwordcon.dispose();

    super.dispose();
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
      child: Scaffold(
        backgroundColor: Colors.purple,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width / 1.1,
                height: MediaQuery.of(context).size.height / 1.70,
                child: Center(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),

                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 200,
                            height: 100,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              elevation: 8,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "LOGIN",
                                  style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 40,),
                          TextField(
                            controller: emailcon,
                            decoration: InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: passwordcon,
                            decoration: InputDecoration(
                              labelText: "Password",
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: null,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed:_login,
                            child: _showProgressBar
                                ? CircularProgressIndicator()
                                : Text(
                              "Login",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: null,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignupPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Create New Account!",
                                  style: TextStyle(
                                    color: Colors.black,
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
              ),
            ),
          ),
        ),
      ),
    );
  }


  void _login() async{

    String user_email=emailcon.text.toString().trim();
    String user_password=passwordcon.text.toString().trim();


    User? user = await _auth.signInWithEmailAndPassword(user_email, user_password);

    if(user!=null) {
      print("Successfully created the User");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );


    } else
      print("Error occured");
  }
}