import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class App_form extends StatefulWidget {
  const App_form({super.key});

  @override
  State<App_form> createState() => _App_formState();
}

class _App_formState extends State<App_form> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController doctorController = TextEditingController();
  final TextEditingController patientController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime? selectedDate;
  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
  void _submitAppointment() async {
    if (_formKey.currentState!.validate() && selectedDate != null) {
      final currentUser = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance.collection('appointments').add({
        'doctorName': doctorController.text,
        'patientName': patientController.text,
        'description': descriptionController.text,
        'date': Timestamp.fromDate(selectedDate!),
        'userId': currentUser?.uid ?? 'anonymous',
      }
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment added!')),
      );

      doctorController.clear();
      patientController.clear();
      descriptionController.clear();
      setState(() {
        selectedDate = null;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: doctorController,
                decoration: const InputDecoration(labelText: 'Doctor Name'),
                validator: (val) =>
                val!.isEmpty ? 'Please enter doctor name' : null,
              ),
              TextFormField(
                controller: patientController,
                decoration: const InputDecoration(labelText: 'Patient Name'),
                validator: (val) =>
                val!.isEmpty ? 'Please enter patient name' : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(selectedDate == null
                      ? 'No date chosen'
                      : 'Date: ${selectedDate!.toLocal()}'
                      .split(' ')[0]),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _pickDate,
                    child: const Text('Pick Date'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _submitAppointment,
                child: const Text('Book Appointment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
