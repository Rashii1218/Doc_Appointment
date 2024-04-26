// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class UserProfile extends StatefulWidget {
//   final String Name;
//   final String Address;
//   final String Email;
//   final String Mobile;
//   final String Age;
//   final String UID;
//   const UserProfile({super.key, required this.Name,required this.Address,required this.Email, required this .Mobile, required this.Age, required this.UID});

//   @override
//   State<UserProfile> createState() => _UserProfileState();
// }

// class _UserProfileState extends State<UserProfile> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title:  Text(
//           "User Profile",
//           style: GoogleFonts.lora(color: Colors.white,),
//         ),
//         centerTitle: true,
//         backgroundColor: const Color.fromARGB(255, 108, 199, 242),
//       ),
//       body: Container(
//         margin: const EdgeInsets.only(top: 100),
//         height: 500,
//         width: 400,
//         child: Center(
//           child: Card(
//             color: Colors.pink[50],
//             margin: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 20),
//                 Center(
//                   child: Text(
//                     'Name: ${widget.Name}',
//                     style: GoogleFonts.lora(
//                       fontSize: 20,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//                 const Divider(),
//                 const SizedBox(height: 10),
//                 Center(
//                   child: Text(
//                     'Age: ${widget.Age}',
//                     style: GoogleFonts.lora(
//                       fontSize: 20,
//                       color: Colors.black,
//                       // fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const Divider(),
//                 const SizedBox(height: 20),
//                 Center(
//                   child: Text(
//                     'Email: ${widget.Email}',
//                     style: GoogleFonts.lora(
//                       fontSize: 20,
//                       color: Colors.black,
//                       // fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Divider(),
//                 const SizedBox(height: 20),
//                 Center(
//                   child: Text(
//                     'Phone No.: ${widget.Mobile}',
//                     style: GoogleFonts.lora(
//                       fontSize: 20,
//                       color: Colors.black,
//                       // fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const Divider(),
//                 const SizedBox(height: 20),
//                 Center(
//                   child: Text(
//                     'Address: ${widget.Address}',
//                     style: const TextStyle(
//                       fontSize: 20,
//                       color: Colors.black,
//                       // fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const Divider(),
//                 const SizedBox(height: 20),
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // Uncomment this code when you have the EditProfilePage ready
//                       // Navigate to the edit profile page
//                       // Navigator.push(
//                       //     context,
//                       //     MaterialPageRoute(
//                       //         builder: (context) => EditProfilePage(
//                       //             name: widget.name,
//                       //             description: widget.description,
//                       //             email: widget.email,
//                       //             exp: widget.exp,
//                       //             fees: widget.fees,
//                       //             mobileNumber: widget.mobileNumber,
//                       //             age: widget.age,
//                       //             speciality: widget.speciality,
//                       //             uid: widget.uid)));
//                     },
//                     child: Text('Edit Profile',
//                         style: GoogleFonts.lora(color: Colors.black)),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color.fromARGB(255, 108, 199, 242),
//                       textStyle: const TextStyle(fontSize: 18),
//                       padding:
//                           const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

//import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class UserProfile extends StatefulWidget {
//   final String Name;
//   final String Address;
//   final String Email;
//   final String Mobile;
//   final String Age;
//   final String UID;
//   const UserProfile({super.key, required this.Name,required this.Address,required this.Email, required this .Mobile, required this.Age, required this.UID});

//   @override
//   State<UserProfile> createState() => _UserProfileState();
// }

