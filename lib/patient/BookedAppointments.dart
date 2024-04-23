import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doc_appoint/pages/prescription.dart';
import 'package:doc_appoint/patient/patientDetails.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import "package:doc_appoint/pages/prescription.dart";

class BookedAppointments extends StatefulWidget {
  const BookedAppointments({super.key});

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

  bool _isAppointmentPassed(String appointmentDate, String appointmentTime) {
    try {
      final selectedDate = DateTime.parse(appointmentDate);
      final now = DateTime.now();
      final timeParts = appointmentTime.split('-');

      if (timeParts.length != 2) {
        // Invalid time format
        return false;
      }

      final startTime = timeParts[0].trim();
      final endTime = timeParts[1].trim();

      final start = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        int.parse(startTime.split(':')[0]),
        int.parse(startTime.split(':')[1]),
      );
      final end = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        int.parse(endTime.split(':')[0]),
        int.parse(endTime.split(':')[1]),
      );

      return now.isAfter(end);
    } catch (e) {
      // Handle parsing errors
      debugPrint('Error: $e');
      return false;
    }
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
                    final isAppointmentPassed = _isAppointmentPassed(
                        patient['Selected Date'], patient['Selected Slot']);
                    List<String> dismissedItems = [];

                    return Dismissible(
                        onDismissed: (direction) {
                          dismissedItems.add(patient.toString());
                          firestore
                              .collection('Patient')
                              .doc(PatDetails[index].id)
                              .delete();
                          setState(() {
                            PatDetails.removeAt(index);
                          });
                          if (DismissDirection.startToEnd == direction) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Deleted'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        key: Key(patient.toString()),
                        child: InkWell(
                          highlightColor: Colors.blue[800],
                          overlayColor: MaterialStatePropertyAll(
                            Colors.blue[800],
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PrescriptionPage(patient: patient,patientId: PatDetails[index].id,),
                                ));
                          },
                          child: Card(
                            color: Colors.blue[100],
                            child: ListTile(
                              title: Text(
                                'Name: ${patient['First Name']} ${patient['Last Name']}',
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(patient['Selected Date']))}'),
                                  Text('Slot: ${patient['Selected Slot']}'),
                                ],
                              ),
                              trailing: isAppointmentPassed
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : null,
                            ),
                          ),
                        ));
                  },
                );
              } else if (snapshot.hasError) {
                return Text('$snapshot.hasError.toString()');
              } else {
                return const Text('No data found');
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
