// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:doc_appoint/utils/firestore_doctor_utils.dart';
// import 'package:flutter/material.dart';

// class DoctorAvailabilityPage extends StatefulWidget {
//   final String doctorUID;
//   const DoctorAvailabilityPage({super.key, required this.doctorUID});

//   @override
//   State<DoctorAvailabilityPage> createState() => _DoctorAvailabilityPageState();
// }

// class _DoctorAvailabilityPageState extends State<DoctorAvailabilityPage> {
//   // bool  var1 = false;
//   // bool ? var2;
//   // bool ? var3;
//   // Map<String, Map<String, bool>> availability = {
//   //   'Monday': {'morning': var1, 'afternoon': var2, 'evening': var3},
//   //   'Tuesday': {'morning': false, 'afternoon': false, 'evening': false},
//   //   'Wednesday': {'morning': false, 'afternoon': false, 'evening': false},
//   //   'Thursday': {'morning': false, 'afternoon': false, 'evening': false},
//   //   'Friday': {'morning': false, 'afternoon': false, 'evening': false},
//   //   'Saturday': {'morning': false, 'afternoon': false, 'evening': false},
//   //   'Sunday': {'morning': false, 'afternoon': false, 'evening': false},
//   // };

//   @override
//   void initState() {
//     super.initState();
//     setupDoctorAvailability(widget.doctorUID);
//     fetchDoctorAvailability();
//   }

//   Future<void> fetchDoctorAvailability() async {
//     final availabilitySnapshot = await FirebaseFirestore.instance
//         .collection('doctorAvailability')
//         .where('doctorUID', isEqualTo: widget.doctorUID)
//         .get();

//     if (availabilitySnapshot.docs.isNotEmpty) {
//       final availabilityData =
//           availabilitySnapshot.docs.first.data()['weekdays'];

//       setState(() {
//         for (final weekdayData in availabilityData) {
//           final weekday = weekdayData['name'];
//           final morning = weekdayData['morning'] ?? false;
//           final afternoon = weekdayData['afternoon'] ?? false;
//           final evening = weekdayData['evening'] ?? false;

//           availability[weekday] = {
//             'morning': morning,
//             'afternoon': afternoon,
//             'evening': evening,
//           };
//         }
//       });
//     }
//   }

//   Future<void> updateDoctorAvailability(
//       String weekday, String timeSlot, bool isAvailable) async {

//     final availabilityRef = FirebaseFirestore.instance
//         .collection('doctorAvailability')
//         .doc(widget.doctorUID);

//     final weekdayData = availability[weekday]!;
//     weekdayData[timeSlot] = isAvailable;

//     final updatedWeekdays = availability.entries.map((entry) {
//       final weekday = entry.key;
//       final timeSlotData = entry.value;
//       return {
//         'name': weekday,
//         'morning': timeSlotData['morning'],
//         'afternoon': timeSlotData['afternoon'],
//         'evening': timeSlotData['evening'],
//       };
//     }).toList();

//     await availabilityRef.update({
//       //'doctorUID': widget.doctorUID,
//       'weekdays': updatedWeekdays,
//     },);

//     await fetchDoctorAvailability();

//     setState(() {
//       availability[weekday] = weekdayData;
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
//         itemCount: availability.length,
//         itemBuilder: (context, index) {
//           final weekday = availability.keys.elementAt(index);
//           final timeSlotData = availability[weekday]!;

//           return ExpansionTile(
//             title: Text(weekday),
//             children: [
//               ListTile(
//                 title: const Text('Morning'),
//                 trailing: Switch(
//                   value: timeSlotData['morning']!,
//                   onChanged: (value) {
//                     updateDoctorAvailability(weekday, 'morning', value);
//                   },
//                 ),
//               ),
//               ListTile(
//                 title: const Text('Afternoon'),
//                 trailing: Switch(
//                   value: timeSlotData['afternoon']!,
//                   onChanged: (value) {
//                     updateDoctorAvailability(weekday, 'afternoon', value);
//                   },
//                 ),
//               ),
//               ListTile(
//                 title: const Text('Evening'),
//                 trailing: Switch(
//                   value: timeSlotData['evening']!,
//                   onChanged: (value) {
//                     updateDoctorAvailability(weekday, 'evening', value);
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DoctorAvailabilityPage extends StatefulWidget {
  final String doctorUID;
  const DoctorAvailabilityPage({super.key, required this.doctorUID});

  @override
  State<DoctorAvailabilityPage> createState() => _DoctorAvailabilityPageState();
}

class _DoctorAvailabilityPageState extends State<DoctorAvailabilityPage> {
  Map<String, Map<String, bool>> availability = {};

  @override
  void initState() {
    super.initState();
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
        availability = {
          'Monday': {'morning': false, 'afternoon': false, 'evening': false},
          'Tuesday': {'morning': false, 'afternoon': false, 'evening': false},
          'Wednesday': {'morning': false, 'afternoon': false, 'evening': false},
          'Thursday': {'morning': false, 'afternoon': false, 'evening': false},
          'Friday': {'morning': false, 'afternoon': false, 'evening': false},
          'Saturday': {'morning': false, 'afternoon': false, 'evening': false},
          'Sunday': {'morning': false, 'afternoon': false, 'evening': false},
        };

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

    await availabilityRef.update({
      'weekdays': updatedWeekdays,
    });

    setState(() {
      availability[weekday] = weekdayData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text('Your Availability',
          style: TextStyle(color: Colors.white),),
        ),
        // backgroundColor: Colors.blue[300],
        backgroundColor: const Color.fromARGB(255, 108, 199, 242)
        
      ),
      body: Container(
        decoration: const BoxDecoration(
                gradient: LinearGradient(
                  transform: GradientRotation(400),
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                  Color.fromARGB(255, 226, 241, 251),
                  Color.fromARGB(255, 179, 218, 244),
                  Color.fromARGB(255, 52, 148, 227),
                ]),
              ),
        child: ListView.builder(
          itemCount: availability.length,
          itemBuilder: (context, index) {
            final weekday = availability.keys.elementAt(index);
            final timeSlotData = availability[weekday]!;
        
            return Card(
              margin: const EdgeInsets.all(10),
              // color: Colors.black,
              color: const Color.fromARGB(255, 3, 41, 72),
              child: ExpansionTile(
              title: Text(weekday,style: const TextStyle(color: Color.fromARGB(255, 108, 199, 242)),),
                children: [
                  Card(
                    color: Colors.blue[100],
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: const Text('Morning'),
                      trailing: Switch(
                        value: timeSlotData['morning']!,
                        onChanged: (value) {
                          updateDoctorAvailability(weekday, 'morning', value);
                        },
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.blue[100],
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: const Text('Afternoon'),
                      trailing: Switch(
                        value: timeSlotData['afternoon']!,
                        onChanged: (value) {
                          updateDoctorAvailability(weekday, 'afternoon', value);
                        },
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.blue[100],
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: const Text('Evening'),
                      trailing: Switch(
                        value: timeSlotData['evening']!,
                        onChanged: (value) {
                          updateDoctorAvailability(weekday, 'evening', value);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
