import 'package:doct_appointment/firebase_options.dart';
import 'package:doct_appointment/home_page.dart';
import 'package:doct_appointment/widgets/app_form.dart';
import 'package:doct_appointment/widgets/auth.dart';
import 'package:doct_appointment/widgets/home_banner.dart';
import 'package:doct_appointment/widgets/oral_health_progress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      ),
      home: HomePage(),
      // home: StreamBuilder<User?>(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Scaffold(
      //         body: Center(child: CircularProgressIndicator()),
      //       );
      //     }
      //     if (snapshot.hasData) {
      //       return const HomePage(); // Authenticated
      //     }
      //     return const Authpage(); // Not signed in
      //   },
      // );,
    );
  }
}
