import 'package:doc_appoint/doctor/appointments.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DocHomePage extends StatefulWidget {
  const DocHomePage({super.key});

  @override
  State<DocHomePage> createState() => _DocHomePageState();
}

class _DocHomePageState extends State<DocHomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  int currIndex = 0;
  PageController pagecontroller = PageController();
  onTapped(int index) {
    setState(() {
      currIndex = index;
    });
    pagecontroller.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: PageView(
        controller: pagecontroller,
        children: const [
          Appointments(),
          Center(child: Text('Profile page'),)
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.list_alt), label: 'Appointments'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'My Profile'),
          ],
          currentIndex: currIndex,
          onTap: onTapped,
        ),
      ),

    );
  }
}
