import 'package:doc_appoint/auth/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:mediapp/auth.dart';

class Homepage extends StatelessWidget{
  Homepage({Key? key}) : super(key:key);

  final User? user = Auth().currentUser;

  Future<void> signOut() async{
  await Auth().signOut();
}

Widget title(){
  return const Text("Firebase Auth");
}

Widget userUid(){
  return  Text(user?.email ?? 'User email');
}

Widget signOutButton(){
  return ElevatedButton(
    onPressed: signOut, 
    child: const Text("Sign Out"),
    );
}
@override 
Widget build(BuildContext context){
  return Scaffold(
    appBar: AppBar(
      title: title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            userUid(),
            signOutButton(),
          ],
        )
      ),
  );
}
}