import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:doct_appointment/core/services/supabase_service.dart';
import 'gradient_panel.dart';
import 'sign_in_form.dart';
import 'sign_up_form.dart';

class Authpage extends StatefulWidget {
  const Authpage({super.key});
  @override
  State<Authpage> createState() => _AuthpageState();
}

class _AuthpageState extends State<Authpage> {
  bool showSignUp = false;

  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  final confirm = TextEditingController();

  Future<void> signin() async {
    try {
      await SupabaseService.client.auth.signInWithPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login error: $e")));
    }
  }

  Future<void> signInWithSupabaseMagicLink() async {
    if (email.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter email for magic link")));
      return;
    }
    try {
      await SupabaseService.client.auth.signInWithOtp(
        email: email.text.trim(),
        emailRedirectTo: 'io.supabase.flutterquickstart://login-callback/',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Magic link sent to your email!")),
        );
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> signup() async {
    if (password.text.trim() != confirm.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Passwords don't match")));
      return;
    }
    try {
      await SupabaseService.client.auth.signUp(
        email: email.text.trim(),
        password: password.text.trim(),
        data: {
          'full_name': name.text.trim(),
          'role': 'patient', 
        },
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Check your email for confirmation!")),
        );
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    name.dispose();
    confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    // Shared border
    const border = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black54),
      borderRadius: BorderRadius.all(Radius.circular(50)),
    );

    final shellHeight = isMobile ? size.height * 0.8 : size.height * 0.7;
    double shellWidth = isMobile ? size.width * 0.9 : (size.width > 1000 ? 900 : 700);

    final panelHeightMobile = shellHeight * 0.40;
    final formHeightMobile = shellHeight - panelHeightMobile;

    final panelWidthWide = (size.width > 800 ? 450.0 : shellWidth * 0.45);
    final formWidthWide = shellWidth - panelWidthWide;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: AnimatedContainer(
            clipBehavior: Clip.antiAlias,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            height: shellHeight,
            width: shellWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                if (isMobile)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    top: showSignUp ? panelHeightMobile : 0,
                    left: 0,
                    right: 0,
                    height: formHeightMobile,
                    child: _FormShell(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: showSignUp
                            ? SignUpForm(
                                name: name,
                                email: email,
                                password: password,
                                confirm: confirm,
                                border: border,
                                onSubmit: signup,
                              )
                            : SignInForm(
                                email: email,
                                password: password,
                                border: border,
                                onSubmit: signin,
                                onMagicLink: signInWithSupabaseMagicLink,
                              ),
                      ),
                    ),
                  )
                else
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    top: 0,
                    bottom: 0,
                    left: showSignUp ? panelWidthWide : 0,
                    width: formWidthWide,
                    child: _FormShell(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: showSignUp
                            ? SignUpForm(
                                name: name,
                                email: email,
                                password: password,
                                confirm: confirm,
                                border: border,
                                onSubmit: signup,
                              )
                            : SignInForm(
                                email: email,
                                password: password,
                                border: border,
                                onSubmit: signin,
                                onMagicLink: signInWithSupabaseMagicLink,
                              ),
                      ),
                    ),
                  ),

                if (isMobile)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    top: showSignUp ? 0 : formHeightMobile,
                    left: 0,
                    right: 0,
                    height: panelHeightMobile,
                    child: GradientPanel(
                      title: showSignUp ? 'Welcome Back' : 'Hello Friend',
                      subtitle: showSignUp ? 'To keep connected enter your details' : 'Enter your personal details',
                      cta: showSignUp ? 'SIGN IN' : 'SIGN UP',
                      onTap: () => setState(() => showSignUp = !showSignUp),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.circular(20)),
                    ),
                  )
                else
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    top: 0,
                    bottom: 0,
                    left: showSignUp ? 0 : (shellWidth - panelWidthWide),
                    width: panelWidthWide,
                    child: GradientPanel(
                      title: showSignUp ? 'Welcome Back' : 'Hello Friend',
                      subtitle: showSignUp ? 'To keep connected enter your details' : 'Enter your personal details',
                      cta: showSignUp ? 'SIGN IN' : 'SIGN UP',
                      onTap: () => setState(() => showSignUp = !showSignUp),
                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(20), right: Radius.circular(20)),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FormShell extends StatelessWidget {
  const _FormShell({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: child,
      ),
    );
  }
}
