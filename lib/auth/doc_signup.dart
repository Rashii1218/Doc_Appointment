import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:doc_appoint/doctor/doc_homepage.dart';

class DocSignUp extends StatefulWidget {
  const DocSignUp({Key? key}) : super(key: key);

  @override
  State<DocSignUp> createState() => _DocSignUpState();
}

class _DocSignUpState extends State<DocSignUp> {
  String? errorMessage = '';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController specialityController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createDoctorAccount(BuildContext context) async {
    try {
      
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      await _firestore.collection('Doctor').doc(emailController.text).set({
        'name': nameController.text,
        'mobileNumber': mobileController.text,
        'age': ageController.text,
        'speciality': specialityController.text,
        'email': emailController.text,
        'uid': userCredential.user!.uid,
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DocHomePage()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    } catch (e) {
      print('Error saving doctor data to Firestore: $e');
    }
  }

  Widget entryField(String title, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: title,
        labelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : '$errorMessage');
  }

  Widget submitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        createDoctorAccount(context);
      },
      child: const Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Doctor Sign Up'),
      ),
      body: Container(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/doc-pat.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Form(
                  child: Column(
                    children: <Widget>[
                      entryField('Name', nameController),
                      const SizedBox(height: 10),
                      entryField('Mobile Number', mobileController),
                      const SizedBox(height: 10),
                      entryField('Age', ageController),
                      const SizedBox(height: 10),
                      entryField('Speciality', specialityController),
                      const SizedBox(height: 10),
                      entryField('Email', emailController),
                      const SizedBox(height: 10),
                      entryField('Password', passwordController),
                      _errorMessage(),
                      submitButton(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}