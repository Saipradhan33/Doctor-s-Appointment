import 'package:doct_appointment/features/appointments/widgets/app_form.dart';
import 'package:flutter/material.dart';

class TreatmentDetailPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const TreatmentDetailPage({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: CustomScrollView(
        slivers: [

          /// HERO HEADER
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(title),
              background: Hero(
                tag: title,
                child: Container(
                  color: Colors.blue.shade50,
                  child: Center(
                    child: Icon(
                      icon,
                      size: 120,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// PAGE CONTENT
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 10),

                  const Text(
                    "Best same-day implant clinic in Bhubaneswar",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "We provide advanced dental treatments with experienced dentists and modern technology.",
                    style: TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Advantages",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text("• Immediate relief"),
                  const Text("• Modern equipment"),
                  const Text("• Experienced dentists"),
                  const Text("• Affordable pricing"),

                  const SizedBox(height: 30),

                  /// WORKING HOURS CARD
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xff5F6FFF),
                          Color(0xff7A6CF6)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: const [

                        Text(
                          "Clinic Hours",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 10),

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Mon - Sat",
                                style: TextStyle(
                                    color: Colors.white70)),
                            Text("9:00 AM - 9:00 PM",
                                style:
                                TextStyle(color: Colors.white)),
                          ],
                        ),

                        SizedBox(height: 6),

                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Sunday",
                                style: TextStyle(
                                    color: Colors.white70)),
                            Text("9:00 AM - 2:00 PM",
                                style:
                                TextStyle(color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// EMERGENCY CARD
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: const [

                        Icon(Icons.phone,
                            color: Colors.indigo),

                        SizedBox(width: 10),

                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              "24/7 Emergency",
                              style: TextStyle(
                                  fontWeight:
                                  FontWeight.bold),
                            ),
                            Text("+91 9971053540")
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),

      /// BOOK BUTTON
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const App_form()
          )
          );
        },
        label: const Text("Book Appointment"),
        icon: const Icon(Icons.calendar_month),
      ),
    );
  }
}