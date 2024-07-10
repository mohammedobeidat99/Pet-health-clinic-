import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pethhealth/components/applocal.dart';
import 'package:pethhealth/constant/color.dart';
import 'package:pethhealth/constant/images.dart';
import 'package:pethhealth/screen/auth/login_screen.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _email = '';

  String _password = '';

  String _username = '';

  String _phone = '';
  

  String _selectedCity = 'Amman';
  // Default city selection
  bool _showOtherTextField = false;

  String _otherArea = '';

  Future<void> _register(BuildContext context) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      // Save additional user data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'username': _username,
        'email': _email,
        'password': _password,
        'phone': _phone,
        'city': _selectedCity != 'Other' ? _selectedCity : _otherArea,
      });

      // Show success notification
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: mainColor,
          content: Text(getLang(context, 'successfully')),
        ),
      );

      // Navigate to login page
      Navigator.of(context).pop(); // Dismiss the signup page
      // Navigate to the login page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              LoginPage(), // Replace LoginPage with your login page widget
        ),
      );
    } catch (e) {
      // Handle registration errors
      print('Error registering user: $e');
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: mainColor,
          content: Text('Registration failed: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cityMap = {
      'Amman': getLang(context, 'amman'),
      'Irbid': getLang(context, 'irbid'),
      'Other': getLang(context, 'other'),
    };
     bool isRtl = Directionality.of(context) == TextDirection.rtl;
    Alignment alignment = isRtl ? Alignment.topRight : Alignment.topLeft;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 50.0),
                  Container(
                    height: 150.0,
                    child: Image.asset(
                      imageLogo, // Replace with your logo path
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment:alignment,
                    child: Text(
                      getLang(context, 'sginup'),
                      style: TextStyle(
                          fontSize: 25.0,
                          wordSpacing: 5,
                          fontWeight: FontWeight.w600,
                          color: mainColor),
                    ),
                  ),
                  Container(
                    height: 50,
                    child: TextFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: mainColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: mainColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        suffixIcon: Icon(Icons.person, color: mainColor),
                        labelText: getLang(context, 'username'),
                        labelStyle: const TextStyle(color: mainColor),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                      onChanged: (value) => _username = value,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Container(
                    height: 50,
                    child: TextFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: mainColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: mainColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        suffixIcon: const Icon(Icons.phone, color: mainColor),
                        labelText: getLang(context, 'number'),
                        labelStyle: const TextStyle(color: mainColor),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your Number';
                        }
                        return null;
                      },
                      onChanged: (value) => _phone = value,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Container(
                    height: 50,
                    child: TextFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: mainColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: mainColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        suffixIcon: const Icon(Icons.email, color: mainColor),
                        labelText: getLang(context, 'email'),
                        labelStyle: const TextStyle(color: mainColor),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      onChanged: (value) => _email = value,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Container(
                    height: 50,
                    child: TextFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: mainColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: mainColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        suffixIcon: const Icon(Icons.lock, color: mainColor),
                        labelText: getLang(context, 'password'),
                        labelStyle: const TextStyle(color: mainColor),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        _password = value;
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Container(
                    height: 50,
                    child: TextFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: mainColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: mainColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        suffixIcon: const Icon(Icons.lock, color: mainColor),
                        labelText: getLang(context, 'confarm'),
                        labelStyle: const TextStyle(color: mainColor),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _password) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: mainColor),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: mainColor),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      suffixIcon:
                          const Icon(Icons.location_on, color: mainColor),
                      labelStyle: const TextStyle(color: mainColor),
                    ),
                    value: _selectedCity,
                    items: cityMap.entries
                        .map<DropdownMenuItem<String>>((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCity = newValue!;
                        _showOtherTextField = _selectedCity == 'Other';
                      });
                    },
                  ),
                  if (_showOtherTextField)
                    ...[
                      const SizedBox(height: 15.0),
                      Container(
                        height: 50,
                        child: TextFormField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: mainColor),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: mainColor),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            suffixIcon: const Icon(Icons.location_city,
                                color: mainColor),
                            labelText: getLang(context, 'entercity'),
                            labelStyle: const TextStyle(color: mainColor),
                          ),
                          validator: (value) {
                            if (_showOtherTextField && value!.isEmpty) {
                              return 'Please enter your city';
                            }
                            return null;
                          },
                          onChanged: (value) => _otherArea = value,
                        ),
                      ),
                    ],
                  const SizedBox(height: 15.0),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(mainColor)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _register(context);
                      }
                    },
                    child: Text(
                      getLang(context, 'sginup'),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print('Go Register Page');
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      child: Text.rich(TextSpan(children: [
                        TextSpan(
                          text: getLang(context, 'already'),
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextSpan(
                          text: getLang(context, 'login'),
                          style: TextStyle(color: mainColor),
                        ),
                      ])),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
