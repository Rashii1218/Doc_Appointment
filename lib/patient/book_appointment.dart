import 'package:doc_appoint/patient/patientDetails.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class book_appointment extends StatefulWidget {
  const book_appointment({super.key});

  @override
  State<book_appointment> createState() => _book_appointmentState();
}

class _book_appointmentState extends State<book_appointment> {
  DateTime? selectedDate;
  String? selectedSlot;

  List<String> morningSlots = [
    '8:00-8:30 ',
    '8:30-9:00 ',
    '9:00-9:30 ',
    '9:30-10:00 ',
    '10:00-10:30 ',
    '10:30-11:00 '
  ];
  List<String> afternoonSlots = ['12:00 PM', '1:00 PM', '2:00 PM', '3:00 PM'];
  List<String> eveningSlots = ['4:00 PM', '5:00 PM', '6:00 PM', '7:00 PM'];

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime secondDay = now.add(Duration(days: 1));
    DateTime thirdDay = now.add(Duration(days: 2));

    String formatNow = DateFormat('EEE, MMM d').format(now);
    String formatSec = DateFormat('EEE, MMM d').format(secondDay);
    String formatThird = DateFormat('EEE, MMM d').format(thirdDay);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Book Appointment'),
          backgroundColor: Colors.blue,
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
        body: TabBarView(children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      'Morning',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(21, 101, 192, 1),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 5,
                      children: [
                        for (int i = 0; i < morningSlots.length; i++)
                          ElevatedButton(
                              onPressed: () {
                                selectedDate = now;
                                selectedSlot = morningSlots[i];
                                showAlert(context,selectedDate,selectedSlot);
                              },
                              child: Text(morningSlots[i])),
                      ],
                    ),
                    const Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Afternoon',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(21, 101, 192, 1),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Wrap(
                          spacing: 8,
                          runSpacing: 5,
                          children: [
                            
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const Column(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Evening',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(21, 101, 192, 1),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 5,
                      children: [
                        
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Center(
            child: Text('hello'),
          ),
          Center(
            child: Text('hello'),
          )
        ]),
      ),
    );
  }
}

Future<dynamic> showAlert(BuildContext context,DateTime? selectedDate,String? selectedSlot) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select option'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('Selected Date: ${selectedDate != null ? DateFormat('EEE, MMM d').format(selectedDate!) : 'No date selected'}'),
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
                        builder: (context) => patientDetails(selectedDate: selectedDate,selectedSlot: selectedSlot,),
                      ));
                },
                child: Text('Fill Patient Details')),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            )
          ],
        );
      });
}
