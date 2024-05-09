// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class DoctorProfile extends StatefulWidget {
//   final String name;
//   final String description;
//   final String email;
//   final String exp;
//   final String fees;
//   final String mobileNumber;
//   final String age;
//   final String speciality;
//   final String uid;
//   final String image;

//   const DoctorProfile(
//       {Key? key,
//       required this.name,
//       required this.description,
//       required this.email,
//       required this.exp,
//       required this.fees,
//       required this.mobileNumber,
//       required this.age,
//       required this.speciality,
//       required this.uid,
//       required this.image})
//       : super(key: key);

//   @override
//   _DoctorProfileState createState() => _DoctorProfileState();
// }

// class _DoctorProfileState extends State<DoctorProfile> {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text(
//           "Your Profile",
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//         backgroundColor: const Color.fromARGB(255, 108, 199, 242),
//       ),
//       body: Center(
//         child: Container(
//           padding: EdgeInsets.all(15),
//           height: 500,
//           width: MediaQuery.of(context).size.width,
//           child: Card(
//             color: Colors.pink[50],
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 20),
//                 CircleAvatar(
//                   radius: 60,
//                   backgroundColor: const Color.fromARGB(255, 108, 199, 242),
//                   backgroundImage: widget.image != null
//                       ? NetworkImage(widget.image)
//                       : null,
//                   child: widget.image == null
//                       ? const Icon(Icons.person,
//                           color: Colors.white,
//                           size: 60)
//                       : null,
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   'Name: ${widget.name}',
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   'Description: ${widget.description}',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   'Speciality: ${widget.speciality}',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   'Email: ${widget.email}',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   'Age: ${widget.age}      Experience: ${widget.exp}     Fees: ${widget.fees}',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   'Phone No.: ${widget.mobileNumber}',
//                   style: const TextStyle(
//                     fontSize: 18,
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:doc_appoint/auth/login_view.dart';
import 'package:doc_appoint/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorProfile extends StatefulWidget {
  final String name;
  final String description;
  final String email;
  final String exp;
  final String? Regno;
  final String fees;
  final String mobileNumber;
  final String age;
  final String speciality;
  final String uid;
  final String? image;

  const DoctorProfile({
    Key? key,
    required this.name,
    required this.description,
    required this.email,
    required this.exp,
    required this.Regno,
    required this.fees,
    required this.mobileNumber,
    required this.age,
    required this.speciality,
    required this.uid,
    this.image,
  }) : super(key: key);

  @override
  _DoctorProfileState createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.horizontal(
                left: Radius.circular(30), right: Radius.circular(30))),
        automaticallyImplyLeading: false,
        title: Text(
          "Your Profile",
          style: GoogleFonts.lora(color: const Color.fromARGB(255, 108, 199, 242), fontSize: 24),
        ),
        centerTitle: true,
        // backgroundColor: const Color.fromARGB(255, 108, 199, 242),
        // backgroundColor: Colors.black,
        backgroundColor: const Color.fromARGB(255, 3, 41, 72),
        actions: [
          IconButton(
            color: const Color.fromARGB(255, 108, 199, 242),
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
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.only(top: 80),
            padding: const EdgeInsets.all(20),
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 226, 241, 251), 
                      Color.fromARGB(255, 179, 218, 244),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor:
                            const Color.fromARGB(255, 108, 199, 242),
                        backgroundImage: widget.image != null
                            ? NetworkImage(widget.image!)
                            : null,
                        child: widget.image == null
                            ? const Icon(Icons.person,
                                color: Colors.white, size: 60)
                            : null,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.name,
                        style: GoogleFonts.lora(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.description,
                        style: GoogleFonts.lora(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Speciality: ${widget.speciality}',
                        style: GoogleFonts.lora(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.email_outlined,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Email: ${widget.email}',
                            style: GoogleFonts.lora(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today, color: Colors.blue[700]),
                          const SizedBox(width: 10),
                          Text(
                            'Experience: ${widget.exp} years',
                            style: GoogleFonts.lora(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.currency_rupee_sharp,
                              color: Colors.green[700]),
                          const SizedBox(width: 10),
                          Text(
                            'Fees: Rs ${widget.fees}',
                            style: GoogleFonts.lora(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cake, color: Colors.pink[700]),
                          const SizedBox(width: 10),
                          Text(
                            'Age: ${widget.age}',
                            style: GoogleFonts.lora(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone, color: Colors.green[700]),
                          const SizedBox(width: 10),
                          Text(
                            'Phone: ${widget.mobileNumber}',
                            style: GoogleFonts.lora(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                            'Registration Number: ${widget.Regno}',
                            style: GoogleFonts.lora(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),

                  
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