// class _UserProfileState extends State<UserProfile> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Text(
//           "User Profile",
//           style: GoogleFonts.lora(color: Colors.white),
//         ),
//         centerTitle: true,
//         backgroundColor: const Color.fromARGB(255, 108, 199, 242),
//       ),
//       body: Container(
//         margin: const EdgeInsets.only(top: 100),
//         height: 500,
//         width: 400,
//         child: Center(
//           child: Card(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.blue.shade200, Colors.blue.shade400],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             margin: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 20),
//                 Center(
//                   child: CircleAvatar(
//                     radius: 60,
//                     backgroundImage: NetworkImage('https://example.com/profile_picture.jpg'),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.person),
//                       SizedBox(width: 10),
//                       Text(
//                         'Name: ${widget.Name}',
//                         style: GoogleFonts.lora(
//                           fontSize: 20,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Divider(color: Colors.grey.shade600),
//                 const SizedBox(height: 10),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.cake),
//                       SizedBox(width: 10),
//                       Text(
//                         'Age: ${widget.Age}',
//                         style: GoogleFonts.lora(
//                           fontSize: 20,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Divider(color: Colors.grey.shade600),
//                 const SizedBox(height: 20),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.email),
//                       SizedBox(width: 10),
//                       Text(
//                         'Email: ${widget.Email}',
//                         style: GoogleFonts.lora(
//                           fontSize: 20,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Divider(color: Colors.grey.shade600),
//                 const SizedBox(height: 20),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.phone),
//                       SizedBox(width: 10),
//                       Text(
//                         'Phone No.: ${widget.Mobile}',
//                         style: GoogleFonts.lora(
//                           fontSize: 20,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Divider(color: Colors.grey.shade600),
//                 const SizedBox(height: 20),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.location_on),
//                       SizedBox(width: 10),
//                       Text(
//                         'Address: ${widget.Address}',
//                         style: GoogleFonts.lora(
//                           fontSize: 20,
//                           color: Colors.black,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Divider(color: Colors.grey.shade600),
//                 const SizedBox(height: 20),
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // Uncomment this code when you have the EditProfilePage ready
//                       // Navigate to the edit profile page
//                       // Navigator.push(
//                       //     context,
//                       //     MaterialPageRoute(
//                       //         builder: (context) => EditProfilePage(
//                       //             name: widget.name,
//                       //             description: widget.description,
//                       //             email: widget.email,
//                       //             exp: widget.exp,
//                       //             fees: widget.fees,
//                       //             mobileNumber: widget.mobileNumber,
//                       //             age: widget.age,
//                       //             speciality: widget.speciality,
//                       //             uid: widget.uid)));
//                     },
//                     child: Text('Edit Profile',
//                         style: GoogleFonts.lora(color: Colors.white)),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color.fromARGB(255, 108, 199, 242),
//                       textStyle: const TextStyle(fontSize: 18),
//                       padding:
//                           const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                     ),
//                   ),
//                 ),
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
import 'package:google_fonts/google_fonts.dart';

class UserProfile extends StatefulWidget {
  final String Name;
  final String Address;
  final String Email;
  final String Mobile;
  final String Age;
  final String UID;
  const UserProfile(
      {super.key,
      required this.Name,
      required this.Address,
      required this.Email,
      required this.Mobile,
      required this.Age,
      required this.UID});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  FirebaseAuth auth = FirebaseAuth.instance;

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
          "User Profile",
          style: GoogleFonts.lora(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 108, 199, 242),
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
            icon: const Icon(Icons.logout_outlined, color: Colors.black,),
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 30),
        height: 700,
        width: 400,
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 15,
              margin: const EdgeInsets.all(20),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 226, 241, 251),
                      Color.fromARGB(255, 134, 202, 247),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Center(
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 70,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.person),
                          const SizedBox(width: 10),
                          Text(
                            'Name: ${widget.Name}',
                            style: GoogleFonts.lora(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey.shade600),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cake, color: Colors.pink[400],),
                          const SizedBox(width: 10),
                          Text(
                            'Age: ${widget.Age}',
                            style: GoogleFonts.lora(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey.shade600),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.email, color: Colors.blue[800],),
                          const SizedBox(width: 10),
                          Text(
                            'Email: ${widget.Email}',
                            style: GoogleFonts.lora(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey.shade600),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone, color: Colors.green[900],),
                          const SizedBox(width: 10),
                          Text(
                            'Phone No.: ${widget.Mobile}',
                            style: GoogleFonts.lora(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey.shade600),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on, color: Colors.red[900],),
                          const SizedBox(width: 10),
                          Text(
                            'Address: ${widget.Address}',
                            style: GoogleFonts.lora(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
