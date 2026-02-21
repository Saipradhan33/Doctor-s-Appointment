import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Appt extends StatefulWidget {
  const Appt({super.key});

  @override
  State<Appt> createState() => _ApptState();
}

class _ApptState extends State<Appt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appointments')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 📅 Appointments List
            const Text('Available Appointments',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .orderBy('date')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                final appointments = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final data =
                    appointments[index].data() as Map<String, dynamic>;
                    final timestamp = data['date'] as Timestamp;
                    final date = timestamp.toDate();

                    return Card(
                      child: ListTile(
                        title: Text(data['doctorName'] ?? 'Unknown Doctor'),
                        subtitle: Text(
                            '${data['patientName'] ?? ''}\n${date.toLocal()}'
                                .split(' ')[0]),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
