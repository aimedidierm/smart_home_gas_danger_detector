import 'package:flutter/material.dart';
import 'package:gas_detector/models/api_response.dart';
import 'package:gas_detector/models/user.dart';
import 'package:gas_detector/screens/home.dart';
import 'package:gas_detector/screens/login.dart';
import 'package:gas_detector/services/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool _loading = false;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();

  void ForgetPasswordUser() async {
    ApiResponse response = await forgetUserPassword(email.text);
    if (response.error == null) {
      setState(() {
        _loading = false;
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
          (route) => false);
    } else {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'SGDDS Forget Password',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          Form(
            key: formkey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  TextFormField(
                    controller: email,
                    validator: (val) =>
                        val!.isEmpty ? 'Your email is required' : null,
                    decoration: const InputDecoration(
                      labelText: 'Enter your email',
                      contentPadding: EdgeInsets.all(8.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          GestureDetector(
            onTap: () {
              if (formkey.currentState!.validate()) {
                setState(() {
                  _loading = true;
                });
                ForgetPasswordUser();
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                child: _loading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        'Send SMS',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
