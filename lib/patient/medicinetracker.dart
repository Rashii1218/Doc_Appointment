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
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int? id, String? title, String? body, String? payload) async {});
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _scheduleNotification() async {
    var time = TimeOfDay(hour: reminderTime!.hour, minute: reminderTime!.minute);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'medicine_notification',
      'Medicine Reminder',
      'Channel for Medicine Reminder',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Time to take $medicineName',
        'Remember to take your $selectedMedicineType: $medicineName',
        tz.TZDateTime.now(tz.local).add(Duration(seconds: 5)),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DropdownButton<String>(
                value: selectedMedicineType,
                hint: Text('Select Medicine Type'),
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
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Medicine Name',
                ),
                onChanged: (value) {
                  medicineName = value;
                },
              ),
              SizedBox(height: 20),
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
                        setState(() {
                          startDate = picked;
                        });
                    },
                    child: Text('Select'),
                  ),
                ],
              ),
              SizedBox(height: 20),
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
                        setState(() {
                          endDate = picked;
                        });
                    },
                    child: Text('Select'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('Select Days:'),
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
              SizedBox(height: 20),
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
                        setState(() {
                          reminderTime = picked;
                        });
                    },
                    child: Text('Select'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _scheduleNotification();
                },
                child: Text('Set Reminder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
