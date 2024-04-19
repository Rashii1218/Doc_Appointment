import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookedAppointments extends StatefulWidget {
  BookedAppointments({
    super.key,
  });

  @override
  State<BookedAppointments> createState() => _BookedAppointmenState();
}

class _BookedAppointmenState extends State<BookedAppointments> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> PatDetails = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;
  String? errorMessage = '';

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        _user = user;
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : '$errorMessage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Appointments'),
        backgroundColor: const Color.fromARGB(255, 108, 199, 242),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder(
            stream: firestore
                .collection('Patient')
                .where('Patient Uid', isEqualTo: _user?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  PatDetails = snapshot.data!.docs.toList();
                  return ListView.builder(
                    itemCount: PatDetails.length,
                    itemBuilder: (context, index) {
                      final patient = PatDetails[index].data();
                      return Card(
                        color: Colors.blue[100],
                        child: ListTile(
                            title: Text(
                                'Name: ${patient['First Name']} ${patient['Last Name']}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Date: ${patient['Selected Date']}'),
                                Text('Slot: ${patient['Selected Slot']}'),
                              ],
                            )),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.hasError.toString()}');
                } else {
                  return Text('No data found');
                }
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
