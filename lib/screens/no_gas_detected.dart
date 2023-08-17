import 'package:flutter/material.dart';

class NoGasDetected extends StatefulWidget {
  const NoGasDetected({super.key});

  @override
  State<NoGasDetected> createState() => _NoGasDetectedState();
}

class _NoGasDetectedState extends State<NoGasDetected> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.verified,
          color: Colors.green.withOpacity(0.4),
          size: 300,
        ),
        const Text(
          'No gas detected',
          style: TextStyle(
            color: Colors.green,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
