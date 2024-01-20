import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_cameraman/utils/colors.dart';
import 'package:find_cameraman/utils/util_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  final String uid;
  const UserProfile({Key? key, required this.uid}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  var userData = {};
  int followingLength = 0;
  bool _isLoadnig = false;

  bool isFollowing = false;

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
      var userSnap = await FirebaseFirestore.instance
          .collection('clients')
          .doc(widget.uid)
          .get();
      userData = userSnap.data()!;

      followingLength = userData['following'].length;
      //check if we are following the user or not
      isFollowing = userData['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      //update the ui this is a must so we can see the changes
      // telling Flutter that the internal state of the widget has changed and that the UI should be rebuilt to reflect this change.
      setState(() {
        _isLoadnig = false;
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

  Widget build(BuildContext context) {
    return _isLoadnig
        ? const Center(
            child: CircularProgressIndicator(),
          )
        :  Scaffold(
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
                              backgroundImage: NetworkImage(userData['profileURL']),
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
                                        number: followingLength,
                                        lable: "Following"),
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
                        child: Text(
                          userData['name'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          userData['phoneNumber'],
                          style: const TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              color: secondaryColor),
                        ),
                      ),
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
