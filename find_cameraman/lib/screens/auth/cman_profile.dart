import 'package:flutter/material.dart';
import 'package:find_cameraman/font_awesome_flutter.dart';
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
