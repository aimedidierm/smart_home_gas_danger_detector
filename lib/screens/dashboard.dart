import 'package:flutter/material.dart';
import 'package:gas_detector/screens/gas_detected.dart';
import 'package:gas_detector/screens/no_gas_detected.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _gasDetected = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            height: 10,
          ),
          (_gasDetected) ? const GasDetected() : const NoGasDetected(),
          GestureDetector(
            onTap: () {
              setState(() {
                _gasDetected = !_gasDetected;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: (_gasDetected) ? Colors.red : Colors.green,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                child: (_gasDetected)
                    ? const Text(
                        'Close pipe',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      )
                    : const Text(
                        'Open pipe',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
