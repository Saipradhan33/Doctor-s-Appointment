import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sign_in_form.dart';
import 'sign_up_form.dart';
import 'gradient_panel.dart';

class Authpage extends StatefulWidget {
  const Authpage({super.key});
  @override
  State<Authpage> createState() => _AuthpageState();
}

class _AuthpageState extends State<Authpage> {
  bool showSignUp = false;

  // Controllers (shared + sign up)
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  final confirm = TextEditingController();

  Future<void> signin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      // Navigator.pushReplacement(context, '/home' as Route<Object?>);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sign in failed')));
    }
  }

  Future<void> signup() async {
    if (password.text.trim() != confirm.text.trim()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords don't match")));
      return;
    }
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      // Navigator.pushReplacement(context, '/home' as Route<Object?>);
      await FirebaseAuth.instance.currentUser?.updateDisplayName(
        name.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sign up failed')));
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
    final screenWidth = size.width;
    final screenHeight = size.height;
    final isMobile = screenWidth < 600;

    // Shared border
    const border = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black54),
      borderRadius: BorderRadius.horizontal(
        left: Radius.circular(50),
        right: Radius.circular(50),
      ),
    );

    // Layout metrics
    final shellHeight = isMobile ? screenHeight * 0.8 : screenHeight * 0.7;
    double shellWidth =
        isMobile ? screenWidth * 0.9 : (screenWidth > 1000 ? 900 : 700);

    // MOBILE: panel takes 40% height, form area 60% height.
    // DESKTOP/TABLET: split width into ~45% panel / 55% form.
    final panelHeightMobile = shellHeight * 0.40;
    final formHeightMobile = shellHeight - panelHeightMobile;

    final panelWidthWide =
        (screenWidth > 800 ? 450.0 : shellWidth * 0.45); // ~45%
    final formWidthWide = shellWidth - panelWidthWide;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
          child: AnimatedContainer(
            clipBehavior: Clip.none,
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
                // ---------- FORM AREA (positioned opposite to panel) ----------
                if (isMobile)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    // If panel is at top (showSignUp = true), form starts below it.
                    // If panel is at bottom, form starts at top.
                    top: showSignUp ? panelHeightMobile : 0,
                    left: 0,
                    right: 0,
                    height: formHeightMobile,
                    child: _FormShell(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child:
                            showSignUp
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
                                ),
                      ),
                    ),
                  )
                else
                  // WIDE: place form on the side opposite to the panel.
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
                        child:
                            showSignUp
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
                                ),
                      ),
                    ),
                  ),

                // ---------- GRADIENT PANEL (slides) ----------
                if (isMobile)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    // When showSignUp = true -> panel at top; false -> panel at bottom
                    top: showSignUp ? 0 : formHeightMobile,
                    left: 0,
                    right: 0,
                    height: panelHeightMobile,
                    child: GradientPanel(
                      title: showSignUp ? 'Welcome Back' : 'Hello Friend',
                      subtitle:
                          showSignUp
                              ? 'To keep connected enter your details'
                              : 'Enter your personal details',
                      cta: showSignUp ? 'SIGN IN' : 'SIGN UP',
                      onTap: () => setState(() => showSignUp = !showSignUp),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                        bottom: Radius.circular(20),
                      ),
                    ),
                  )
                else
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    top: 0,
                    bottom: 0,
                    // When showSignUp = true -> panel on the left; else on the right
                    left: showSignUp ? 0 : (shellWidth - panelWidthWide),
                    width: panelWidthWide,
                    child: GradientPanel(
                      title: showSignUp ? 'Welcome Back' : 'Hello Friend',
                      subtitle:
                          showSignUp
                              ? 'To keep connected enter your details'
                              : 'Enter your personal details',
                      cta: showSignUp ? 'SIGN IN' : 'SIGN UP',
                      onTap: () => setState(() => showSignUp = !showSignUp),
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(20),
                        right: Radius.circular(20),
                      ),
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

// ===== Decorative shells =====
class _FormShell extends StatelessWidget {
  const _FormShell({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: child,
      ),
    );
  }
}
