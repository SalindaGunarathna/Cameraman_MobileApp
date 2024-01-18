import 'package:find_cameraman/screens/auth/login.dart';
import 'package:find_cameraman/screens/auth/cman_reg_screen.dart';

import 'package:find_cameraman/screens/auth/user_reg_screen.dart';
import 'package:find_cameraman/widgets/button.dart';
import 'package:find_cameraman/wrapper.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            Image.asset(
              'assets/logowhite.png',
              height: 150,
            ),
            const SizedBox(
              height: 25,
            ),
            const Center(
              child: Text(
                "What are you looking for?",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Image.asset(
              'assets/welcome.png',
              height: 120,
            ),
            const SizedBox(
              height: 15,
            ),
            const Center(
              child: Text(
                "We will help you make your day memorable.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            Positioned(
              bottom: 0,
              child: SubmitButton(
                  text: "Login Here",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ));
                  }),
            ),
            const SizedBox(
              height: 15,
            ),
            SubmitButton(
                text: "Register as a cameraman",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CmanRegScn(),
                      ));
                }),
            const SizedBox(
              height: 15,
            ),
            SubmitButton(
                text: "Register as a customer",
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserReg(),
                      ));
                }),
            const SizedBox(
              height: 35,
            ),
          ]),
        ),
      ),
    );
  }
}
