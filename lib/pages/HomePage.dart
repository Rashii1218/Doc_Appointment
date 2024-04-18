import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doc_appoint/pages/searchdoc.dart';
import 'package:doc_appoint/patient/Doc_Details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:doc_appoint/auth/login_view.dart';
import 'package:doc_appoint/pages/cards.dart';
import 'package:doc_appoint/utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isClicked = true;
  final auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final searchfilter = TextEditingController();
  List<QueryDocumentSnapshot<Map<String, dynamic>>> searchResults = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> specialityDoc = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Welcome to\nMedConnect",
          style: TextStyle(fontSize: 40, fontStyle: FontStyle.italic),
        ),
        toolbarHeight: 90,
        backgroundColor: const Color.fromARGB(255, 108, 199, 242),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut().then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginView(),
                  ),
                ).onError((error, stackTrace) =>
                    Utils().toastmessage(error.toString()));
              });
            },
            icon: const Icon(Icons.logout_outlined),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  top: 40, left: 10, right: 10, bottom: 5),
              height: 120,
              color: const Color.fromARGB(255, 108, 199, 242),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: searchfilter,
                      decoration: const InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(0.0),
                          child: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                        ),
                        hintText: "Search Doctor",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onChanged: (String value) {
                        setState(() {
                          _firestore
                              .collection('Doctor')
                              .where('name', isGreaterThanOrEqualTo: value)
                              .where('name',
                                  isLessThanOrEqualTo: value + '\uf8ff')
                              .get()
                              .then((querySnapshot) {
                            searchResults = querySnapshot.docs;
                          }).catchError((error) {
                            Utils().toastmessage(
                                'Error searching for doctors: $error');
                          });
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SearchResults(searchResults: searchResults),
            Container(
              padding: const EdgeInsets.only(left: 20, top: 20),
              alignment: Alignment.centerLeft,
              child: const Text(
                "Specialists",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color.fromARGB(255, 21, 101, 192),
                ),
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: cards.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 7, left: 7),
                    height: 150,
                    width: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(cards[index].cardBackground),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade400,
                          blurRadius: 4.0,
                          spreadRadius: 0.0,
                          offset: const Offset(3, 3),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        _firestore
                            .collection('Doctor')
                            .where('speciality',
                                isLessThanOrEqualTo: cards[index].doctor)
                            .get()
                            .then((querysnapshot) {
                          specialityDoc = querysnapshot.docs;
                          if (specialityDoc.isEmpty) {
                            Utils().toastmessage('No Doctors available');
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SearchDoc(specialityDoc: specialityDoc),
                                ));
                          }
                        }).onError((error, stackTrace) {
                          Utils().toastmessage(error.toString());
                        });
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 29,
                            child: Icon(
                              cards[index].cardIcon,
                              size: 26,
                              color: Color(cards[index].cardBackground),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              cards[index].doctor,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                "Top Rated",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: 255,
              child: StreamBuilder(
                stream: _firestore.collection('Doctor').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      allDocs = snapshot.data!.docs.toList();
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: allDocs.length,
                        itemBuilder: (context, index) {
                          final doc = allDocs[index].data();
                          return InkWell(
                            splashColor: Colors.blue,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DocDetails(doct:doc),
                                  ));
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 8),
                              color: const Color.fromARGB(255, 108, 199, 242),
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 0),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 9,
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/doctor.jpg'),
                                    backgroundColor: Colors.blue,
                                    radius: 30,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        doc['name'],
                                        style: const TextStyle(
                                            color:
                                                Color.fromRGBO(21, 101, 192, 1),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        doc['speciality'],
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        doc['mobileNumber'],
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.hasError.toString()}');
                    } else {
                      return const Center(
                        child: Text('No data found'),
                      );
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class SearchResults extends StatelessWidget {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> searchResults;

  const SearchResults({Key? key, required this.searchResults})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            "Search Results",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color.fromARGB(255, 21, 101, 192),
            ),
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            final doctor = searchResults[index].data();
            return ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage('assets/doctor.jpg'),
              ),
              title: Text(doctor['name'].toString()),
              subtitle: Text(doctor['speciality'].toString()),
            );
          },
        ),
      ],
    );
  }
}
