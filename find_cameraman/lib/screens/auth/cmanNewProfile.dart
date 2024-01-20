import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_cameraman/resources/saveData.dart';
import 'package:find_cameraman/screens/auth/addProject.dart';
import 'package:find_cameraman/screens/auth/clientBooking.dart';
import 'package:find_cameraman/screens/auth/project.dart';
import 'package:find_cameraman/services/store_services.dart';
import 'package:find_cameraman/utils/colors.dart';
import 'package:find_cameraman/utils/util_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CmanNewProfile extends StatefulWidget {
  final String uid;
  const CmanNewProfile({Key? key, required this.uid}) : super(key: key);

  @override
  State<CmanNewProfile> createState() => _CmanNewProfileState();
}

class _CmanNewProfileState extends State<CmanNewProfile> {
  final user = FirebaseAuth.instance.currentUser;
  StorageMethodes storageMethodes = StorageMethodes();
  //var userData = {};
  int followersLength = 0;
  int followingLength = 0;
  bool _isLoadnig = false;
  List<String> followers = [];
  bool isFollowing = false;
  late String cameramanEmail;

  bool isMyProfile = false;

  String? profile;
  Uint8List? _image;

  TextEditingController budgetRange = TextEditingController(text: "null");
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController skill = TextEditingController();
  TextEditingController email = TextEditingController();

  //function to create the coloum
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

  getUserData() async {
    setState(() {
      _isLoadnig = true;
    });

    try {
      isMyProfile = await _identifyUser();

      var CamaramanData = await FirebaseFirestore.instance
          .collection("cameramans")
          .doc(widget.uid)
          .get();

      Map<String, dynamic>? UserData =
          CamaramanData.data() as Map<String, dynamic>?;

      if (UserData != null) {
        // Set other fields accordingly
        email.text = UserData['emailAddress'] ?? "";
        name.text = UserData['name'] ?? "";
        phoneNumber.text = UserData['phoneNumber'] ?? "";
        skill.text = UserData['skill'] ?? "";
        //budgetRange.text = UserData['budgetRange'] ?? "";

        if (UserData["profileURL"] != null) {
          profile = UserData["profileURL"];
        } else {
          profile =
              'https://thumbs.dreamstime.com/b/businessman-icon-vector-male-avatar-profile-image-profile-businessman-icon-vector-male-avatar-profile-image-182095609.jpg';
        }

        setState(() {
          followers = List.from(UserData['followers']);
        });

        followersLength = followers.length;

        setState(() {
          _isLoadnig = false;
        });

        // You can continue this pattern for other fields
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

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<bool> _identifyUser() async {
    String userEmail = user!.email ?? "null";

    storageMethodes.userAuth(userEmail).then((userType) {
      if (userType == "Client") {
        return false;
      } else if (userType == "Cameraman") {
        if (user!.email == cameramanEmail) {
          return false;
        } else {
          return true;
        }
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

    return false;
  }

  Future<void> addFollowers() async {
    if (isFollowing = false & isMyProfile == false) {
      setState(() {
        followers.add(user!.uid);
        followersLength = followers.length;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You already  following this cameraman "),
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
      String? url2 = await StoreData().uploadImageToStorange("$cameramanEmail", _image!);

      print(url2);
      profile = url2;
    } else {
      print("Error: Image is null");
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
                                      backgroundImage: NetworkImage(profile!),
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
                                        number: followersLength,
                                        lable: "Followers"),
                                    userStatsColoum(
                                        number: followingLength,
                                        lable: "Following"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: !isMyProfile,
                        child: TextButton(
                          onPressed: () {
                            addFollowers();
                          },
                          child: Text("Follow"),
                        ),
                      ),
                      Row(
                        children: [
                          Visibility(
                            visible: !isMyProfile,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddProject()),
                                );
                              },
                              child: Text("add project"),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ClientBooking(),
                                  ),
                                );
                              },
                              child: Text("Booking")),
                        ],
                      ),
                      Column(
                        children: [
                          // Name and Phone Number Row
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(top: 15),
                                  child: TextField(
                                    controller: name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder
                                          .none, // Remove the underline
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding:
                                      const EdgeInsets.only(top: 10, left: 10),
                                  child: TextField(
                                    controller: phoneNumber,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                      color: secondaryColor,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder
                                          .none, // Remove the underline
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding:
                                      const EdgeInsets.only(top: 10, left: 10),
                                  child: TextField(
                                    controller: email,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                      color: secondaryColor,
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder
                                          .none, // Remove the underline
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(
                  color: secondaryColor,
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('projects')
                      .where("cameramanEmail", isEqualTo: email.text)
                      .snapshots(),
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
                            data: data,
                            projectId: projectId,
                            Cam_id: "9XyqYkGxXqbRoFkaxfADDKEqPr32");
                      }).toList(),
                    );
                  },
                ),
              ],
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
