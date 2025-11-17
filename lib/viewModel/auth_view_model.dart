import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class AuthViewModel {

  createUserAccountWithEmailAndPassword(String name, String userEmail, String userPassword) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: userEmail, password: userPassword);

      await storeUserData(name: name, userEmail: userEmail);

      return "SignUp Successful";
    } on FirebaseAuthException catch (ecp) {
      return ecp.message.toString();
    }
  }

  storeUserData({required String name, required String userEmail}) async {
    try {
      Map<String, dynamic> userData = {
        "name": name,
        "email": userEmail,
      };
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(userData);
    } catch (ecp) {
      print("failed to save user data: $ecp");
    }
  }

  loginWithEmailAndPassword(String userEmail, String userPassword, BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userEmail,
          password: userPassword
      );

      Provider.of<UserProvider>(context, listen: false).getUserData();

      return "Login Successful";
    } on FirebaseAuthException catch (ecp) {
      return ecp.message.toString();
    }
  }

}