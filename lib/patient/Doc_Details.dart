import 'package:doc_appoint/patient/book_appointment.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class DocDetails extends StatefulWidget {
  final Map<String, dynamic> doct;
  DocDetails({super.key, required this.doct});

  @override
  State<DocDetails> createState() => _DocDetailsState();
}

class _DocDetailsState extends State<DocDetails> {
  final FirebaseFirestore firest = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text('Doctor Details'),
          // backgroundColor: Colors.blue,
          ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3,
              // color: Colors.red,
              decoration:  BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage('${widget.doct['image upload']}'),
                      fit: BoxFit.cover)),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              // height: 2 * MediaQuery.of(context).size.height / 3,
              padding: EdgeInsets.all(8),
              child: Card(
                color: Colors.blue[100],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          'Dr. ${widget.doct['name']}',
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          'Speciality: ${widget.doct['speciality']}',
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          'Experience: ${widget.doct['exp']} years',
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          'Consultation Fees: ${widget.doct['fees']}',
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          'Mobile Number: ${widget.doct['mobileNumber']}',
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          'About: ${widget.doct['description']}',
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
                      height: 20,
                    ),
            Center(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            book_appointment(doctorUID: widget.doct['uid']),
                      ));
                },
                child: Text('Book Appointment'),style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.pink[50])
                ),))
          ],
        ),
      ),
    );
  }
}
