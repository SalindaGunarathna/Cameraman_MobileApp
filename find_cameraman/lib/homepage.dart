import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_cameraman/screen/clientProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  String? _name;

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  Future<void> _getUserName() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot querySnapshot =
        await firestore.collection("clients").where("email", isEqualTo: user!.email).get();
    final List<DocumentSnapshot> documents = querySnapshot.docs;
    if (documents.isNotEmpty) {
      final DocumentSnapshot document = documents.first;
      _name = document["name"];
      setState(() {});
    }
  }

  singOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$_name (${user!.email})"),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                 context,
                 MaterialPageRoute(builder: (context) => ClientProfilePage()),
                );
              },
              child: Text('Go to Client Profile'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() => singOut()),
        child: const Icon(Icons.login_rounded),
      ),
    );
  }
}