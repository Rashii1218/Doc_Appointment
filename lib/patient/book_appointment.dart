import 'package:flutter/material.dart';

class book_appointment extends StatefulWidget {
  const book_appointment({super.key});

  @override
  State<book_appointment> createState() => _book_appointmentState();
}

class _book_appointmentState extends State<book_appointment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}