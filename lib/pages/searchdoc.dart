import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doc_appoint/patient/Doc_Details.dart';
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
          title: const Text("Doctor's List"),
          backgroundColor: const Color.fromARGB(255, 108, 199, 242),
        ),
        body: ListView.builder(
          itemCount: widget.specialityDoc.length,
          itemBuilder: (context, index) {
            final doctor = widget.specialityDoc[index].data();
            return InkWell(
              splashColor: Colors.blue,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DocDetails(doct: doctor),
                    ));
              },
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 148, 215, 246),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/doctor.jpg'),
                        backgroundColor: Colors.blue,
                        radius: 30,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            doctor['name'],
                            style: const TextStyle(
                                color: Color.fromRGBO(21, 101, 192, 1),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            doctor['speciality'],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
