import 'package:find_cameraman/homepage.dart';
import 'package:find_cameraman/screens/auth/addProject.dart';
import 'package:find_cameraman/screens/auth/clientBooking.dart';
import 'package:find_cameraman/screens/auth/clientProfile.dart';
import 'package:find_cameraman/screens/auth/welcome_page.dart';
import 'package:find_cameraman/widgets/button.dart';
import 'package:find_cameraman/widgets/textfield.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  signIn() async {


   
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.text, password: password.text);
      print("Login successful");

      // Navigate to the booking page on successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      print("Error signing in: $e");
      // Handle sign-in errors if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            Image.asset(
              'assets/logoyellow.png',
              height: 150,
            ),
            const SizedBox(
              height: 35,
            ),

            // email
            TextInputField(
              controller: email,
              isPassword: false,
              inputkeyboardType: TextInputType.emailAddress,
              hintText: "Enter Email",
            ),
            const SizedBox(
              height: 15,
            ),

            // password
            TextInputField(
              controller: password,
              isPassword: true,
              inputkeyboardType: TextInputType.emailAddress,
              hintText: "Enter Email",
            ),
            const SizedBox(
              height: 35,
            ),

            SubmitButton(text: "Log in", onPressed: signIn),
            const SizedBox(
              height: 35,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Don\'t have an account?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WelcomePage(),
                        ));
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    )));
  }
}

