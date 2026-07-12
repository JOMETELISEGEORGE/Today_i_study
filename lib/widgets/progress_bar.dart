import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double progress; // 0.0 → 1.0

  const ProgressBar({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 10,
        backgroundColor: Colors.grey.shade300,
        valueColor: AlwaysStoppedAnimation<Color>(
          Colors.blue.shade400,
        ),
      ),
    );
  }
}
