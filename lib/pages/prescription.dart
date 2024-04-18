import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PrescriptionPage extends StatefulWidget {
  @override
  _PrescriptionPageState createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  final TextEditingController medicineController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();

  List<Map<String, dynamic>> prescriptions = [];

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void addPrescription() {
    setState(() {
      prescriptions.add({
        'medicine': medicineController.text,
        'dosage': dosageController.text,
        'instructions': instructionsController.text,
        'image': _imageFile,
      });
      medicineController.clear();
      dosageController.clear();
      instructionsController.clear();
      _imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Prescription'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // Save prescription logic
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Prescription',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getImage,
              child:const Text('Upload Prescription Image'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: medicineController,
              decoration: const InputDecoration(
                labelText: 'Medicine',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: dosageController,
              decoration: const InputDecoration(
                labelText: 'Dosage',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: instructionsController,
              decoration:const InputDecoration(
                labelText: 'Instructions',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: addPrescription,
              child:const Text('Add'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Prescriptions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: prescriptions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: prescriptions[index]['image'] != null
                        ? Image.file(prescriptions[index]['image'])
                        : null,
                    title: Text('Medicine: ${prescriptions[index]['medicine']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dosage: ${prescriptions[index]['dosage']}'),
                        Text('Instructions: ${prescriptions[index]['instructions']}'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
