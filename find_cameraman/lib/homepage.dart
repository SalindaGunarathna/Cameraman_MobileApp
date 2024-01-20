// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:find_cameraman/screens/auth/clientBooking.dart';
// import 'package:find_cameraman/screens/auth/clientProfile.dart';
// import 'package:find_cameraman/screens/auth/cman_profile.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final user = FirebaseAuth.instance.currentUser;
//   String? _name;

//   @override
//   void initState() {
//     super.initState();
//     //_getUserName();
//   }


//   Future<void> loginProfile() async {
//     final FirebaseFirestore firestore = FirebaseFirestore.instance;

//     print("come funtion");

//     try {
//       final QuerySnapshot querySnapshot = await firestore
//           .collection("clients")
//           .where("email", isEqualTo: user!.email)
//           .get();

//       final List<DocumentSnapshot> clientDocuments = querySnapshot.docs;

//       final DocumentSnapshot clientDocument = clientDocuments.first;
//       String name1 = clientDocument["name"];

//       if (name1 != "null") {
//         // The user is a client

//         print("_name");
//         // Navigate to the client page
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => ClientProfilePage()),
//         );
//       }
//     } catch (error) {
//       try {
//         final FirebaseFirestore firestore = FirebaseFirestore.instance;
//         final QuerySnapshot querySnapshot = await firestore
//             .collection("cameramans")
//             .where("emailAddress", isEqualTo: user!.email)
//             .get();
//         final List<DocumentSnapshot> documents = querySnapshot.docs;

//         if (documents.isNotEmpty) {
//           final DocumentSnapshot document = documents.first;
//           String name = document["name"];
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => CmanProfile()),
//           );
//         }
//       } catch (error) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Error updating client details. Please try again."),
//             duration: Duration(seconds: 2),
//           ),
//         );
//       }
//     }
//   }

//   singOut() async {
//     await FirebaseAuth.instance.signOut();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Home Page')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("$_name (${user!.email})"),
//             ElevatedButton(
//               onPressed: loginProfile,
//               child: Text('Go to Profile'),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: (() => singOut()),
//         child: const Icon(Icons.login_rounded),
//       ),
//     );
//   }
// }
