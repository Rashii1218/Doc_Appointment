import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchDoc extends StatefulWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> specialityDoc;
  const SearchDoc({super.key, required this.specialityDoc});

  @override
  State<SearchDoc> createState() => _SearchDocState();
}

class _SearchDocState extends State<SearchDoc> {
  final searchfilter = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Doctor's List"),
          backgroundColor: const Color.fromARGB(255, 108, 199, 242),
        ),
        body: ListView.builder(
          itemCount: widget.specialityDoc.length,
          itemBuilder: (context, index) {
            final doctor = widget.specialityDoc[index].data();
            return ListTile(
              title: Text(doctor['name']),
              subtitle: Text(doctor['speciality']),
            );
          },
        ));
  }
}
