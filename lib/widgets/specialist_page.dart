import 'package:flutter/material.dart';

class SpecialistPage extends StatelessWidget {
  final String specialistName;

  const SpecialistPage({super.key, required this.specialistName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(specialistName),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: 2, // temporary dummy doctors
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.cyan.shade100,
                child: Icon(Icons.person, color: Colors.cyan),
              ),
              title: Text("Dr. Doctor ${index + 1}"),
              subtitle: Text(specialistName),
              trailing: ElevatedButton(
                onPressed: () {
                  // navigate to booking page later
                },
                child: const Text("Book"),
              ),
            ),
          );
        },
      ),
    );
  }
}
