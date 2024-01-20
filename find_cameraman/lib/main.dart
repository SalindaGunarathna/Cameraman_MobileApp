import 'package:find_cameraman/firebase_options.dart';
import 'package:find_cameraman/screens/auth/clientProfile.dart';
import 'package:find_cameraman/screens/auth/cmanNewProfile.dart';
import 'package:find_cameraman/screens/auth/user_profile.dart';
import 'package:find_cameraman/screens/auth/welcome_page.dart';
import 'package:find_cameraman/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cman',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: mobileBackgroundColor,
      ),
       debugShowCheckedModeBanner: false,
      //home:  CmanNewProfile(uid: "9XyqYkGxXqbRoFkaxfADDKEqPr32",), //ClientProfilePage(uid: "6cbDnjHj2AOr8qPDluCA",),
      home: WelcomePage(),
      //WelcomePage() //  
      
      
      //CmanNewProfile(uid: "9XyqYkGxXqbRoFkaxfADDKEqPr32",),
    );
  }
}
