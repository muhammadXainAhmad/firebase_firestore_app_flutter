import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_storage_app/Utils/constants.dart';
import 'package:flutter/material.dart';

class MySignUpPage extends StatefulWidget {
  const MySignUpPage({super.key});

  @override
  State<MySignUpPage> createState() => _MySignUpPageState();
}

class _MySignUpPageState extends State<MySignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (mounted) {
        showSnackBar(context, Colors.green, "Account successfully created!");
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        showSnackBar(context, Colors.red, e.message!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sign Up.",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 12.0,
                right: 12,
                top: 12,
                bottom: 8,
              ),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(color: Colors.black),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: MyConstants.eBorder,
                  focusedBorder: MyConstants.fBorder,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 12),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: TextStyle(color: Colors.black),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: MyConstants.eBorder,
                  focusedBorder: MyConstants.fBorder,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12, bottom: 8),
              child: ElevatedButton(
                onPressed: () async {
                  await createUserWithEmailAndPassword();
                  emailController.clear();
                  passwordController.clear();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text("SIGN UP", style: TextStyle(color: Colors.white)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed("login");
              },
              child: Text(
                "Already Have An Account?",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
