import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/email_auth/login_screen.dart';
import 'package:flutter_firebase/screens/phone_auth/signin_with_phone.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false,
        title: const Text("Home"),
        actions: [
          IconButton(
              onPressed: () {
                logout();
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SigninWithPhone()));
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
    );
  }
}
