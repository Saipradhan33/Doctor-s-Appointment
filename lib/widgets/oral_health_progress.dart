import 'package:flutter/material.dart';

class OralHealthProgress extends StatelessWidget {
  const OralHealthProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: 0.82),
      duration: const Duration(seconds: 2),
      builder: (context, value, child) {
        return SizedBox(
          width: 140,
          height: 140,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: value,
                strokeWidth: 10,
                color: Colors.cyan,
              ),
              Icon(
                Icons.medical_services,
                size: 40,
              ),
              Text(
                "${(value * 100).toInt()}%",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}