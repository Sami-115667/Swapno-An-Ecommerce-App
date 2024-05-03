
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices{


  FirebaseAuth _auth= FirebaseAuth.instance;

  Future<User?> signupWithEmailAndPassword(String Email, String Password) async{
    try{
      UserCredential credential=await _auth.createUserWithEmailAndPassword(email: Email, password: Password);
      return credential.user;
    }
    catch(e){
      print("The error is $e");
    }
    return null;

  }



  Future<User?> signInWithEmailAndPassword(String Email, String Password) async{
    try{
      UserCredential credential=await _auth.signInWithEmailAndPassword(email: Email, password: Password);
      return credential.user;
    }
    catch(e){
      print("The error is $e");
    }
    return null;

  }



  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }


}