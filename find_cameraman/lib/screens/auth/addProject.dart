import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_cameraman/classes/project.dart';
import 'package:find_cameraman/resources/saveData.dart';
import 'package:find_cameraman/utils/util_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProject extends StatefulWidget {
  const AddProject({super.key});

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  final user = FirebaseAuth.instance.currentUser;

  Project? newProject;

  int i =100;
  Uint8List? _image;
  String? Url;

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
    _getUserName();
  }

  Future<void> _getUserName() async {


    
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final QuerySnapshot querySnapshot = await firestore
        .collection("cameramans")
        .where("emailAddress", isEqualTo: user!.email)
        .get();
    final List<DocumentSnapshot> documents = querySnapshot.docs;


    if (documents.isNotEmpty) {
      final DocumentSnapshot document = documents.first;
      cameramanName.text = document["name"];
      cameramanEmail.text = document["emailAddress"];
      cameramanId.text = document.id;
    }
  }

  Future<void> _addProject(Project project) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      // Add the project to the "projects" collection
      await firestore.collection("projects").add({
        'projectName': project.projectName,
        'album': projectImagesList,
        'description': project.description,
        'cameramanId': project.cameramanId,
        'cameramanName': project.cameramanName,
        'cameramanEmail': user!.email,
        'projectDate': project.projectDate,
      });
    } catch (e) {
      print("Error adding project: $e");
    }
  }

  Future<void> _addNewProject() async {
    newProject = Project(
      projectName.text,
    );
    newProject?.cameramanEmail = cameramanName.text;
    newProject?.cameramanId = cameramanId.text;
    newProject?.cameramanName = cameramanName.text;
    newProject?.description = description.text;
    newProject?.projectDate = projectDate.text;

    newProject?.album = projectImagesList;
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }



  Future<void> _addImage() async {

    String imageName =  i.toString();

    i = i+1;
    if (_image != null) {
      String? url2 = await StoreData().uploadImageToStorange(imageName, _image!);

      print(url2);
      Url = url2;

     

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
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              "https://img.freepik.com/free-photo/wide-angle-shot-single-tree-growing-clouded-sky-during-sunset-surrounded-by-grass_181624-22807.jpg?size=626&ext=jpg&ga=GA1.1.632798143.1705622400&semt=sph"),
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
                child: Text('save image'),
              ),
              ImageListWidget(images: projectImagesList),
              TextField(
                controller: projectName,
                decoration: InputDecoration(labelText: 'Project Name'),
              ),
              TextField(
                controller: projectDate,
                decoration: InputDecoration(labelText: 'Project Date'),
              ),
              TextField(
                controller: description,
                decoration:const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 20),

             
              ElevatedButton(
                onPressed: () async {
                  _addNewProject();
                  await _addProject(newProject!);
                },
                child: Text('Save project'),
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
                        fit: BoxFit.cover, // Adjust this based on your requirements
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
