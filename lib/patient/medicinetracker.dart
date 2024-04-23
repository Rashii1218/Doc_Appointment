// import 'package:flutter/material.dart';

// class MedicineTrackerPage extends StatefulWidget {
//   @override
//   _MedicineTrackerPageState createState() => _MedicineTrackerPageState();
// }

// class _MedicineTrackerPageState extends State<MedicineTrackerPage> {
//   // Sample list of medicines with reminders
//   final List<Map<String, dynamic>> medicines = [
//     {'name': 'Medicine A', 'reminder': null},
//     {'name': 'Medicine B', 'reminder': null},
//     {'name': 'Medicine C', 'reminder': null},
//     {'name': 'Medicine D', 'reminder': null},
//     {'name': 'Medicine E', 'reminder': null},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Medicine Tracker'),
//       ),
//       body: ListView.builder(
//         itemCount: medicines.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(medicines[index]['name']),
//             subtitle: medicines[index]['reminder'] == null
//                 ? Text('No reminder set')
//                 : Text(
//                     'Reminder set for ${medicines[index]['reminder']['date']} at ${medicines[index]['reminder']['time']}'),
//             trailing: Icon(Icons.alarm),
//             onTap: () async {
//               await _showReminderDialog(index);
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: () {
//           // Add new medicine or perform any action
//           print('Add new medicine');
//         },
//       ),
//     );
//   }

//   Future<void> _showReminderDialog(int index) async {
//     DateTime? selectedDate = medicines[index]['reminder'] != null
//         ? medicines[index]['reminder']['date']
//         : DateTime.now();
//     TimeOfDay? selectedTime = medicines[index]['reminder'] != null
//         ? TimeOfDay.fromDateTime(medicines[index]['reminder']['date'])
//         : TimeOfDay.now();

//     DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: selectedDate!,
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//     );

//     if (pickedDate != null) {
//       TimeOfDay? pickedTime = await showTimePicker(
//         context: context,
//         initialTime: selectedTime!,
//       );

//       if (pickedTime != null) {
//         setState(() {
//           medicines[index]['reminder'] = {
//             'date': DateTime(
//               pickedDate.year,
//               pickedDate.month,
//               pickedDate.day,
//               pickedTime.hour,
//               pickedTime.minute,
//             ),
//             'time': pickedTime.format(context),
//           };
//         });
//       }
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class MedicineTrackerPage extends StatefulWidget {
  @override
  _MedicineTrackerPageState createState() => _MedicineTrackerPageState();
}

class _MedicineTrackerPageState extends State<MedicineTrackerPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? selectedMedicineType;
  String medicineName = '';
  DateTime? startDate;
  DateTime? endDate;
  List<bool> selectedDays = [false, false, false, false, false, false, false];
  TimeOfDay? reminderTime;

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    // var initializationSettingsIOS = IOSInitializationSettings(
    //     requestAlertPermission: true,
    //     requestBadgePermission: true,
    //     requestSoundPermission: true,
    //     onDidReceiveLocalNotification:
    //         (int? id, String? title, String? body, String? payload) async {});
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleNotification() async {
    var time = TimeOfDay(hour: reminderTime!.hour, minute: reminderTime!.minute);
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'medicine_notification',
      'Medicine Reminder',
      importance: Importance.max,
      priority: Priority.high,
    );
    //var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        );
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Time to take $medicineName',
        'Remember to take your $selectedMedicineType: $medicineName',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DropdownButton<String>(
                value: selectedMedicineType,
                hint:const Text('Select Medicine Type'),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedMedicineType = newValue;
                  });
                },
                items: <String>['Pills', 'Syrup', 'Tablets', 'Others']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Medicine Name',
                ),
                onChanged: (value) {
                  medicineName = value;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Start Date: ${startDate ?? 'Not set'}'),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != startDate)
                      {
                         setState(() {
                          startDate = picked;
                        });
                      }
                       
                    },
                    child: const Text('Select'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('End Date: ${endDate ?? 'Not set'}'),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != endDate)
                      {
                        setState(() {
                          endDate = picked;
                        });
                      }
                        
                    },
                    child: const Text('Select'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Select Days:'),
              Wrap(
                spacing: 10,
                children: List.generate(7, (index) {
                  return FilterChip(
                    label: Text(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][index]),
                    selected: selectedDays[index],
                    onSelected: (bool selected) {
                      setState(() {
                        selectedDays[index] = selected;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Reminder Time: ${reminderTime?.format(context) ?? 'Not set'}'),
                  ElevatedButton(
                    onPressed: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null)
                      {
                        setState(() {
                          reminderTime = picked;
                        });
                      }                       
                    },
                    child: Text('Select'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _scheduleNotification();
                },
                child: const Text('Set Reminder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}