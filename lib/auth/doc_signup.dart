import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:doc_appoint/doctor/doc_homepage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';


class DocSignUp extends StatefulWidget {
  const DocSignUp({Key? key}) : super(key: key);

  @override
  State<DocSignUp> createState() => _DocSignUpState();
}

class _DocSignUpState extends State<DocSignUp> {
  String? errorMessage = '';
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController specialityController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController expController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController feesController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _uploadImageAndSaveToFirestore() async {
    String imageUrl = '';
    if (_imageFile != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('DoctorImages')
          .child(emailController.text + '.jpg');

      await ref.putFile(_imageFile!);
      final imageUrl = await ref.getDownloadURL();

      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
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
          'exp': expController.text,
          'description': descController.text,
          'fees': feesController.text,
          'imageUrl': imageUrl,
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
  }

  Widget entryField(String title, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: title,
        labelStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : '$errorMessage');
  }

  Widget submitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _uploadImageAndSaveToFirestore();
      },
      child:
          const Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold)),
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
            GestureDetector(
              onTap: () {
                _pickImage();
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                child: _imageFile == null
                    ? Icon(
                        Icons.camera_alt,
                        size: 40,
                      )
                    : null,
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      top: 10,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                      left: 10,
                      right: 10),
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
                        const SizedBox(height: 10),
                        entryField('Experience', expController),
                        const SizedBox(height: 10),
                        entryField('Description', descController),
                        const SizedBox(height: 10),
                        entryField('Consultation Fees', feesController),
                        _errorMessage(),
                        submitButton(context),
                      ],
                    ),
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
