//import 'dart:html'as prefix;

//import 'package:find_cameraman/classes/address.dart';

import 'dart:io' ;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import '../classes/client.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClientProfilePage extends StatefulWidget {
  @override
  _ClientProfilePageState createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isEditing = true;
  File? _imageFile;

  TextEditingController name = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController _budgetRange = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  QuerySnapshot? querySnapshot;
  DocumentSnapshot? document;

  User? user;

  late Client client = Client("null", "null", "null", "null", "null");

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    user = auth.currentUser;
    _getClientDetails();
    print(document);
    print(user!.email);
  }

  Future<void> _getClientDetails() async {
    try {
      // Replace 'clients' with your Firestore collection name
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("clients")
          .where("email",
              isEqualTo:
                  user!.email) // Replace 'UID' with your actual field name
          .get();

      List<DocumentSnapshot> documents = querySnapshot.docs;

      if (documents.isNotEmpty) {
        DocumentSnapshot document = documents.first;

        setState(() {
          client.name = document["name"] ?? "null";
          client.phoneNumber = document["phoneNumber"] ?? "null";
          client.emailAddress = document["email"] ?? "null";
          client.password = document["password"] ?? "null";

          name.text = client.name;
          phoneNumber.text = client.phoneNumber;
          password.text = client.password;

          // Retrieve and set address data
          Map<String, dynamic>? addressData = document["address"];
          client.profileURL = document["profileURL"] ;

          if (addressData != null) {
            client.addAddress(
                addressData["street"] ?? "",
                addressData["city"] ?? "",
                addressData["state"] ?? "",
                addressData["postalCode"] ?? "",
                addressData["country"] ?? "");

            // Set the address data to the corresponding text controllers
            streetController.text = client.address!.street;
            cityController.text = client.address!.city;
            stateController.text = client.address!.state;
            postalCodeController.text = client.address!.postalCode;
            countryController.text = client.address!.country;
          }
        });
      } else {
        print("No documents found for the current user.");
      }
    } catch (e) {
      print("Error fetching client details: $e");
    }
  }

  Future<void> _updateClientDetails() async {


                 _uploadProfileImage();

    if (streetController != null) {
      client.addAddress(
          streetController.text,
          cityController.text,
          stateController.text,
          postalCodeController.text,
          countryController.text);
    }

    try {
      if (_formKey.currentState!.validate()) {
        print(client.profileURL);
        // Update the client details in Firestore
        await FirebaseFirestore.instance
            .collection("clients")
            .where("email", isEqualTo: user!.email)
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) async {
            await doc.reference.update({
              "name": client.name,
              "phoneNumber": client.phoneNumber,
              /*
              "address": {
                "street": client.address?.street,
                "city": client.address?.city,
                "state": client.address?.state,
                "postalCode": client.address?.postalCode,
                "country": client.address?.country,
              },*/
              "profileURL": client.profileURL,
              
            });
          });
        });

        // Show a success message or perform any other actions after updating
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Client details updated successfully"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print("Error updating client details: $e");
      // Show an error message or perform any other actions on error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error updating client details. Please try again."),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

    Future<void> _uploadProfileImage() async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      await firebase_storage.FirebaseStorage.instance
          .ref('profile_images/$fileName')
          .putFile(_imageFile!);

      // Get the download URL of the uploaded image
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref('profile_images/$fileName')
          .getDownloadURL();

      // Update the client's profileURL with the download URL
      client.profileURL = downloadURL;

      print("url:$downloadURL");
    } catch (e) {
      print("Error uploading profile image: $e");
    }
  }


  void selectImage(){
    
  }

  // New method to pick an image from the gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Client Profile')),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [


                Stack(

                  children: [

                    CircleAvatar(
                      radius: 64,
                     backgroundImage: NetworkImage('https://thumbs.dreamstime.com/b/businessman-icon-vector-male-avatar-profile-image-profile-businessman-icon-vector-male-avatar-profile-image-182095609.jpg'), 
                                        ),
                                        Positioned(
                                          child: IconButton(
                                             onPressed:(){

                                          },
                                            icon: const Icon(Icons.add_a_photo), ),

                                            bottom: -10,
                                            left: 88,
                                            
                                            )
                  ],
                ),


                /*

                ======================= get image 
                ElevatedButton(
        onPressed: _pickImage,
        child: const Text('Pick Image'),
      ),
      // Display the picked image if available
      _imageFile != null
          ? Image.file(
              _imageFile!,
              height: 100,
            )
          : client.profileURL != null
              ? Image.network(
                  client.profileURL!,
                  height: 100,
                )
              : SizedBox(),
              
              ================================
              */

                TextFormField(
                  readOnly: isEditing,
                  controller: name,
                  decoration: const InputDecoration(labelText: 'Name'),
                  onChanged: (value) {
                    setState(() {
                      client.name = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  readOnly: isEditing,
                  controller: phoneNumber,
                  decoration: const InputDecoration(labelText: 'phoneNumber'),
                  onChanged: (value) {
                    setState(() {
                      client.name = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phoneNumber';
                    }
                    return null;
                  },
                ),
                /*
                TextFormField(
                  readOnly: isEditing,
                  controller: streetController,
                  decoration: const InputDecoration(labelText: 'Street'),
                  onChanged: (value) {
                    setState(() {
                      client.address?.street = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a street';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  readOnly: isEditing,
                  controller: cityController,
                  decoration: const InputDecoration(labelText: 'City'),
                  onChanged: (value) {
                    setState(() {
                      client.address?.city = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a city';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  readOnly: isEditing,
                  controller: stateController,
                  decoration: const InputDecoration(labelText: 'State'),
                  onChanged: (value) {
                    setState(() {
                      client.address?.state = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a state';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  readOnly: isEditing,
                  controller: postalCodeController,
                  decoration: const InputDecoration(labelText: 'Postal Code'),
                  onChanged: (value) {
                    setState(() {
                      client.address?.postalCode = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a postal code';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  readOnly: isEditing,
                  controller: countryController,
                  decoration: const InputDecoration(labelText: 'Country'),
                  onChanged: (value) {
                    setState(() {
                      client.address?.country = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a country';
                    }
                    return null;
                  },
                ),
                */

                Text(client.emailAddress),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      isEditing = !isEditing;
                    });
                  },
                  icon: Icon(Icons.edit), // Add the edit icon
                  label: const Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isEditing
                        ? Color.fromARGB(255, 182, 155, 190)
                        : Colors.grey, // Conditionally change color
                  ),
                ),

                ElevatedButton(
                  onPressed: _updateClientDetails,
                  child: const Text('Save Changes'),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Your Bookings:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                // ...bookings.map((booking) => ListTile(
                //       title: Text(booking.title),
                //       subtitle: Text(booking.date),
                //     )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
