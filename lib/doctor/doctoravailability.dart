// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class DoctorAvailability extends StatefulWidget {
//   const DoctorAvailability({Key? key}) : super(key: key);

//   @override
//   _DoctorAvailabilityState createState() => _DoctorAvailabilityState();
// }

// class _DoctorAvailabilityState extends State<DoctorAvailability> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   List<String> morningSlots = [
//     '8:00 - 8:30',
//     '8:30 - 9:00',
//     '9:00 - 9:30',
//     '9:30 - 10:00',
//     '10:00 - 10:30',
//     '10:30 - 11:00',
//   ];

//   List<String> afternoonSlots = [
//     '11:00 - 11:30',
//     '11:30 - 12:00',
//     '12:00 - 12:30',
//     '12:30 - 13:00',
//     '16:00 - 16:30',
//     '16:30 - 17:00',
//   ];

//   List<String> eveningSlots = [
//     '17:00 - 17:30',
//     '17:30 - 18:00',
//     '18:00 - 18:30',
//     '18:30 - 19:00',
//     '19:00 - 19:30',
//     '19:30 - 20:00',
//   ];

//   List<bool> morningSelected = List.filled(6, false);
//   List<bool> afternoonSelected = List.filled(6, false);
//   List<bool> eveningSelected = List.filled(6, false);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Center(child: Text('Doctor Availability')),
//         backgroundColor: const Color.fromARGB(255, 108, 199, 242),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Morning Slots',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               Column(
//                 children: List.generate(morningSlots.length, (index) {
//                   return CheckboxListTile(
//                     title: Text(morningSlots[index]),
//                     value: morningSelected[index],
//                     onChanged: (value) {
//                       setState(() {
//                         morningSelected[index] = value!;
//                       });
//                     },
//                   );
//                 }),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Afternoon Slots',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               Column(
//                 children: List.generate(afternoonSlots.length, (index) {
//                   return CheckboxListTile(
//                     title: Text(afternoonSlots[index]),
//                     value: afternoonSelected[index],
//                     onChanged: (value) {
//                       setState(() {
//                         afternoonSelected[index] = value!;
//                       });
//                     },
//                   );
//                 }),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Evening Slots',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               Column(
//                 children: List.generate(eveningSlots.length, (index) {
//                   return CheckboxListTile(
//                     title: Text(eveningSlots[index]),
//                     value: eveningSelected[index],
//                     onChanged: (value) {
//                       setState(() {
//                         eveningSelected[index] = value!;
//                       });
//                     },
//                   );
//                 }),
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   // Save the doctor's availability preferences to Firestore
//                   _saveAvailability();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color.fromARGB(255, 108, 199, 242),
//                 ),
//                 child: const Center(child: Text('Save Availability')),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _saveAvailability() {

//     final doctorUID = _auth.currentUser!.uid;
//     debugPrint(doctorUID);

   
//     Map<String, List<bool>> availabilityData = {
//       'morning': morningSelected,
//       'afternoon': afternoonSelected,
//       'evening': eveningSelected,
//     };

//     _firestore.collection('Doctor Availability').doc(doctorUID).get().then((doc) {
//       if (doc.exists) {
        
//         _firestore.collection('Doctor Availability').doc(doctorUID).update({
//           'availability': availabilityData,
//         });
//       } else {
        
