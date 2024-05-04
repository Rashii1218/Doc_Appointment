import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> setupDoctorAvailability(String doctorUID) async {
  bool ? var1;
  bool ? var2;
  bool ? var3;
  final weekdays = [
    {
      'name': 'Monday',
      'morning': var1,
      'afternoon': var2,
      'evening': var3,
    },
    {
      'name': 'Tuesday',
      'morning': false,
      'afternoon': false,
      'evening': false,
    },
    {
      'name': 'Wednesday',
      'morning': false,
      'afternoon': false,
      'evening': false,
    },
    {
      'name': 'Thursday',
      'morning': false,
      'afternoon': false,
      'evening': false,
    },
    {
      'name': 'Friday',
      'morning': false,
      'afternoon': false,
      'evening': false,
    },
    {
      'name': 'Saturday',
      'morning': false,
      'afternoon': false,
      'evening': false,
    },
    {
      'name': 'Sunday',
      'morning': false,
      'afternoon': false,
      'evening': false,
    },
  ];

  final availabilityRef = FirebaseFirestore.instance
      .collection('doctorAvailability')
      .doc(doctorUID);

  await availabilityRef.set({
    'doctorUID': doctorUID,
    'weekdays': weekdays,
  });
}
