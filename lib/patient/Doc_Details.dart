import 'package:flutter/cupertino.dart';
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
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/doctor.jpg'),fit: BoxFit.cover)
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 2 * MediaQuery.of(context).size.height / 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text('Dr. ${widget.doct['name']}',style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold
                      ),),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
