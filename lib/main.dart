import 'package:doct_appointment/features/dashboard/pages/doctor_dashboard.dart';
import 'package:doct_appointment/features/dashboard/pages/home_page.dart';
import 'package:doct_appointment/core/services/supabase_service.dart';
import 'package:doct_appointment/features/auth/widgets/auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase ONLY
  await SupabaseService.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doctor Appointment',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: SupabaseService.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = snapshot.data?.session;

        if (session != null) {
          return FutureBuilder<String>(
            future: _getUserRole(session.user.id),
            builder: (context, roleSnapshot) {
              if (roleSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }
              
              final role = roleSnapshot.data ?? 'patient';
              if (role == 'doctor') {
                return const DoctorDashboard();
              }
              return const HomePage();
            },
          );
        }

        return const Authpage();
      },
    );
  }

  Future<String> _getUserRole(String userId) async {
    // Override for your test account
    final user = SupabaseService.client.auth.currentUser;
    if (user?.email == 'devwithsai33@gmail.com') return 'doctor';

    try {
      final data = await SupabaseService.client
          .from('profiles')
          .select('role')
          .eq('id', userId)
          .single();
          
      return data['role'] ?? 'patient';
    } catch (e) {
      return 'patient';
    }
  }
}
