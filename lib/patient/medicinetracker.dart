import 'package:doc_appoint/patient/medicine_homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class MedicineTrackerPage extends StatefulWidget {
  final Map<String, dynamic> medicineData;
  final Function refreshMedicineList;

  MedicineTrackerPage(
      {required this.medicineData, required this.refreshMedicineList});

  @override
  _MedicineTrackerPageState createState() => _MedicineTrackerPageState();
}

class _MedicineTrackerPageState extends State<MedicineTrackerPage> {
  String? selectedMedicineType;
  String medicineName = '';
  DateTime? startDate;
  DateTime? endDate;
  List<bool> selectedDays = [false, false, false, false, false, false, false];
  TimeOfDay? reminderTime;

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  Future<void> _saveMedicineData() async {
    // Save medicine data to Firestore

    await FirebaseFirestore.instance.collection('medicines').add({
      'name': medicineName,
      'type': selectedMedicineType,
    });

    // Navigate back to MedicineHomePage and trigger refresh
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MedicineHome(),
        ));
    widget.refreshMedicineList();
  }

  void initializeNotifications() async {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Colors.cyanAccent,
          ledColor: Colors.white,
        ),
      ],
    );
    _scheduleNotification();
  }

  Future<void> _scheduleNotification() async {
    debugPrint('Time');
    if (reminderTime == null) {
      return; // No reminder time selected, return without scheduling notification
    }

    final DateTime now = DateTime.now();
    final DateTime scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      reminderTime!.hour,
      reminderTime!.minute,
    );

    if (scheduledDate.isBefore(now)) {
      return; // Scheduled time is in the past, return without scheduling notification
    }

    final String title = 'Time to take $medicineName';
    final String description =
        'Remember to take your $selectedMedicineType: $medicineName';

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: UniqueKey().hashCode,
        channelKey: 'basic_channel',
        title: title,
        body: description,
        notificationLayout: NotificationLayout.BigText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white,
        ),
        title: const Text(
          'Medicine Details',
          style: TextStyle(fontWeight: FontWeight.w300, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 3, 41, 72),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 226, 241, 251),
              Color.fromARGB(255, 179, 218, 244),
              Color.fromARGB(255, 52, 148, 227)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: const Color.fromARGB(255, 3, 41, 72),
                child: DropdownButton<String>(
                  //iconEnabledColor: const Color.fromARGB(255, 137, 152, 236),
                  value: selectedMedicineType,
                  iconDisabledColor: const Color.fromARGB(255, 3, 41, 72),
                  borderRadius: BorderRadius.circular(4.0),

                  hint: const Text(
                    'Select Medicine Type',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 3, 41, 72),
                      //textStyle: const TextStyle(color: Colors.white),
                    ),
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
                    child: const Text(
                      'Select',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('End Date: ${endDate ?? 'Not set'}'),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 3, 41, 72),
                        textStyle: const TextStyle(color: Colors.white),
                      ),
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
                      child: const Text(
                        'Select',
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Select Days:'),
              Wrap(
                spacing: 10,
                children: List.generate(7, (index) {
                  return FilterChip(
                    label: Text(
                      ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][index],
                      //style: const TextStyle(color: Colors.white),
                    ),
                    selected: selectedDays[index],
                    onSelected: (bool selected) {
                      setState(() {
                        selectedDays[index] = selected;
                      });
                    },
                    backgroundColor: const Color.fromARGB(255, 3, 41, 72),
                    selectedColor: Colors.white,
                    labelStyle: TextStyle(
                      color: selectedDays[index] ? Colors.black : Colors.white,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                      'Reminder Time: ${reminderTime?.format(context) ?? 'Not set'}'),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 3, 41, 72),
                      textStyle: const TextStyle(color: Colors.white),
                    ),
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
                    child: const Text(
                      'Select',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _saveMedicineData();
                  debugPrint('after func');
                  await _scheduleNotification();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 3, 41, 72),
                  textStyle: const TextStyle(
                    color: Colors.white,
                  ),
                ),
                child: const Text(
                  'Save Medicine',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
