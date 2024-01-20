//import 'dart:html'as prefix;

//import 'package:find_cameraman/classes/address.dart';

import 'dart:io';
import 'dart:typed_data';
import 'package:find_cameraman/classes/client.dart';
import 'package:find_cameraman/resources/saveData.dart';
import 'package:find_cameraman/units/units.dart';
import 'package:find_cameraman/utils/colors.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ClientProfilePage extends StatefulWidget {
  
  const ClientProfilePage({Key? key,}) : super(key: key);

  @override
  _ClientProfilePageState createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isEditing = true;
  File? _imageFile;

  Uint8List? _image;

  bool redaOnly = true;
  bool editing = false;

  bool _isLoadnig = false;

  TextEditingController name = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController _budgetRange = TextEditingController(text: "null");
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  QuerySnapshot? querySnapshot;
  DocumentSnapshot? document;

  String Url = "null";

  User? user;

  late Client client = Client(
      name: "null",
      emailAddress: "null",
      password: "null",
      phoneNumber: "null",
      profileURL: "null",
      userID: "null");

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    user = auth.currentUser;
    _getClientDetails();
  }

  Future<void> _getClientDetails() async {
    setState(() {
      _isLoadnig = true;
    });

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("clients")
          .where("email", isEqualTo: user!.email)
          .get();

      List<DocumentSnapshot> documents = querySnapshot.docs;

      if (documents.isNotEmpty) {
        DocumentSnapshot document = documents.first;

        setState(() {
          client.name = document["name"] ?? "null";
          client.phoneNumber = document["phoneNumber"] ?? "null";
          client.emailAddress = document["email"] ?? "null";
          client.password = document["password"] ?? "null";

          // client.setBudget(document["budgetRange"]?? "null");

          name.text = client.name;
          phoneNumber.text = client.phoneNumber;
          password.text = client.password;

          // Retrieve and set address data
          Map<String, dynamic>? addressData = document["address"];

          client.profileURL = document["profileURL"];

          if (client.profileURL != null) {
            Url = client.profileURL!;
          } else {
            Url =
                'https://thumbs.dreamstime.com/b/businessman-icon-vector-male-avatar-profile-image-profile-businessman-icon-vector-male-avatar-profile-image-182095609.jpg';
          }

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
            _budgetRange.text = client.getBudget();
          }

          setState(() {
            _isLoadnig = false;
          });
        });
      } else {
        print("No documents found for the current user.");
      }
    } catch (e) {
      print("Error fetching client details: $e");
    }
  }

  Future<void> _updateClientDetails() async {
    if (_image != null) {
      saveProfile();
    }

    if (streetController != null) {
      client.addAddress(
          streetController.text,
          cityController.text,
          stateController.text,
          postalCodeController.text,
          countryController.text);
    }

    client.setBudget(_budgetRange.text);

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
              "address": {
                "street": client.address?.street,
                "city": client.address?.city,
                "state": client.address?.state,
                "postalCode": client.address?.postalCode,
                "country": client.address?.country,
              },
              "profileURL": Url,
              "budgetRange": client.getBudget()
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

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void saveProfile() async {
    if (_image != null) {
      String? url2 = await StoreData().uploadImageToStorange("", _image!);

      print(url2);
      Url = url2;
    } else {
      print("Error: Image is null");
    }
  }

  Column userStatsColoum({required int number, required String lable}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number.toString(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        Text(
          lable,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
        ),
      ],
    );
  }

  void writeAcce() {
    if (user!.email == client.emailAddress) {
      redaOnly = false;
    }
  }

  Widget build(BuildContext context) {
    return _isLoadnig
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: const Text(
                "Profile",
                style: TextStyle(
                    color: mainYellowColor,
                    fontSize: 26,
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
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
                              backgroundImage: NetworkImage(Url),
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
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    userStatsColoum(
                                        number: 5, lable: "Following"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ), //////
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: TextField(
                          controller: name,
                          readOnly: redaOnly,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          decoration: const InputDecoration(
                            border: InputBorder.none, // Remove the underline
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 10),
                        child: TextField(
                          controller: phoneNumber,
                          readOnly: redaOnly,
                          style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              color: secondaryColor),
                          decoration: const InputDecoration(
                            border: InputBorder.none, // Remove the underline
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (editing) {
                            // Handle the save button press event
                            _updateClientDetails();
                          } else {
                            // Handle the edit button press event
                            writeAcce();
                          }
                          // Toggle the editing state
                          setState(() {
                            editing = !editing;
                          });
                        },
                        icon: Icon(editing
                            ? Icons.save
                            : Icons.edit), // Toggle between save and edit icons
                        label: Text(editing
                            ? 'Save'
                            : 'Edit'), // Toggle between save and edit labels
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: secondaryColor,
                ),
                Text("your Booing"),

                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('bookings')
                        .where("clientEmail", isEqualTo: user!.email)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }

                      final booking = snapshot.data?.docs ?? [];

                      return Column(
                        children: booking.map((doc) {
                          Map<String, dynamic>? data =
                              doc.data() as Map<String, dynamic>?;

                          if (data == null) {
                            return SizedBox.shrink();
                          }

                          return BookingCard(data: data);
                        }).toList(),
                      );
                    },
                  ),
              ],
            ),
          );
  }
}

class BookingCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const BookingCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'event Name: ${data['eventName']}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text('Cameraman Name: ${data['cameramanName']}'),
                Text('booking  ID: ${data['bookingID']}'),
                Text('date: ${data['data']}'),
                Text('status: ${data['status']}'),
                ElevatedButton(
                  onPressed: () {},
                  child: Text(''),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
