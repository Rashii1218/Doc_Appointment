import 'package:doc_appoint/auth/login_view.dart';
import 'package:doc_appoint/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';


class DocHomePage extends StatefulWidget {
  const DocHomePage({super.key});

  @override
  State<DocHomePage> createState() => _DocHomePageState();
}

class _DocHomePageState extends State<DocHomePage> {
  late String _imageUrl;
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override

  


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Home Page'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginView(),
                  ),
                ).onError((error, stackTrace) =>
                    Utils().toastmessage(error.toString()));
              });
            },
            icon: const Icon(Icons.logout_outlined),
          )
        ],
      ),
    );
  }
}
