// import "package:doc_appoint/pages/HomePage.dart";
// import "package:doc_appoint/patient/BookedAppointments.dart";
// import "package:doc_appoint/patient/User_profile.dart";
// import "package:doc_appoint/patient/medicinetracker.dart";
// import "package:flutter/material.dart";
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({super.key});

//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   int currIndex = 0;
//   PageController pageController = PageController();
//   UserProfile? userProfile;

//   void storeUserProfile() {
//     _firestore
//         .collection('User')
//         .doc(_auth.currentUser!.email)
//         .get()
//         .then((snapshot) {
//       if (snapshot.exists) {
//         setState(() {
//           userProfile = UserProfile(
//             Name: snapshot.data()!['Name'],
//             Email: snapshot.data()!['Email'],
//             Mobile: snapshot.data()!['Mobile'],
//             Age: snapshot.data()!['Age'],
//             Address: snapshot.data()!['Address'],
//             UID: _auth.currentUser!.uid,
//           );
//         });
//       } else {

//       }
//     });
//   }

//    void onTapped(int index, BuildContext context) {
//     setState(() {
//       currIndex = index;
//     });
//     if (index == 1 && userProfile == null) {
//       storeUserProfile();
//     } else {
//       pageController.jumpToPage(index);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         controller: pageController,
//         children: [
//           const HomePage(),
//           const BookedAppointments(),
//           MedicineTrackerPage(),
//           userProfile ?? const Center(child: CircularProgressIndicator()),
//         ],
//       ),
//       bottomNavigationBar: Container(
//         height: 80,
//         child: BottomNavigationBar(
//           unselectedItemColor: Colors.black,
//           type: BottomNavigationBarType.shifting,
//           showUnselectedLabels: true,

//           items: const [
//             BottomNavigationBarItem(
//               label: 'Home',
//               icon: Icon(Icons.home),
//             ),
//             BottomNavigationBarItem(
//               label: 'Appointments',
//               icon: Icon(
//                 Icons.list,
//                 size: 32,
//               ),
//             ),
//             BottomNavigationBarItem(
//               label: 'Medicine\nTracker',
//               icon: Icon(Icons.calendar_month),
//             ),
//             BottomNavigationBarItem(
//               label: 'My Account',
//               icon: Icon(Icons.account_circle),
//             ),
//           ],
//           currentIndex: currIndex,
//           onTap: (index) => onTapped(index, context),
//           selectedItemColor: const Color.fromARGB(255, 108, 199, 242),
//         ),
//       ),
//     );
//   }
// }

import "package:doc_appoint/pages/HomePage.dart";
import "package:doc_appoint/patient/BookedAppointments.dart";
import "package:doc_appoint/patient/User_profile.dart";
import "package:doc_appoint/patient/medicine_homepage.dart";
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar_item.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int currIndex = 0;
  PageController pageController = PageController();
  UserProfile? userProfile;

  void initState() {
    super.initState();
    storeUserProfile();
  }

  void storeUserProfile() {
    _firestore
        .collection('User')
        .doc(_auth.currentUser!.email)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          userProfile = UserProfile(
            Name: snapshot.data()!['Name'],
            Email: snapshot.data()!['Email'],
            Mobile: snapshot.data()!['Mobile'],
            Age: snapshot.data()!['Age'],
            Address: snapshot.data()!['Address'],
            UID: _auth.currentUser!.uid,
          );
        });
      } else {}
    });
  }

  void onTapped(int index, BuildContext context) {
    setState(() {
      currIndex = index;
    });

    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: PageView(
          controller: pageController,
          children: [
            const HomePage(),
            const BookedAppointments(),
            MedicineHome(),
            userProfile != null
                ? userProfile!
                : const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),

      bottomNavigationBar: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          height: 80,
          child: RollingBottomBar(
            color: Colors.black,
            controller: pageController,
            flat: true,
            //useActiveColorByDefault: false,
            activeItemColor: const Color.fromARGB(255, 108, 199, 242),
            items: const [
              RollingBottomBarItem(
                //label: 'Home',
                Icons.home,
              ),
              RollingBottomBarItem(
                //label: 'Appointments',
                Icons.list,
              ),
              RollingBottomBarItem(
                // label: 'Medicine\nTracker',
                Icons.calendar_month,
              ),
              RollingBottomBarItem(
                //label: 'My Account',
                Icons.account_circle,
              ),
            ],
            onTap: (index) => onTapped(index, context),
            enableIconRotation: true,
          ),
        ),
      ),
    );
  }
}
