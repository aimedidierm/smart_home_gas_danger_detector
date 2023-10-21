import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gas_detector/const.dart';
import 'package:gas_detector/models/api_response.dart';
import 'package:gas_detector/screens/login.dart';
import 'package:gas_detector/services/user.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _loading = false;
  List<Map<String, dynamic>> _userDetails = [];
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  Future<void> fetchData() async {
    String token = await getToken();
    final response = await http.get(Uri.parse(profileURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      final List<Map<String, dynamic>> userDetails = [decodedResponse['user']];

      setState(() {
        _userDetails = userDetails;
      });

      if (_userDetails.isNotEmpty) {
        name.text = _userDetails[0]['name'];
        email.text = _userDetails[0]['email'];
        phone.text = _userDetails[0]['phone'];
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void updateUser() async {
    ApiResponse response = await updateDetails(
      name.text,
      email.text,
      phone.text,
      password.text,
    );
    if (response.error == null) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User details updated!'),
        ),
      );
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
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(
          height: 10,
        ),
        const Center(
          child: Text(
            'You can update your details',
            style: TextStyle(
                color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Form(
          key: formkey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                TextFormField(
                  controller: name,
                  validator: (val) =>
                      val!.isEmpty ? 'Names are required' : null,
                  decoration: const InputDecoration(
                    labelText: 'Enter your names',
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
                TextFormField(
                  controller: email,
                  validator: (val) {
                    RegExp regex = RegExp(r'\w+@\w+\.\w+');
                    if (val!.isEmpty) {
                      return 'Email is required';
                    } else if (!regex.hasMatch(val)) {
                      return 'Email must have @';
                    } else {
                      return null;
                    }
                  },
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
                TextFormField(
                  controller: phone,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Phone is required';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Enter your phone',
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
                TextFormField(
                  controller: password,
                  obscureText: true,
                  validator: (val) =>
                      val!.isEmpty ? 'Password is required' : null,
                  decoration: const InputDecoration(
                    labelText: 'Enter password',
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
                TextFormField(
                  obscureText: true,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Password confirmation is required';
                    } else if (val != password.text) {
                      return 'Passwords not match';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: 'Confirm password',
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _loading = true;
              });
              updateUser();
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                child: Center(
                  child: _loading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Update',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: GestureDetector(
            onTap: () {
              setState(() {
                logout().then(
                  (value) => {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const Login()),
                        (route) => false),
                  },
                );
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                child: Center(
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
