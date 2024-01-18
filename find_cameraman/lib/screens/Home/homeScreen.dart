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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to the user profile page
              // You can implement the user profile page based on your requirements
            },
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
                  Text(
                    'Current User:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Name: ${user?.displayName ?? ''}'),
                  Text('Email: ${user?.email ?? ''}'),
                  // Add more user details if needed
                ],
              ),
            ),
            
            // Display all projects
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('projects').snapshots(),
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
                    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

                    if (data == null) {
                      return SizedBox.shrink();
                    }

                    return ProjectCard(data: data);
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

  const ProjectCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            data['album'][0], // Assuming the first image in the album is used as a preview
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
                // You can add more project details if needed

                ElevatedButton(
                  onPressed: () {
                    // Navigate to the detailed project page
                    // You can implement the detailed project page based on your requirements
                  },
                  child: Text('View Project'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

