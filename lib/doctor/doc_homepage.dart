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

// import 'package:doc_appoint/doctor/doctoravailability.dart';
// import 'package:flutter/material.dart';
// import 'package:doc_appoint/doctor/doctor_profile.dart';
// import 'package:doc_appoint/doctor/appointments.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rolling_bottom_bar/rolling_bottom_bar.dart';
// import 'package:rolling_bottom_bar/rolling_bottom_bar_item.dart';

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

//   void initState() {
//     super.initState();
//     storeDocProfile();
//   }

//   storeDocProfile() async {
//     await _firestore
//         .collection('Doctor')
//         .doc(_auth.currentUser!.email)
//         .get()
//         .then((snapshot) {
//       if (snapshot.exists) {
//         setState(() {
//           doctorProfile = DoctorProfile(
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
//         return showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('No data available'),
//             actions: [
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: const Text('Cancel'),
//               )
//             ],
//           ),
//         );
//       }
//     });
//   }

//   void onTapped(int index, BuildContext context) {
//     setState(() {
//       currIndex = index;
//     });
//     pageController.animateToPage(
//       index,
//       duration: const Duration(milliseconds: 400),
//       curve: Curves.easeOut,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: doctorProfile != null
//           ? PageView(controller: pageController, children: [
//               const Appointments(),
//               if (doctorProfile != null)
//                 DoctorAvailabilityPage(doctorUID: doctorProfile!.uid),
//               if (doctorProfile != null) doctorProfile!,
//             ])
//           : const CircularProgressIndicator(),
//       bottomNavigationBar: SizedBox(
//         height: 80,
//         child: RollingBottomBar(
//           color: Colors.black,
//           controller: pageController,
//           activeItemColor: const Color.fromARGB(255, 108, 199, 242),
//           items: const [
//             RollingBottomBarItem(
//               Icons.list_alt,
//               //label: 'Appointments',
//             ),
//             RollingBottomBarItem(
//               Icons.event_available,
//               //label: 'Appointments',
//             ),
//             RollingBottomBarItem(
//               Icons.person,
//               //label: 'My Profile',
//             ),
//           ],
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

  Future<DoctorProfile>? futureDoctorProfile;

  @override
  void initState() {
    super.initState();
    futureDoctorProfile = storeDocProfile();
  }

  Future<DoctorProfile> storeDocProfile() async {
    final snapshot = await _firestore
        .collection('Doctor')
        .doc(_auth.currentUser!.email)
        .get();

    if (snapshot.exists) {
      return DoctorProfile(
        name: snapshot.data()!['name'],
        description: snapshot.data()!['description'],
        email: snapshot.data()!['email'],
        exp: snapshot.data()!['exp'],
        Regno: snapshot.data()!['Regno'],
        fees: snapshot.data()!['fees'],
        mobileNumber: snapshot.data()!['mobileNumber'],
        age: snapshot.data()!['age'],
        speciality: snapshot.data()!['speciality'],
        uid: _auth.currentUser!.uid,
        image: snapshot.data()!['image upload'],
      );
    } else {
      // Return a default DoctorProfile or handle the case when data is not available
      return const DoctorProfile(
        name: 'Default Name',
        description: 'Default Description',
        email: 'default@example.com',
        exp: 'Default Experience',
        Regno: "A111111111",
        fees: 'Default Fees',
        mobileNumber: 'Default Mobile Number',
        age: '30',
        speciality: 'Default Speciality',
        uid: 'Default UID',
        image: 'default_image.jpg',
      );
    }
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
      body: FutureBuilder<DoctorProfile>(
        future: futureDoctorProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final doctorProfile = snapshot.data!;

            return PageView(
              controller: pageController,
              children: [
                const Appointments(),
                DoctorAvailabilityPage(doctorUID: doctorProfile.uid),
                doctorProfile,
              ],
            );
          }
        },
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: RollingBottomBar(
          color: const Color.fromARGB(255, 3, 41, 72),
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
          onTap: (index) => onTapped(index, context),
        ),
      ),
    );
  }
}
