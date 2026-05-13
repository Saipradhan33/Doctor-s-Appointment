import 'dart:async';
import 'package:flutter/material.dart';

class ToothProgress extends StatefulWidget {
  const ToothProgress({super.key});

  @override
  State<ToothProgress> createState() => _ToothProgressState();
}

class _ToothProgressState extends State<ToothProgress> {
  double progress = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(milliseconds: 25), (t) {
      if (progress < 82) {
        setState(() {
          progress++;
        });
      } else {
        t.cancel();
      }
    });
  }

  /// Returns a stage label + color based on current progress
  ({String label, Color color}) get progressStage {
    if (progress < 20) {
      return (label: 'Just Started', color: Colors.redAccent);
    } else if (progress < 40) {
      return (label: 'Early Recovery', color: Colors.orange);
    } else if (progress < 60) {
      return (label: 'Getting Better', color: Colors.amber.shade700);
    } else if (progress < 80) {
      return (label: 'Almost Healed', color: Colors.lightGreen.shade600);
    } else {
      return (label: 'Fully Recovered!', color: Colors.green.shade600);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double percent = progress / 100.0;
    final stage = progressStage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [

        /// Stage label
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              stage.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: stage.color,
                letterSpacing: 0.3,
              ),
            ),
            Text(
              "${progress.toInt()}%",
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        /// Progress bar with moving tooth icon
        SizedBox(
          height: 50,
          width: double.infinity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              double barWidth = constraints.maxWidth;
              double toothPosition = barWidth * percent;

              return Stack(
                clipBehavior: Clip.none,
                children: [

                  /// Progress line
                  Positioned.fill(
                    top: 20,
                    child: CustomPaint(
                      painter: ToothProgressPainter(percent, stage.color),
                    ),
                  ),

                  /// Tooth icon (moves along bar)
                  Positioned(
                    left: (toothPosition - 12).clamp(0.0, barWidth - 24),
                    top: 4,
                    child: Icon(
                      Icons.medical_services,
                      size: 22,
                      color: stage.color,
                    ),
                  ),
                ],
              );
            },
          ),
        ),

        const SizedBox(height: 4),

        /// Start / End labels
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Start', style: TextStyle(fontSize: 11, color: Colors.grey)),
            Text('Full Recovery', style: TextStyle(fontSize: 11, color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}

class ToothProgressPainter extends CustomPainter {
  final double progress;
  final Color activeColor;

  const ToothProgressPainter(this.progress, this.activeColor);

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = activeColor
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      bgPaint,
    );

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width * progress, size.height / 2),
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(ToothProgressPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.activeColor != activeColor;
}