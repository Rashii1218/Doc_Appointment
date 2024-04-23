import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class MedicineTrackerPage extends StatefulWidget {
  @override
  _MedicineTrackerPageState createState() => _MedicineTrackerPageState();
}

class _Medicine {
  String? medicineType;
  String medicineName = '';
  DateTime? startDate;
  DateTime? endDate;
  List<bool> selectedDays = [false, false, false, false, false, false, false];
  TimeOfDay? reminderTime;
}

class _MedicineTrackerPageState extends State<MedicineTrackerPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  List<_Medicine> medicines = [];
  List<String> savedMedicines = [];

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

   Future<void> _scheduleNotification(String medicineName) async {
    var medicine = medicines.firstWhere((m) => m.medicineName == medicineName);
    var time = TimeOfDay(
        hour: medicine.reminderTime!.hour, minute: medicine.reminderTime!.minute);
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'medicine_notification',
      'Medicine Reminder',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      medicines.indexOf(medicine),
      'Time to take ${medicine.medicineName}',
      'Remember to take your ${medicine.medicineType}: ${medicine.medicineName}',
      tz.TZDateTime.now(tz.local).add(Duration(seconds: 5)),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
void _saveMedicine(_Medicine medicine) {
    if (!savedMedicines.contains(medicine.medicineName)) {
      setState(() {
        savedMedicines.add(medicine.medicineName);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: Text('Medicine Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  final newMedicine = _Medicine();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddMedicinePage(
                        medicine: newMedicine,
                        scheduleNotificationCallback: _scheduleNotification,
                      ),
                    ),
                  );
                  if (newMedicine.medicineName.isNotEmpty) {
                    setState(() {
                      medicines.add(newMedicine);
                      _saveMedicine(newMedicine);
                    });
                  }
                },
                child: Text('Add Medicine'),

              ),
              SizedBox(height: 20),
              Text('Saved Medicines:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: savedMedicines.map((medicineName) {
                  return Text(medicineName);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddMedicinePage extends StatefulWidget {
  final _Medicine medicine;
  final Function(String) scheduleNotificationCallback;

  AddMedicinePage({required this.medicine, required this.scheduleNotificationCallback});

  @override
  _AddMedicinePageState createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  DateTime? startDate;
  DateTime? endDate;
  List<bool> selectedDays = [false, false, false, false, false, false, false];
  TimeOfDay? reminderTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Medicine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DropdownButton<String>(
                value: widget.medicine.medicineType,
                hint: Text('Select Medicine Type'),
                onChanged: (String? newValue) {
                  setState(() {
                    widget.medicine.medicineType = newValue;
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
                decoration: InputDecoration(
                  labelText: 'Medicine Name',
                ),
                onChanged: (value) {
                  widget.medicine.medicineName = value;
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
                      if (picked != null)
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
                      if (picked != null)
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
                children: List.generate(7, (dayIndex) {
                  return FilterChip(
                    label: Text(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][dayIndex]),
                    selected: selectedDays[dayIndex],
                    onSelected: (bool selected) {
                      setState(() {
                        selectedDays[dayIndex] = selected;
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
                  widget.scheduleNotificationCallback(widget.medicine.medicineName);
                  Navigator.pop(context);
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

              
              