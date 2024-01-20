import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_cameraman/classes/address.dart';
import 'package:find_cameraman/services/store_services.dart';
import 'package:find_cameraman/utils/colors.dart';
import 'package:find_cameraman/utils/util_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CmanNewProfile extends StatefulWidget {
  final String uid;
  const CmanNewProfile({Key? key, required this.uid}) : super(key: key);

  @override
  State<CmanNewProfile> createState() => _CmanNewProfileState();
}

class _CmanNewProfileState extends State<CmanNewProfile> {


  final user = FirebaseAuth.instance.currentUser;
  StorageMethodes storageMethodes = StorageMethodes();
  var userData = {};
  int followersLength = 0;
  int followingLength = 0;
  bool _isLoading = false;
  bool isMyProfile = false;
  late String cameramanEmail;
  Uint8List? _image;
 bool isFollowing = false;
String _budgetRange = "null";



List<String> followers = [];
  String? Profile;

  TextEditingController budgetRange = TextEditingController(text: "null");
  TextEditingController streetController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController skill = TextEditingController();




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
   // isMyProfile = await _identifyUser();
    setState(() {
      _isLoading = true;
    });
    try {



      var userSnap = await FirebaseFirestore.instance
          .collection('cameramans')
          .doc(widget.uid)
          .get();
      userData = userSnap.data()!;



      // if (userData != null && userData.containsKey('followers')) {
      //   followers = List.from(userData['followers']);
      //   followersLength = followers.length;
      // } else {
      //   // Handle the case when "followers" key is not present or is not a List
      //   followers = [];
      //   followersLength = 0;
      // }
      cameramanEmail = userData["emailAddress"];
      followersLength = userData['followers'].length;
      followingLength = userData['following'].length;
      isFollowing = followers.contains(user!.email);
      budgetRange.text = userData["budgetRange"];

      Map<String, dynamic>? addressData = userData["address"] ?? "null";

      if (addressData != null) {
        streetController.text = addressData["budgetRange"] ?? "null";
        cityController.text = addressData["budgetRange"] ?? "null";
        stateController.text = addressData["state"] ?? "null";
        postalCodeController.text = addressData["postalCode"] ?? "null";
        countryController.text = addressData["country"] ?? "null";
      }
      

      //check if we are following the user or not
      isFollowing = userData['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
    
      setState(() {});
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      showSnakBar(context, error.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> addFollowers() async {
    if (isFollowing = false & isMyProfile ==false) {
      followers.add(user!.uid);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You already  following this cameraman "),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _updateCmantDetails() async {
    if (_image != null) {
      //saveProfile();
    }

    try {
      // Update the client details in Firestore
      await FirebaseFirestore.instance
          .collection("cameramans")
          .where("emailAddress", isEqualTo: user!.email)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) async {
          await doc.reference.update({
            "name": name.text,
            "phoneNumber": phoneNumber.text,
            "followers" :followers,
            "address": {
              "street": streetController!.text,
              "city": streetController.text,
              "state": stateController.text,
              "postalCode": postalCodeController.text,
              "country": countryController.text,
            },
            "profileURL": Profile,
            "budgetRange": budgetRange
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



  Widget build(BuildContext context) {
    return _isLoading
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.yellowAccent,
                              backgroundImage:
                                  NetworkImage(userData['profileURL']),
                              radius: 40,
                            ),
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
                                Row(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: isMyProfile,
                        child: TextButton(
                          onPressed: () {},
                          child: Text("Follow"),
                        ),
                      ), //////
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          userData['phoneNumber'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          userData['name'],
                          style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              color: secondaryColor),
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(
                  color: secondaryColor,
                ),
              ],
            ),
          );
  }
}
