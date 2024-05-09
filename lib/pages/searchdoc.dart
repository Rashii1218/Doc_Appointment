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
          leading: const BackButton(color: Colors.white),
          title: const Text(
            "Doctor's List",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 3, 41, 72),
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
                  height: MediaQuery.of(context).size.height / 7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 3, 41, 72),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage('assets/doctor.jpg'),
                        backgroundColor: Colors.blue,
                        radius: 50,
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
                                color: Color.fromRGBO(255, 255, 255, 1),
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Speciality: ${doctor['speciality']}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Experience: ${doctor['exp']} years',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(
                                Icons.phone,
                                color: Colors.lightGreen,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                doctor['mobileNumber'],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
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
