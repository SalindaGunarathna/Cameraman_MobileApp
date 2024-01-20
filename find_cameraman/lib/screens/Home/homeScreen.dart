import 'package:find_cameraman/screens/auth/clientProfile.dart';
import 'package:find_cameraman/screens/auth/cmanNewProfile.dart';
import 'package:find_cameraman/screens/auth/cman_profile.dart';
import 'package:find_cameraman/screens/auth/login.dart';

import 'package:find_cameraman/screens/auth/project.dart';
import 'package:find_cameraman/screens/auth/user_profile.dart';

import 'package:find_cameraman/services/store_services.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser;

  StorageMethodes storageMethodes = StorageMethodes();

  String? userEmail;

  String userName = "nill";
  late String userPhoneNumber;

  late String loginUser;

  @override
  void initState() {
    super.initState();
    _findUser();
  }

  Future<void> loginProfile() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    String userEmail = user!.email ?? "null";

    storageMethodes.userAuth(userEmail).then((userType) {
      loginUser = userType;
      if (userType == "Client") {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClientProfilePage()
            ));
      } else if (userType == "Cameraman") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CmanNewProfile(
                      uid: user!.uid,
                    )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("User Type is not valid."),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }).catchError((error) {
      // Handle the error here
      print("Error: $error");
    });
  }

  Future<void> _findUser() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    if (loginUser == "Client") {
      final QuerySnapshot querySnapshot = await firestore
          .collection("clients")
          .where("email", isEqualTo: userEmail)
          .get();

      final List<DocumentSnapshot> clientDocuments = querySnapshot.docs;

      final DocumentSnapshot clientDocument = clientDocuments.first;

      String userID  = clientDocument.id;

      print(userID);
      


      StepState() {
        userName = clientDocument["name"];
      }
    } else if (loginUser == "Cameraman") {
      final QuerySnapshot querySnapshot = await firestore
          .collection("cameramans")
          .where("email", isEqualTo: userEmail)
          .get();

      final List<DocumentSnapshot> clientDocuments = querySnapshot.docs;

      final DocumentSnapshot clientDocument = clientDocuments.first;

      StepState() {
        userName = clientDocument["name"];
      }
    } else {
       StepState() {
        userName = " ";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            onPressed: loginProfile,
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display current user details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   'Current User:',
                  //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  // ),
                  // SizedBox(height: 8),
                  // Text('Name: ${userName}'),
                ],
              ),
            ),

            // Display all projects

            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('projects').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final projects = snapshot.data?.docs ?? [];

                return Column(
                  children: projects.map((doc) {
                    Map<String, dynamic>? data =
                        doc.data() as Map<String, dynamic>?;

                    if (data == null) {
                      return SizedBox.shrink();
                    }
                    String projectId = doc.id;
                    String cameramanId = data["cameramanId"];
                    return ProjectCard(
                        data: data, projectId: projectId, Cam_id: "9XyqYkGxXqbRoFkaxfADDKEqPr32");
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String projectId;
  final String Cam_id;

  const ProjectCard(
      {Key? key,
      required this.data,
      required this.projectId,
      required this.Cam_id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data['album'] != null && data['album'].isNotEmpty)
            Image.network(
              data['album'][0],
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Project Name: ${data['projectName']}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text('Cameraman Name: ${data['cameramanName']}'),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Project(projectId: projectId),
                          ),
                        );
                      },
                      child: Text('View Project'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CmanNewProfile(uid: Cam_id)),
                        );
                      },
                      child: Text('Profile'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
