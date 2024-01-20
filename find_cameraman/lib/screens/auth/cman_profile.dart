


import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CmanProfile extends StatefulWidget {
  const CmanProfile({super.key});

  @override
  State<CmanProfile> createState() => _CmanProfileState();
}

class _CmanProfileState extends State<CmanProfile> {
  // final double profileHeight = 144;


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        buidTop(),
        buildContent(),
      ],
    ));
  }
}

Widget buildContent() => Column(
      children: [
        const SizedBox(height: 8),
        const Text('Ranga Dana',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text('1.5K Followers',
            style: TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildSocialIcon(FontAwesomeIcons.youtube),
            const SizedBox(width: 12),
            buildSocialIcon(FontAwesomeIcons.whatsapp),
            const SizedBox(width: 12),
            buildSocialIcon(FontAwesomeIcons.phone),
          ],
        ),
        const SizedBox(height: 16),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  'Flutter is nice machaan',
                  style: TextStyle(fontSize: 18, height: 1.4),
                ),
              ],
            ),
          ),
        ),
      ],
    );

Widget buildSocialIcon(IconData icon) => CircleAvatar(
      radius: 25,
      child: Material(
          shape: CircleBorder(),
          clipBehavior: Clip.hardEdge,
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: Center(child: Icon(icon, size: 32)),
          )),
    );

Widget buidTop() {
  return Stack(
    clipBehavior: Clip.none,
    alignment: Alignment.center,
    children: [
      Container(
        margin: EdgeInsets.only(bottom: 72),
        child: buidCoverImage(),
      ),
      Positioned(
        top: 208,
        child: buidProPic(),
      )
    ],
  );
}

Widget buidCoverImage() => Container(
      color: Colors.black,
      child: Image.network(
        "https://images.unsplash.com/photo-1474552226712-ac0f0961a954?q=80&w=871&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
        width: double.infinity,
        height: 280,
        fit: BoxFit.cover,
      ),
    );

Widget buidProPic() => CircleAvatar(
      radius: 72,
      backgroundColor: Colors.grey.shade800,
      backgroundImage: NetworkImage(
        "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
      ),
    );
































// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:find_cameraman/classes/project.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:find_cameraman/font_awesome_flutter.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class CmanProfile extends StatefulWidget {
//   const CmanProfile({super.key});

//   @override
//   State<CmanProfile> createState() => _CmanProfileState();
// }

// class _CmanProfileState extends State<CmanProfile> {
//   // final double profileHeight = 144;

//   final user = FirebaseAuth.instance.currentUser;

//   Project? newProject;
//   Uint8List? _image;
//   String? Url;

//   String Projecname = " ";

//   final TextEditingController description = TextEditingController();
//   final TextEditingController cameramanName = TextEditingController();
//   final TextEditingController cameramanEmail = TextEditingController();
//   final TextEditingController cameramanId = TextEditingController();
//   final TextEditingController projectDate = TextEditingController();
//   final TextEditingController projectName = TextEditingController(text: " ");
//   final TextEditingController projectImage = TextEditingController();

//   List<String> projectImagesList = [];

//   @override
//   void initState() {
//     super.initState();
//     _getUserName();
//   }

//   Future<void> _getUserName() async {
//     final FirebaseFirestore firestore = FirebaseFirestore.instance;
//     final QuerySnapshot querySnapshot = await firestore
//         .collection("cameramans")
//         .where("emailAddress", isEqualTo: user!.email)
//         .get();
//     final List<DocumentSnapshot> documents = querySnapshot.docs;
//     if (documents.isNotEmpty) {
//       final DocumentSnapshot document = documents.first;
//       cameramanName.text = document["name"];
//       cameramanEmail.text = document["emailAddress"];
//       cameramanId.text = document["userID"];
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: ListView(
//       padding: EdgeInsets.zero,
//       children: <Widget>[
//         buidTop(),
//         Column(
//           children: [
//             const SizedBox(height: 8),
//             TextField(
//                 controller: cameramanName,
//                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 4),
//             const Text('1.5K Followers',
//                 style: TextStyle(fontSize: 16, color: Colors.grey)),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 buildSocialIcon(FontAwesomeIcons.youtube),
//                 const SizedBox(width: 12),
//                 buildSocialIcon(FontAwesomeIcons.whatsapp),
//                 const SizedBox(width: 12),
//                 buildSocialIcon(FontAwesomeIcons.phone),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'About',
//                       style:
//                           TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 16),
//                     Text(
//                       'Flutter is nice machaan',
//                       style: TextStyle(fontSize: 18, height: 1.4),
//                     ),
//                     TextField(
//                         controller: cameramanEmail,
//                         style: TextStyle(
//                             fontSize: 28, fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 4),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     ));
//   }
// }

// Widget buildSocialIcon(IconData icon) => CircleAvatar(
//       radius: 25,
//       child: Material(
//           shape: CircleBorder(),
//           clipBehavior: Clip.hardEdge,
//           color: Colors.transparent,
//           child: InkWell(
//             onTap: () {},
//             child: Center(child: Icon(icon, size: 32)),
//           )),
//     );

// Widget buidTop(Uint8List image) {
//   return Stack(
//     clipBehavior: Clip.none,
//     alignment: Alignment.center,
//     children: [
//       Container(
//         margin: EdgeInsets.only(bottom: 72),
//         child: buidCoverImage(),
//       ),
//       Positioned(
//         top: 208,
//         child: buidProPic(image!),
//       )
//     ],
//   );
// }

// Widget buidCoverImage() => Container(
//       color: Colors.black,
//       child: Image.network(
//         "https://images.unsplash.com/photo-1474552226712-ac0f0961a954?q=80&w=871&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
//         width: double.infinity,
//         height: 280,
//         fit: BoxFit.cover,
//       ),
//     );

// Widget buidProPic() => Stack(
//       children: [
//         _image != null
//             ? CircleAvatar(
//                 radius: 64,
//                 backgroundImage: MemoryImage(_image!),
//               )
//             : const CircleAvatar(
//                 radius: 64,
//                 backgroundImage: NetworkImage(
//                     "https://thumbs.dreamstime.com/b/businessman-icon-vector-male-avatar-profile-image-profile-businessman-icon-vector-male-avatar-profile-image-182095609.jpg"),
//               ),
//         Positioned(
//           child: IconButton(
//             onPressed: () {
//               //selectImage();
//             },
//             icon: const Icon(Icons.add_a_photo),
//           ),
//           bottom: -10,
//           left: 88,
//         )
//       ],
//     );
