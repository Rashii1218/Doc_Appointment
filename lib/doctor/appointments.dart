import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doc_appoint/auth/login_view.dart';
import 'package:doc_appoint/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Appointments extends StatefulWidget {
  const Appointments({super.key});

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> patientDetails = [];
  User? _user;
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

  bool _isAppointmentToday(String appointmentDate) {
    final selectedDate = DateTime.parse(appointmentDate);
    final now = DateTime.now();
    return selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;
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

  final FirebaseAuth auth = FirebaseAuth.instance;

  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime secondDay = now.add(const Duration(days: 1));
    DateTime thirdDay = now.add(const Duration(days: 2));

    String formatNow = DateFormat('EEE, MMM d').format(now);
    String formatSec = DateFormat('EEE, MMM d').format(secondDay);
    String formatThird = DateFormat('EEE, MMM d').format(thirdDay);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('My Appointments'),
            backgroundColor: Colors.blue[300],
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
                icon: const Icon(Icons.logout_outlined),
              )
            ],
            bottom: TabBar(tabs: [
              Tab(
                text: formatNow,
              ),
              Tab(
                text: formatSec,
              ),
              Tab(
                text: formatThird,
              ),
            ]),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(top: 10),
              margin: const EdgeInsetsDirectional.all(5),
              height: MediaQuery.of(context).size.height,
              child: StreamBuilder(
                  stream: firestore
                      .collection('Patient')
                      .where('Doctor UID', isEqualTo: _user?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        patientDetails = snapshot.data!.docs.toList();
                        return ListView.builder(
                          itemCount: patientDetails.length,
                          itemBuilder: (context, index) {
                            final patient = patientDetails[index].data();
                            final isAppointmentPassed = _isAppointmentPassed(
                                patient['Selected Date'],
                                patient['Selected Slot']);
                            final isAppointmentToday =
                                _isAppointmentToday(patient['Selected Date']);
                            if (isAppointmentToday) {
                              return Column(
                                children: [
                                  Text("Today's Appointments"),
                                  Card(
                                    color: Colors.blue[100],
                                    child: ListTile(
                                      title: Text(
                                        'Name: ${patient['First Name']} ${patient['Last Name']}',
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Date: ${patient['Selected Date']}'),
                                          Text(
                                              'Slot: ${patient['Selected Slot']}'),
                                        ],
                                      ),
                                      trailing: isAppointmentPassed
                                          ? const Icon(Icons.check,
                                              color: Colors.green)
                                          : null,
                                    ),
                                  )
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  const Text("Upcoming Appointments"),
                                  Card(
                                    color: Colors.blue[100],
                                    child: ListTile(
                                      title: Text(
                                        'Name: ${patient['First Name']} ${patient['Last Name']}',
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Date: ${patient['Selected Date']}'),
                                          Text(
                                              'Slot: ${patient['Selected Slot']}'),
                                        ],
                                      ),
                                      trailing: isAppointmentPassed
                                          ? const Icon(Icons.check,
                                              color: Colors.green)
                                          : null,
                                    ),
                                  )
                                ],
                              );
                            }
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text('$snapshot.hasError.toString()');
                      } else {
                        return const Text('No Appointments');
                      }
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
            ),
          )),
    );
  }
}
