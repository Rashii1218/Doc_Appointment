import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add Firestore import
import 'package:doc_appoint/patient/medicinetracker.dart';

class MedicineHome extends StatefulWidget {
  @override
  _MedicineHomeState createState() => _MedicineHomeState();
}

class _MedicineHomeState extends State<MedicineHome> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine Tracker'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('medicines').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final medicines = snapshot.data!.docs;

          return ListView.builder(
            itemCount: medicines.length,
            itemBuilder: (context, index) {
              final medicineData = medicines[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(medicineData['name']),
                subtitle: Text('Type: ${medicineData['type']}'),
                onTap: () {
                  // Navigate to the details page for the selected medicine
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MedicineTrackerPage(
                        medicineData: medicineData,
                        refreshMedicineList: () {
                          // Define a function to refresh the medicine list
                          setState(() {});
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the MedicineTrackerPage for adding a new medicine
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MedicineTrackerPage( 
                // Pass a sample medicine data for demonstration
                medicineData: {'name': 'Example Medicine', 'type': 'Pills'}, 
                refreshMedicineList: () {
                  // Define a function to refresh the medicine list
                  setState(() {});
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}