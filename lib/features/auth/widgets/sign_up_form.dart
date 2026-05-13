import 'package:flutter/material.dart';
class SignUpForm extends StatelessWidget {
  const SignUpForm({
    required this.name,
    required this.email,
    required this.password,
    required this.confirm,
    required this.border,
    required this.onSubmit,
  });

  final TextEditingController name;
  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController confirm;
  final OutlineInputBorder border;
  final Future<void> Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const SizedBox(height: 8),
          const Text('SIGN UP', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: name,
            decoration: InputDecoration(
              hintText: 'Full Name',
              border: border, focusedBorder: border, enabledBorder: border,
              prefixIcon: const Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: email,
            decoration: InputDecoration(
              hintText: 'Email',
              border: border, focusedBorder: border, enabledBorder: border,
              prefixIcon: const Icon(Icons.mail),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: password,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Password',
              border: border, focusedBorder: border, enabledBorder: border,
              prefixIcon: const Icon(Icons.lock),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: confirm,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Confirm Password',
              border: border, focusedBorder: border, enabledBorder: border,
              prefixIcon: const Icon(Icons.lock_outline),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onSubmit, child: const Text('CREATE ACCOUNT')),
        ],
      ),
    );
  }
}