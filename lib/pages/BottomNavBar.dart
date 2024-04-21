import "package:doc_appoint/pages/HomePage.dart";
import "package:doc_appoint/pages/prescription.dart";
import "package:flutter/material.dart";
import 'package:doc_appoint/patient/medicinetracker.dart';

class BottomNavBar extends StatefulWidget {
   BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currIndex = 0;
  PageController pageController = PageController();

  void onTapped(int index) {
    setState(() {
      currIndex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: [
          const HomePage(),
          MedicineTrackerPage(),
          PrescriptionPage(),
          const HomePage(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 80,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: 'Medicine\nTracker',
              icon: Icon(Icons.calendar_month),
            ),
            BottomNavigationBarItem(
              label: 'Prescription',
              icon: Icon(Icons.receipt),
            ),
            BottomNavigationBarItem(
              label: 'My Account',
              icon: Icon(Icons.account_circle),
            ),
          ],
          currentIndex: currIndex,
          onTap: onTapped,
          selectedItemColor: const Color.fromARGB(255, 108, 199, 242),
        ),
      ),
    );
  }
}
