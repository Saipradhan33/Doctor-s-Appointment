import 'package:doct_appointment/widgets/main_navbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class App_form extends StatefulWidget {
  const App_form({super.key});

  @override
  State<App_form> createState() => _App_formState();
}

class _App_formState extends State<App_form>
    with SingleTickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();
  bool isHovering=false;
  final TextEditingController doctorController = TextEditingController();
  final TextEditingController patientController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  DateTime? selectedDate;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true);
  }

  InputDecoration modernInput(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Color(0xFFF6F7FB),
      contentPadding:
      EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    );
  }

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _submitAppointment() async {
    if (_formKey.currentState!.validate() && selectedDate != null) {
      final currentUser = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance.collection('appointments').add({
        'doctorName': doctorController.text,
        'patientName': patientController.text,
        'description': descriptionController.text,
        'date': Timestamp.fromDate(selectedDate!),
        'userId': currentUser?.uid ?? 'anonymous',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment booked successfully!')),
      );

      doctorController.clear();
      patientController.clear();
      descriptionController.clear();

      setState(() {
        selectedDate = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F6FB),
      appBar: MainNavBar(),
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animation.value),
              child: child,
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

            /// 🔥 Floating Bold Heading
            Text(
            "Book Your Dental Visit\nWith UCC\n 🦷",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black87
            ),
          ),

          SizedBox(height: 90),
          /// Your Existing Form Container
          Container(
            padding: EdgeInsets.all(28),
            width: MediaQuery.of(context).size.width > 800
                ? 600
                : MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 30,
                  offset: Offset(0, 20),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                            TextFormField(
                              controller: doctorController,
                              decoration: modernInput("Doctor Name"),
                              validator: (val) =>
                              val!.isEmpty ? "Enter doctor name" : null,
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: patientController,
                              decoration: modernInput("Patient Name"),
                              validator: (val) =>
                              val!.isEmpty ? "Enter patient name" : null,
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: descriptionController,
                              decoration: modernInput("Description"),
                            ),
                            SizedBox(height: 20),

                            /// Date Picker Styled
                            GestureDetector(
                              onTap: _pickDate,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 18),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF6F7FB),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      selectedDate == null
                                          ? "Pick Appointment Date"
                                          : selectedDate!
                                          .toLocal()
                                          .toString()
                                          .split(' ')[0],
                                      style: TextStyle(
                                          color: Colors.grey[700]),
                                    ),
                                    Icon(Icons.calendar_today_outlined,
                                        size: 18),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(height: 28),

                            /// Gradient Button
                            MouseRegion(
                              onEnter: (_) {
                                setState(() {
                                  isHovering = true;
                                });
                              },
                              onExit: (_) {
                                setState(() {
                                  isHovering = false;
                                });
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                height: 55,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: isHovering
                                      ? Color(0xFF0A0F3C) // Dark navy on hover
                                      : null,
                                  gradient: isHovering
                                      ? null
                                      : LinearGradient(
                                    colors: [
                                      Color(0xFF6C63FF),
                                      Color(0xFF5A54E8),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  onPressed: _submitAppointment,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Book Appointment",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        isHovering ? Icons.close : Icons.add,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
      );
  }
}