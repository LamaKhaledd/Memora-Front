import 'package:flutter/material.dart';

class InfoColumn extends StatelessWidget {
  final String title;
  final String value;

  const InfoColumn({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70, // Lighter white text for labels
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white, // White text for values
          ),
        ),
      ],
    );
  }
}
