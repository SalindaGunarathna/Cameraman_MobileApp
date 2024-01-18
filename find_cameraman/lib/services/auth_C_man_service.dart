import 'dart:typed_data';
import 'package:find_cameraman/classes/cameraman.dart';
import 'package:find_cameraman/classes/client.dart';
import 'package:find_cameraman/models/user_model.dart';
import 'package:find_cameraman/services/store_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart' as user_model;

class autthCmanMethodes {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;




  Future<user_model.UserModel> getCurrentUser() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snapshot =
        await _firestore.collection('cameraman').doc(currentUser.uid).get();
    return user_model.UserModel.fromJson(
        snapshot.data() as Map<String, dynamic>);
  }

  Future<String> registerWithEmailAndPassword(
      {required String email,
      required String password,
      required String userName,
      required String phoneNumber,
      required String skill,      
      required Uint8List propic}) async {
    String res = "An error occured";

    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          userName.isNotEmpty &&
          phoneNumber.isNotEmpty &&
          skill.isNotEmpty&&
          propic.isNotEmpty) {
        final UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String photoURL = await StorageMethodes().uploadImage(
          path: "profileImages",
          isPost: false,
          file: propic,
        );

        final Cameraman cameraman =new Cameraman(
                      userName,
                      userCredential.user!.uid,
                      phoneNumber,
                      email,
                      password,
                      skill,
                      photoURL
                    );


        if (userCredential.user != null) {
          await _firestore
              .collection("cameramans")
              .doc(_auth.currentUser!.uid)
              .set(cameraman.toJSON());
          res = "User Registration Successful";
        } else {
          res = "User Registration Failed";
        }
      } else {
        res = "Please fill all the fields";
      }
    } on FirebaseAuthException catch (e) {
      res = e.toString();
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    String res = "An error occured";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (userCredential.user != null) {
          res = "Login Successful";
        } else {
          res = "Login Failed";
        }
      } else {
        res = "Please fill all the fields";
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == "invalid-email") {
        res = "Invalid email";
      } else if (error.code == "weak-password") {
        res = "Weak password";
      } else if (error.code == "email-already-in-use") {
        res = "Email already in use";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
