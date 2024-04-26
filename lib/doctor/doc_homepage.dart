// import 'package:flutter/material.dart';
// import 'package:doc_appoint/doctor/doctor_profile.dart';
// import 'package:doc_appoint/doctor/appointments.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class DocHomePage extends StatefulWidget {
//   const DocHomePage({Key? key}) : super(key: key);

//   @override
//   State<DocHomePage> createState() => _DocHomePageState();
// }

// class _DocHomePageState extends State<DocHomePage> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   int currIndex = 0;
//   PageController pageController = PageController();
//   DoctorProfile? doctorProfile;

//   void storeDocProfile() {
//     _firestore
//         .collection('Doctor')
//         .doc(_auth.currentUser!.email)
//         .get()
//         .then((snapshot) {
//       if (snapshot.exists) {
//         setState(() {
//           doctorProfile= DoctorProfile(
//               name: snapshot.data()!['name'],
//               description: snapshot.data()!['description'],
//               email: snapshot.data()!['email'],
//               exp: snapshot.data()!['exp'],
//               fees: snapshot.data()!['fees'],
//               mobileNumber: snapshot.data()!['mobileNumber'],
//               age: snapshot.data()!['age'],
//               speciality: snapshot.data()!['speciality'],
//               uid: _auth.currentUser!.uid,
//               image: snapshot.data()!['image upload']);
//         });
//       } else {
//         // Handle the case where the user document does not exist.
//       }
//     });
//   }

//   void onTapped(int index, BuildContext context) {
//     setState(() {
//       currIndex = index;
//     });
//     if (index == 1 && doctorProfile == null) {
//       storeDocProfile();
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
//           const Appointments(),
//           doctorProfile ?? const Center(child: CircularProgressIndicator()), // Placeholder for DoctorProfile
//         ],
//       ),
//       bottomNavigationBar: SizedBox(
//         height: 80,
//         child: BottomNavigationBar(
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.list_alt),
//               label: 'Appointments',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.person),
//               label: 'My Profile',
//             ),
//           ],
//           currentIndex: currIndex,
//           onTap: (index) => onTapped(index, context), // Pass context here
//         ),
//       ),
//     );
//   }
// }

import 'package:doc_appoint/doctor/doctoravailability.dart';
import 'package:flutter/material.dart';
import 'package:doc_appoint/doctor/doctor_profile.dart';
import 'package:doc_appoint/doctor/appointments.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar.dart';
import 'package:rolling_bottom_bar/rolling_bottom_bar_item.dart';

class DocHomePage extends StatefulWidget {
  const DocHomePage({Key? key}) : super(key: key);

  @override
  State<DocHomePage> createState() => _DocHomePageState();
}

class _DocHomePageState extends State<DocHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int currIndex = 0;
  PageController pageController = PageController();
  DoctorProfile? doctorProfile;

  void initState() {
    super.initState();
    storeDocProfile();
  }

  void storeDocProfile() {
    _firestore
        .collection('Doctor')
        .doc(_auth.currentUser!.email)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          doctorProfile = DoctorProfile(
              name: snapshot.data()!['name'],
              description: snapshot.data()!['description'],
              email: snapshot.data()!['email'],
              exp: snapshot.data()!['exp'],
              fees: snapshot.data()!['fees'],
              mobileNumber: snapshot.data()!['mobileNumber'],
              age: snapshot.data()!['age'],
              speciality: snapshot.data()!['speciality'],
              uid: _auth.currentUser!.uid,
              image: snapshot.data()!['image upload']);
        });
      } else {
        return showDialog(
          context: context,
          builder: (context) =>  AlertDialog(
            title: const Text('No data available'),
            actions: [
               ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            )
            ],
          ),
        );
      }
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
      body: PageView(
        controller: pageController,
        children: [
          const Appointments(),
          DoctorAvailabilityPage( doctorUID: doctorProfile!.uid,),
          doctorProfile != null
              ? doctorProfile!
              : const Center(child: CircularProgressIndicator()),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: RollingBottomBar(
          color: Colors.black,
          controller: pageController,
          activeItemColor: const Color.fromARGB(255, 108, 199, 242),
          items: const [
            RollingBottomBarItem(
              Icons.list_alt,
              //label: 'Appointments',
            ),
             RollingBottomBarItem(
              Icons.event_available,
              //label: 'Appointments',
            ),
            RollingBottomBarItem(
              Icons.person,
              //label: 'My Profile',
            ),
          ],
          onTap: (index) => onTapped(index, context), // Pass context here
        ),
      ),
    );
  }
}
