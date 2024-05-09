import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:doc_appoint/auth/auth.dart';
import 'package:doc_appoint/auth/doc_signup.dart';
import 'package:doc_appoint/pages/BottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  String? errorMessage = '';
  final _formKey = GlobalKey<FormState>();

  final TextEditingController RegnoController = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerMobile = TextEditingController();
  final TextEditingController controllerAge = TextEditingController();
  final TextEditingController controllerAddress = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createWithEmailAndPassword(BuildContext context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: controllerEmail.text,
        password: controllerPassword.text,
      );

      await _firestore.collection('User').doc(controllerEmail.text).set({
        'Regno': RegnoController.text,
        'Name': controllerName.text,
        'Mobile': controllerMobile.text,
        'Age': controllerAge.text,
        'Address': controllerAddress.text,
        'Email': controllerEmail.text,
        'UID': userCredential.user!.uid,
      });

      // Navigate to HomePage on successful login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavBar()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget entryField(String title, TextEditingController controller) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some value';
        }
        return null;
      },
      controller: controller,
      //obscureText: controllerPassword,
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
        if (_formKey.currentState!.validate()) {
        createWithEmailAndPassword(context);
      }
    

        
      },
      child: const Text(
        'Sign Up',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Container(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      top: 10,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 140,
                      left: 10,
                      right: 10),
                  //color: const Color.fromARGB(255, 108, 199, 242),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/doc-pat.jpg'),
                        fit: BoxFit.cover),
                  ),

                  child: Form(
                    child: Column(
                      children: <Widget>[
                        entryField('Name', controllerName),
                        const SizedBox(height: 10),
                        entryField('Mobile Number', controllerMobile),
                        const SizedBox(height: 10),
                        entryField('Age', controllerAge),
                        const SizedBox(height: 10),
                        entryField('Registration Number',RegnoController ),
                        
                        const SizedBox(height: 10),
                        entryField('Address', controllerAddress),
                        const SizedBox(height: 10),
                        entryField('Email', controllerEmail),
                        const SizedBox(height: 10),
                        entryField('Password', controllerPassword),
                        _errorMessage(),
                        submitButton(context),
                        const SizedBox(
                          height: 10,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Are you a Doctor? '),
                          ],
                        ),
                        const SizedBox(height: 0),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DocSignUp(),
                                  ));
                            },
                            child: const Text(
                              'Register here',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))
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
