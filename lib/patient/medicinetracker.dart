import 'package:flutter/material.dart';

class MedicineTrackerPage extends StatefulWidget {
  @override
  _MedicineTrackerPageState createState() => _MedicineTrackerPageState();
}

class _MedicineTrackerPageState extends State<MedicineTrackerPage> {
  // Sample list of medicines with reminders
  final List<Map<String, dynamic>> medicines = [
    {'name': 'Medicine A', 'reminder': null},
    {'name': 'Medicine B', 'reminder': null},
    {'name': 'Medicine C', 'reminder': null},
    {'name': 'Medicine D', 'reminder': null},
    {'name': 'Medicine E', 'reminder': null},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine Tracker'),
      ),
      body: ListView.builder(
        itemCount: medicines.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(medicines[index]['name']),
            subtitle: medicines[index]['reminder'] == null
                ? Text('No reminder set')
                : Text(
                    'Reminder set for ${medicines[index]['reminder']['date']} at ${medicines[index]['reminder']['time']}'),
            trailing: Icon(Icons.alarm),
            onTap: () async {
              await _showReminderDialog(index);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Add new medicine or perform any action
          print('Add new medicine');
        },
      ),
    );
  }

  Future<void> _showReminderDialog(int index) async {
    DateTime? selectedDate = medicines[index]['reminder'] != null
        ? medicines[index]['reminder']['date']
        : DateTime.now();
    TimeOfDay? selectedTime = medicines[index]['reminder'] != null
        ? TimeOfDay.fromDateTime(medicines[index]['reminder']['date'])
        : TimeOfDay.now();

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime!,
      );

      if (pickedTime != null) {
        setState(() {
          medicines[index]['reminder'] = {
            'date': DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
              pickedTime.hour,
              pickedTime.minute,
            ),
            'time': pickedTime.format(context),
          };
        });
      }
    }
  }
}
