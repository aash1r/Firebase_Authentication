import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/phone_auth/signin_with_phone.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController namecontroller = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void saveUser() async {
    String name = namecontroller.text.trim();
    String email = emailcontroller.text.trim();

    namecontroller.clear();
    emailcontroller.clear();

    if (name != "" && email != "") {
      await firestore.collection("Users").add({"name": name, "email": email});
    } else {
      print("Please fill all the fields");
    }
  }

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
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(
              controller: namecontroller,
              decoration: const InputDecoration(hintText: "Name"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: emailcontroller,
              decoration: const InputDecoration(hintText: "Email address"),
            ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              color: Colors.teal,
              onPressed: () {
                saveUser();
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream: firestore.collection("Users").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            Map userMap = snapshot.data!.docs[index].data();
                            return ListTile(
                              title: Text(userMap["name"]),
                              subtitle: Text(userMap["email"]),
                              trailing: IconButton(
                                  onPressed: () {
                                    snapshot.data!.docs[index].reference
                                        .delete();
                                  },
                                  icon: const Icon(Icons.delete)),
                            );
                          }),
                    );
                  } else {
                    const Text("No Data!");
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return const Text("hehe");
              },
            ),
          ],
        ),
      ),
    );
  }
}
