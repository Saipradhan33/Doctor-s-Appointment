import 'package:doct_appointment/core/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class SignInForm extends StatelessWidget {
   SignInForm({
    required this.email,
    required this.password,
    required this.border,
    required this.onSubmit,
    required this.onMagicLink,
  });
  final TextEditingController email;
  final TextEditingController password;
  final OutlineInputBorder border;
  final Future<void> Function() onSubmit;
  final Future<void> Function() onMagicLink;

  Future<AuthResponse> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: "108943094326-66fjgk4n0o4scrm1aurff4tv92m5d5t0.apps.googleusercontent.com",
      scopes: [
        'email',
        'https://www.googleapis.com/auth/userinfo.profile',
      ],
    );

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      throw Exception('Google sign-in aborted');
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    return await SupabaseService.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: googleAuth.idToken!,
      accessToken: googleAuth.accessToken,
    );
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          const Text('SIGN IN', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(
            controller: email,
            decoration: InputDecoration(
              hintText: 'Enter your Email',
              hintStyle: const TextStyle(fontSize: 18),
              border: border, focusedBorder: border, enabledBorder: border,
              prefixIcon: const Icon(Icons.mail),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: password,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.key),
              hintText: 'Enter your Password',
              hintStyle: const TextStyle(fontSize: 18),
              border: border, focusedBorder: border, enabledBorder: border,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: onSubmit, child: const Text('SIGN IN', style: TextStyle(fontWeight: FontWeight.bold))),
          const SizedBox(height: 10),
          TextButton(
            onPressed: onMagicLink,
            child: const Text('Login with Supabase Magic Link', style: TextStyle(color: Colors.blueAccent)),
          ),
          const SizedBox(height: 10),
          const Text('or SIGN IN with', style: TextStyle(fontSize: 15)),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(onPressed: (){},icon: Icon(FontAwesomeIcons.facebook, size: 30, color: Colors.blue)),
    IconButton(
    onPressed: () async {
    print('Google sign-in button pressed');
    try {
    final response = await signInWithGoogle();
    print('User signed in: ${response.user?.email}');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Signed in successfully")));
    } catch (e) {
    print('Sign-in error: $e');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error occurred: $e")));
    }
    },
    icon: Icon(FontAwesomeIcons.google, size: 30, color: Colors.blueGrey),
    ),
              IconButton(onPressed: (){},icon: Icon(FontAwesomeIcons.phone, size: 30, color: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }
}