import 'package:flutter/material.dart';
class GradientPanel extends StatelessWidget {
  const GradientPanel({
    required this.title,
    required this.subtitle,
    required this.cta,
    required this.onTap,
    required this.borderRadius,
  });

  final String title;
  final String subtitle;
  final String cta;
  final VoidCallback onTap;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blueAccent, Color.fromARGB(255, 148, 130, 177)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 20),
            OutlinedButton(onPressed: onTap, child: Text(cta)),
          ],
        ),
      ),
    );
  }
}
