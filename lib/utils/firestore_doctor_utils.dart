// import 'package:cloud_firestore/cloud_firestore.dart';

// Future<void> setupDoctorAvailability(String doctorUID) async {
//   final weekdays = [
//     'Monday',
//     'Tuesday',
//     'Wednesday',
//     'Thursday',
//     'Friday',
//     'Saturday',
//     'Sunday',
//   ];

//   for (final weekday in weekdays) {
//     final availabilityRef = FirebaseFirestore.instance
//         .collection('doctorAvailability')
//         .doc('$doctorUID\_$weekday');

//     await availabilityRef.set({
//       'doctorUID': doctorUID,
//       'weekday': weekday.toLowerCase(),
//       'morning': false,
//       'afternoon': false,
//       'evening': false,
//     });
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> setupDoctorAvailability(String doctorUID) async {
  final weekdays = [
    {
      'name': 'Monday',
      'morning': false,
      'afternoon': false,
      'evening': false,
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