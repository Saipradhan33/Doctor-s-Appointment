import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
class GoogleSigin extends StatelessWidget {
  const GoogleSigin(
      {super.key,
        required this.onSubmit,
      });
  final Future<void> Function() onSubmit;



  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
