import 'package:firebase_core/firebase_core.dart';
import 'package:firestore_storage_app/Views/home.dart';
import 'package:firestore_storage_app/Views/login.dart';
import 'package:firestore_storage_app/Views/signup.dart';
import 'package:firestore_storage_app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {
        "login": (context) => const MyLoginPage(),
        "signup": (context) => const MySignUpPage(),
      },
      home: MyHomePage(),
    );
  }
}
