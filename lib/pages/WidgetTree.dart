//import 'package:firebase_auth/firebase_auth.dart';
import 'package:doc_appoint/auth/auth.dart';
import 'package:doc_appoint/auth/login_view.dart';
import 'package:doc_appoint/pages/homepage.dart';
// import 'package:mediapp/auth.dart';
// import 'package:mediapp/home.dart';
// import 'package:mediapp/views/login_view/login_view.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return HomePage();
        }else{
          return const LoginView();
        }
      },
    );
  }
}