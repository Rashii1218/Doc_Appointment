import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PrescriptionPage extends StatefulWidget {
  Map<String, dynamic> patient;
  String patientId;
  PrescriptionPage({super.key, required this.patient, required this.patientId});

  @override
  State<PrescriptionPage> createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.patientId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescription'),
        backgroundColor: const Color.fromARGB(255, 108, 199, 242),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder(
            stream: firestore
                .collection('Patient')
                .doc(widget.patientId)
                .collection('Prescriptions')
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  final prescriptionDoc = snapshot.data.docs.toList();
                  return Container(
                    padding: const EdgeInsets.only(left: 15,right: 15,top: 20),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisExtent: 280,
                              mainAxisSpacing: 20,
                              //crossAxisSpacing: 15,
                              crossAxisCount: 1),
                      itemCount: prescriptionDoc.length,
                      itemBuilder: (context, index) {
                        final prescription = prescriptionDoc[index].data();
                        return SingleChildScrollView(
                          child: Card(
                            color: Colors.blue[50],
                            child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Medicine: ${prescription['medicine']}"),
                                Text("Dosage: ${prescription['dosage']}"),
                                Text(
                                    "Instructions: ${prescription['instructions']}"),
                                if (prescription['image'] != null)
                                  InkWell(
                                    onTap: () => showDialog(
                                        builder: (BuildContext context) =>
                                            SingleChildScrollView(
                                              child: AlertDialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                insetPadding: const EdgeInsets.all(2),
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
                                    child: SizedBox(
                                      height: 250,
                                      width: 550,
                                      child: Image.network(prescription['image'],),
                                    ),
                                  )
                              ],
                            ),
                          )),
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('$snapshot.hasError.toString()');
                } else {
                  return const Text('No Data Available');
                }
              } else {
                return const Center(child: CircularProgressIndicator(),);
              }
            },
          ),
        ),
      ),
    );
  }
}
