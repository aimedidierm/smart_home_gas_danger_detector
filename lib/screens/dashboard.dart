import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:gas_detector/const.dart';
import 'package:gas_detector/models/api_response.dart';
import 'package:gas_detector/screens/gas_detected.dart';
import 'package:gas_detector/screens/no_gas_detected.dart';
import 'package:gas_detector/services/user.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _gasDetected = false;
  bool _valveOpen = true;
  Future<void> fetchData() async {
    String token = await getToken();
    final response = await http.get(Uri.parse(statusURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      bool gasDetected = decodedResponse['gas_detected'];
      bool valveOpen = decodedResponse['valve_open'];

      setState(() {
        // if (gasDetected == 1) {
        //   _gasDetected = true;
        // } else {
        //   _gasDetected = false;
        // }
        // if (valveOpen == 1) {
        //   _valveOpen = true;
        // } else {
        //   _valveOpen = false;
        // }
        _gasDetected = gasDetected;
        _valveOpen = valveOpen;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void updateValveStatus() async {
    ApiResponse response = await updateValve(_valveOpen);
    if (response.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Valve status updated updated!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

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
                _valveOpen = !_valveOpen;
                updateValveStatus();
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: (_valveOpen) ? Colors.red : Colors.green,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                child: (_valveOpen)
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
