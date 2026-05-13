import 'package:doct_appointment/core/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: SupabaseService.client
                  .from('appointments')
                  .stream(primaryKey: ['id'])
                  .order('scheduled_at'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No appointments found.');
                }

                final appointments = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final data = appointments[index];
                    final date = DateTime.parse(data['scheduled_at']);

                    return Card(
                      child: ListTile(
                        title: Text(data['doctor_name'] ?? 'Unknown Doctor'),
                        subtitle: Text(
                            '${data['patient_name'] ?? ''}\n${date.toLocal()}'
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
