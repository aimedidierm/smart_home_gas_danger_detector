import 'package:flutter/material.dart';

class GasDetected extends StatefulWidget {
  const GasDetected({super.key});

  @override
  State<GasDetected> createState() => _GasDetectedState();
}

class _GasDetectedState extends State<GasDetected> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.dangerous,
          color: Colors.red.withOpacity(0.4),
          size: 300,
        ),
        const Text(
          'Gas detected',
          style: TextStyle(
            color: Colors.red,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
