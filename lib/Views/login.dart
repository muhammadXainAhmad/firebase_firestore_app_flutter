import 'package:firestore_storage_app/Utils/constants.dart';
import 'package:flutter/material.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign In.",
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
                padding: const EdgeInsets.only(
                  left: 12.0,
                  right: 12,
                  bottom: 12,
                ),
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
                padding: const EdgeInsets.only(
                  left: 12.0,
                  right: 12,
                  bottom: 8,
                ),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text("SIGN IN", style: TextStyle(color: Colors.white)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("signup");
                },
                child: Text(
                  "Dont Have An Account?",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
