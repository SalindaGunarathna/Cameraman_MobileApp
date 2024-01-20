import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_cameraman/classes/project.dart';
import 'package:find_cameraman/resources/saveData.dart';
import 'package:find_cameraman/screens/auth/cmanNewProfile.dart';

import 'package:find_cameraman/services/store_services.dart';
import 'package:find_cameraman/utils/util_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Project extends StatefulWidget {
  final String projectId;
  const Project({super.key, required this.projectId});

  @override
  State<Project> createState() => _AddProjectState();
}

class _AddProjectState extends State<Project> {
  final user = FirebaseAuth.instance.currentUser;
  StorageMethodes storageMethodes = StorageMethodes();
  Project? newProject;
  Uint8List? _image;
  String? Url;

  bool isOwner = false;
  bool editing = false;

  String Projecname = " ";

  final TextEditingController description = TextEditingController();
  final TextEditingController cameramanName = TextEditingController();
  final TextEditingController cameramanEmail = TextEditingController();
  final TextEditingController cameramanId = TextEditingController();
  final TextEditingController projectDate = TextEditingController();
  final TextEditingController projectName = TextEditingController(text: " ");
  final TextEditingController projectImage = TextEditingController();

  List<String> projectImagesList = [];

  @override
  void initState() {
    super.initState();
    _fetchProjectDetails();
  }

  Future<void> _fetchProjectDetails() async {
    if (user!.email == cameramanEmail.text) {
      isOwner = true;
    }

    try {
      var projectSnap = await FirebaseFirestore.instance
          .collection("projects")
          .doc(widget.projectId)
          .get();

      Map<String, dynamic>? projectData =
          projectSnap.data() as Map<String, dynamic>?;

      if (projectData != null) {
        description.text = projectData["description"] ?? "";
        cameramanName.text = projectData['cameramanName'] ?? "";
        projectDate.text = projectData['projectDate'] ?? "";
        cameramanId.text = projectData['cameramanId'] ?? "";
        cameramanEmail.text = projectData['cameramanEmail'] ?? "";
        projectName.text = projectData['projectDate'] ?? "";
        setState(() {
          projectImagesList = List.from(projectData['album']);
        });

        

      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Cannot fetch project data'),
          duration: Duration(seconds: 2),
        ),
      );
      print(error);
    }
  }

  Future<void> _updateProjectDetails() async {
    try {
      await FirebaseFirestore.instance
          .collection('projets')
          .doc(widget.projectId)
          .update({
        'projectName': projectName.text,
        'album': projectImagesList,
        'description': description.text,
        'projectDate': projectDate.text,
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error:can not update data  '),
          duration: Duration(seconds: 2),
        ),
      );
      print(error);
    }
  }

  void editAccess() {
    if (user!.email == cameramanEmail.text) {
      editing = true;
    }
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  Future<void> _addImage() async {
    if (isOwner) {
      if (_image != null) {
        String? url2 = await StoreData().uploadImageToStorange("58", _image!);

        setState(() {
          projectImagesList.add(url2);
        });

        print("link  is :" + projectImagesList[0]);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: Image URL cannot be empty.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: Only owner can add image'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Project'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              "https://thumbs.dreamstime.com/b/businessman-icon-vector-male-avatar-profile-image-profile-businessman-icon-vector-male-avatar-profile-image-182095609.jpg"),
                        ),
                  Positioned(
                    child: IconButton(
                      onPressed: () {
                        selectImage();
                      },
                      icon: const Icon(Icons.add_a_photo),
                    ),
                    bottom: -10,
                    left: 88,
                  )
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  await _addImage();
                },
                child: const Text('save image'),
              ),
              ImageListWidget(images: projectImagesList),



              ElevatedButton.icon(
                onPressed: () {
                  editAccess();
                },
                icon: const Icon(Icons.edit), // Add the edit icon
                label: const Text('Edit'),
              ),
              TextField(
                controller: projectName,
                decoration: const InputDecoration(labelText: 'Project Name'),
              ),
              TextField(
                controller: projectDate,
                decoration: const InputDecoration(labelText: 'Project Date'),
              ),
              TextField(
                controller: description,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 20),
              Text(cameramanEmail.text),
              Text(cameramanName.text),
              Text(cameramanId.text),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CmanNewProfile(uid: cameramanId.text),
                    ),
                  );
                },
                child: Text('Cameraman profile'),
              ),
              ElevatedButton(
                onPressed: () {
                  _updateProjectDetails();
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageListWidget extends StatelessWidget {
  final List<String> images;

  const ImageListWidget({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Project Images',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        if (images.isNotEmpty)
          Column(
            children: images
                .map((imageUrl) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        imageUrl,
                        width: 100, // Set the desired width
                        height: 100, // Set the desired height
                        fit: BoxFit
                            .cover, // Adjust this based on your requirements
                      ),
                    ))
                .toList(),
          )
        else
          Text('No images added'),
      ],
    );
  }
}
