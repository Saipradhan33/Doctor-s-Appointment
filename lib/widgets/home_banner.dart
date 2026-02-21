import 'package:flutter/material.dart';
class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // light background
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side (Text + Button)
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome to MedPlan\nBook your Doctor Consultation right now",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 16),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Handle button action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    "Consult Now",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 12),
                // Features row
                Row(
                  children: const [
                    Icon(Icons.verified, size: 16),
                    SizedBox(width: 4),
                    Text("Verified Doctors"),
                    SizedBox(width: 12),
                    Icon(Icons.receipt_long, size: 16),
                    SizedBox(width: 4),
                    Text("Digital Prescription"),
                    SizedBox(width: 12),
                    Icon(Icons.chat_bubble_outline, size: 16),
                    SizedBox(width: 4),
                    Text("Free Followup"),
                  ],
                ),
              ],
            ),
          ),

          // Right side (Image)
          // Expanded(
          //   flex: 1,
          //   child: Image.asset(
          //     "assets/images/Screenshot 2025-09-15 164403.png", // your doctor lady image
          //     fit: BoxFit.contain,
          //   ),
          // ),
        ],
      ),
    );
  }
}