//         _firestore.collection('Doctor Availability').doc(doctorUID).set({
//           'availability': availabilityData,
//         });
//       }
//     }).catchError((error) {
//       debugPrint('Error updating availability: $error');
//     });
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class DoctorAvailabilityPage extends StatefulWidget {
//   final String doctorUID;
//   const DoctorAvailabilityPage({super.key, required this.doctorUID});

//   @override
//   State<DoctorAvailabilityPage> createState() => _DoctorAvailabilityPageState();
// }

// class _DoctorAvailabilityPageState extends State<DoctorAvailabilityPage> {
//   Map<String, bool> availability = {
//     'Monday': false,
//     'Tuesday': false,
//     'Wednesday': false,
//     'Thursday': false,
//     'Friday': false,
//     'Saturday': false,
//     'Sunday': false,
//   };

//   @override
//   void initState() {
//     super.initState();
//     fetchDoctorAvailability();
//   }

//   Future<void> fetchDoctorAvailability() async {
//     final availabilitySnapshot = await FirebaseFirestore.instance
//         .collection('doctorAvailability')
//         .where('doctorUID', isEqualTo: widget.doctorUID)
//         .get();

//     for (final doc in availabilitySnapshot.docs) {
//       final data = doc.data();
//       final weekday = data['weekday'];
//       final morning = data['morning'] ?? false;
//       final afternoon = data['afternoon'] ?? false;
//       final evening = data['evening'] ?? false;

//       setState(() {
//         availability[weekday] = morning || afternoon || evening;
//       });
//     }
//   }

//   Future<void> updateDoctorAvailability(String weekday, bool isAvailable) async {
//     final availabilityRef = FirebaseFirestore.instance
//         .collection('doctorAvailability')
//         .doc('${widget.doctorUID}_$weekday');

//     await availabilityRef.set({
//       'doctorUID': widget.doctorUID,
//       'weekday': weekday.toLowerCase(),
//       'morning': isAvailable,
//       'afternoon': isAvailable,
//       'evening': isAvailable,
//     }, SetOptions(merge: true));

//     setState(() {
//       availability[weekday] =isAvailable;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text('Doctor Availability'),
//       ),
//       body: ListView.builder(
//         itemCount: availability.entries.length,
//         itemBuilder: (context, index) {
//           final entry = availability.entries.elementAt(index);
//           final weekday = entry.key;
//           final isAvailable = entry.value;

//           return ListTile(
//             title: Text(weekday),
//             trailing: Switch(
//               value: isAvailable,
//               onChanged: (value) {
//                 updateDoctorAvailability(weekday, value);
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doc_appoint/utils/firestore_doctor_utils.dart';
import 'package:flutter/material.dart';

class DoctorAvailabilityPage extends StatefulWidget {
  final String doctorUID;
  const DoctorAvailabilityPage({super.key, required this.doctorUID});

  @override
  State<DoctorAvailabilityPage> createState() => _DoctorAvailabilityPageState();
}

class _DoctorAvailabilityPageState extends State<DoctorAvailabilityPage> {
  Map<String, Map<String, bool>> availability = {
    'Monday': {'morning': false, 'afternoon': false, 'evening': false},
    'Tuesday': {'morning': false, 'afternoon': false, 'evening': false},
    'Wednesday': {'morning': false, 'afternoon': false, 'evening': false},
    'Thursday': {'morning': false, 'afternoon': false, 'evening': false},
    'Friday': {'morning': false, 'afternoon': false, 'evening': false},
    'Saturday': {'morning': false, 'afternoon': false, 'evening': false},
    'Sunday': {'morning': false, 'afternoon': false, 'evening': false},
  };

  @override
  void initState() {
    super.initState();
    setupDoctorAvailability(widget.doctorUID);
    fetchDoctorAvailability();
  }

  Future<void> fetchDoctorAvailability() async {
    final availabilitySnapshot = await FirebaseFirestore.instance
        .collection('doctorAvailability')
        .where('doctorUID', isEqualTo: widget.doctorUID)
        .get();

    if (availabilitySnapshot.docs.isNotEmpty) {
      final availabilityData =
          availabilitySnapshot.docs.first.data()['weekdays'];

      setState(() {
        for (final weekdayData in availabilityData) {
          final weekday = weekdayData['name'];
          final morning = weekdayData['morning'] ?? false;
          final afternoon = weekdayData['afternoon'] ?? false;
          final evening = weekdayData['evening'] ?? false;

          availability[weekday] = {
            'morning': morning,
            'afternoon': afternoon,
            'evening': evening,
          };
        }
      });
    }
  }

  Future<void> updateDoctorAvailability(
      String weekday, String timeSlot, bool isAvailable) async {
    final availabilityRef = FirebaseFirestore.instance
        .collection('doctorAvailability')
        .doc(widget.doctorUID);

    final weekdayData = availability[weekday]!;
    weekdayData[timeSlot] = isAvailable;

    final updatedWeekdays = availability.entries.map((entry) {
      final weekday = entry.key;
      final timeSlotData = entry.value;
      return {
        'name': weekday,
        'morning': timeSlotData['morning'],
        'afternoon': timeSlotData['afternoon'],
        'evening': timeSlotData['evening'],
      };
    }).toList();

    await availabilityRef.set({
      'doctorUID': widget.doctorUID,
      'weekdays': updatedWeekdays,
    }, SetOptions(merge: true));

    setState(() {
      availability[weekday] = weekdayData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Doctor Availability'),
      ),
      body: ListView.builder(
        itemCount: availability.length,
        itemBuilder: (context, index) {
          final weekday = availability.keys.elementAt(index);
          final timeSlotData = availability[weekday]!;

          return ExpansionTile(
            title: Text(weekday),
            children: [
              ListTile(
                title: const Text('Morning'),
                trailing: Switch(
                  value: timeSlotData['morning']!,
                  onChanged: (value) {
                    updateDoctorAvailability(weekday, 'morning', value);
                  },
                ),
              ),
              ListTile(
                title: const Text('Afternoon'),
                trailing: Switch(
                  value: timeSlotData['afternoon']!,
                  onChanged: (value) {
                    updateDoctorAvailability(weekday, 'afternoon', value);
                  },
                ),
              ),
              ListTile(
                title: const Text('Evening'),
                trailing: Switch(
                  value: timeSlotData['evening']!,
                  onChanged: (value) {
                    updateDoctorAvailability(weekday, 'evening', value);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}