import 'package:find_cameraman/homepage.dart';
import 'package:find_cameraman/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(), 
        
        builder: ( context,  snapshot) {
          if(snapshot.hasData){
            return HomePage();
          }else{
            return Login();
          }
          }, ),
    );
  }
}