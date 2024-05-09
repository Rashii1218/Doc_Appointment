import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doc_appoint/patient/patientDetails.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookAppointmentPage extends StatefulWidget {
  final String doctorUID;
  const BookAppointmentPage({super.key, required this.doctorUID});

  @override
  State<BookAppointmentPage> createState() => _BookAppointmentPageState();
}

class _BookAppointmentPageState extends State<BookAppointmentPage> {
  DateTime? selectedDate;
  String? selectedSlot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(transform: GradientRotation(40), colors: [
            Color.fromARGB(255, 125, 176, 219),
            Color.fromARGB(255, 60, 123, 175),
          ]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Color.fromARGB(255, 3, 41, 72),
                  ),
                  padding: MaterialStatePropertyAll(EdgeInsets.all(20))),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (date != null) {
                  setState(() {
                    selectedDate = date;
                  });
                }
              },
              child: Center(
                child: Text(
                  selectedDate != null
                      ? DateFormat('EEE, MMM d').format(selectedDate!)
                      : 'Select Date',
                  style: const TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            if (selectedDate != null)
              FutureBuilder<List<String>>(
                future: getAvailableSlots(selectedDate!, widget.doctorUID),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final availableSlots = snapshot.data!;
                    return Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (final slot in availableSlots)
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedSlot = slot;
                              });
                              showAlert(context, selectedDate, selectedSlot,
                                  widget.doctorUID);
                            },
                            child: Text(
                              slot,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 125, 176, 219),
                              ),
                            ),
                          ),
                      ],
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> showAlert(BuildContext context, DateTime? selectedDate,
      String? selectedSlot, String doctorUID) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select option'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                    'Selected Date: ${selectedDate != null ? DateFormat('EEE, MMM d').format(selectedDate) : 'No date selected'}'),
                Text('Selected Slot: ${selectedSlot ?? 'No slot selected'}'),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => patientDetails(
                      selectedDate: selectedDate,
                      selectedSlot: selectedSlot,
                      doctUid: doctorUID,
                    ),
                  ),
                );
              },
              child: const Text('Fill Patient Details'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            )
          ],
        );
      },
    );
  }

  Future<List<String>> getAvailableSlots(
      DateTime selectedDate, String doctorUID) async {
    final weekday = DateFormat('EEEE').format(selectedDate).toLowerCase();
    final availabilitySnapshot = await FirebaseFirestore.instance
        .collection('doctorAvailability')
        .where('doctorUID', isEqualTo: doctorUID)
        .get();

    final morningSlots = [
      '8:00 - 8:30 ',
      '8:30 - 9:00 ',
      '9:00 - 9:30 ',
      '9:30 - 10:00 ',
      '10:00 - 10:30 ',
      '10:30 - 11:00 '
    ];

    final afternoonSlots = [
      '11:00 - 11:30 ',
      '11:30 - 12:00 ',
      '12:00 - 12:30 ',
      '12:30 - 13:00 ',
      '16:00 - 16:30 ',
      '16:30 - 17:00 '
    ];

    final eveningSlots = [
      '17:00 - 17:30 ',
      '17:30 - 18:00 ',
      '18:00 - 18:30 ',
      '18:30 - 19:00 ',
      '19:00 - 19:30 ',
      '19:30 - 20:00 '
    ];

    if (availabilitySnapshot.docs.isNotEmpty) {
      final availabilityData = availabilitySnapshot.docs.first.data();
      final weekdayData = availabilityData['weekdays']
          .firstWhere((data) => data['name'].toLowerCase() == weekday);

      final morning = weekdayData['morning'] ?? false;
      final afternoon = weekdayData['afternoon'] ?? false;
      final evening = weekdayData['evening'] ?? false;

      final availableSlots = <String>[];
      if (morning) {
        availableSlots.addAll(morningSlots);
      }
      if (afternoon) {
        availableSlots.addAll(afternoonSlots);
      }
      if (evening) {
        availableSlots.addAll(eveningSlots);
      }

      return availableSlots;
    } else {
      // If no availability data is found for the doctor, return all slots
      return [...morningSlots, ...afternoonSlots, ...eveningSlots];
    }
  }
}
