import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doc_appoint/doctor/doc_patientDetails.dart';
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
      debugPrint('Error: $e');
      return false;
    }
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    return Scaffold(
        appBar: AppBar(
          shape: ContinuousRectangleBorder( borderRadius: BorderRadius.circular(40)),
          automaticallyImplyLeading: false,
          title: const Center(
            child: Text('My Appointments',
            style: TextStyle(color: Color.fromARGB(255, 108, 199, 242)),),
          ),
          //backgroundColor: Colors.blue[300],
          //  backgroundColor: Colors.black
          backgroundColor: const Color.fromARGB(255, 3, 41, 72),
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
                      List<Widget> todayAppointments = [];
                      List<Widget> upcomingAppointments = [];
                      List<Widget> pastAppointments = [];

                      for (var patient in patientDetails) {
                        final isAppointmentPassed = _isAppointmentPassed(
                            patient['Selected Date'], patient['Selected Slot']);

                        final isAppointmentToday =
                            _isAppointmentToday(patient['Selected Date']);
                        Widget appointmentCard = InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      docPatientDetails(patient: patient),
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
                                      'Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(patient.data()['Selected Date']))}'),
                                  Text('Slot: ${patient['Selected Slot']}'),
                                ],
                              ),
                              trailing: isAppointmentPassed
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : null,
                            ),
                          ),
                        );
                        if (isAppointmentToday) {
                          todayAppointments.add(appointmentCard);
                        } else if (isAppointmentPassed) {
                          pastAppointments.add(appointmentCard);
                        } else {
                          upcomingAppointments.add(appointmentCard);
                        }
                      }
                      return ListView(
                        children: [
                          if (todayAppointments.isNotEmpty)
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Today's Appointments",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ...todayAppointments,
                          if (upcomingAppointments.isNotEmpty)
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Upcoming Appointments",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ...upcomingAppointments,
                          if (pastAppointments.isNotEmpty)
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Past Appointments",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ...pastAppointments,
                        ],
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
        ));
  }
}
