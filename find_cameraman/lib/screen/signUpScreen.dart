import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_cameraman/classes/client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _email = " ", _password = " ", _confirmPassword = "", _name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  _confirmPassword = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Confirm Password',
              ),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_password == _confirmPassword) {
                  try {
                    final UserCredential userCredential =
                        await _auth.createUserWithEmailAndPassword(
                      email: _email,
                      password: _password,
                    );

                    // Create a new Client object
                    final Client client = Client(
                      _name,
                      "johndoe123",
                      "1234567890",
                      _email,
                      _password,
                    );

                    // Get a reference to the Firestore database
                    final FirebaseFirestore firestore = FirebaseFirestore.instance;

                    // Add the Client object to a new document in the Firestore collection
                    await firestore.collection("clients").add({
                      "name": client.name,
                      "phoneNumber": client.phoneNumber,
                      "email": client.emailAddress,
                      "password": client.password,
                    });

                    Navigator.pop(context);
                  } catch (e) {
                    print(e);
                  }
                }
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}