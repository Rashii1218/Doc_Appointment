import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class docPatientDetails extends StatefulWidget {
  QueryDocumentSnapshot<Map<String, dynamic>> patient;
  docPatientDetails({super.key, required this.patient});

  @override
  State<docPatientDetails> createState() => _docPatientDetailsState();
}

class _docPatientDetailsState extends State<docPatientDetails> {
  final bool change = false;

  final TextEditingController medicineController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();

  List<Map<String, dynamic>> prescriptions = [];

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? errormessage = "";
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? errorMessage = "";
  User? _user;

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        debugPrint('No image selected.');
      }
    });
  }

  Future<void> storeDetails() async {
    var imageName = DateTime.now().millisecondsSinceEpoch.toString();
    var storageRef =
        FirebaseStorage.instance.ref().child('prescriptions/$imageName.jpg');
    var uploadTask = storageRef.putFile(_imageFile!);
    var downloadUrl = await (await uploadTask).ref.getDownloadURL();

    await firestore
        .collection('Patient')
        .doc(widget.patient.id)
        .collection('Prescriptions')
        .doc()
        .set({
      'medicine': medicineController.text,
      'dosage': dosageController.text,
      'instructions': instructionsController.text,
      'image': downloadUrl,
    });
    medicineController.clear();
    dosageController.clear();
    instructionsController.clear();
    _imageFile = null;
  }

  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        _user = user;
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                  elevation: Material.defaultSplashRadius,
                  // color: const Color.fromARGB(255, 108, 199, 242),
                  color: const Color.fromARGB(255, 3, 41, 72),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name:  ${widget.patient['First Name']} ${widget.patient['Last Name']}',
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                          Text(
                            'Age:  ${widget.patient['Age']}',
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                          Text(
                            'Mobile Number:  ${widget.patient['Mobile']}',
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                        ]),
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  transform: GradientRotation(400),
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                  Color.fromARGB(255, 226, 241, 251),
                  Color.fromARGB(255, 179, 218, 244),
                  Color.fromARGB(255, 52, 148, 227)
                ]),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Add Prescription',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 3, 41, 72),
                      )),
                      onPressed: _getImage,
                      child: const Text(
                        'Upload Prescription Image',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: medicineController,
                      decoration: const InputDecoration(
                        labelText: 'Medicine',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                      decoration: const InputDecoration(
                        labelText: 'Instructions',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: const ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(255, 3, 41, 72))),
                      onPressed: () {
                        storeDetails();
                      },
                      child: const Text(
                        'Add',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Prescriptions',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 3 * MediaQuery.of(context).size.height / 4,
                      child: StreamBuilder(
                        stream: firestore
                            .collection('Patient')
                            .doc(widget.patient.id)
                            .collection('Prescriptions')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            if (snapshot.hasData) {
                              final prescriptionDocs =
                                  snapshot.data!.docs.toList();
                              return ListView.builder(
                                itemCount: prescriptionDocs.length,
                                itemBuilder: (context, index) {
                                  final prescription =
                                      prescriptionDocs[index].data();
                                  return ListTile(
                                    title: Column(
                                      children: [
                                        Text(
                                            'Medicine: ${prescription['medicine']}'),
                                        Text(
                                            'Dosage: ${prescription['dosage']}'),
                                        Text(
                                            'Instructions: ${prescription['instructions']}'),
                                        const Divider()
                                      ],
                                    ),
                                    leading: prescription['image'] != null
                                        ? CircleAvatar(
                                            child: Image.network(
                                                prescription['image']),
                                          )
                                        : const CircleAvatar(),
                                    onTap: () => showDialog(
                                        builder: (BuildContext context) =>
                                            SingleChildScrollView(
                                              child: AlertDialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                insetPadding:
                                                    const EdgeInsets.all(2),
                                                title: Container(
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              prescription[
                                                                  'image']))),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: MediaQuery.of(context)
                                                      .size
                                                      .height,
                                                ),
                                              ),
                                            ),
                                        context: context),
                                  );
                                },
                              );
                            } else if (snapshot.hasError) {
                              return Text('$snapshot.hasError.toString()');
                            } else {
                              return const Text('No Appointments');
                            }
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
