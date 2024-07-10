import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pethhealth/components/applocal.dart';
import 'package:pethhealth/constant/color.dart';
import 'package:pethhealth/constant/images.dart';
import 'package:pethhealth/screen/auth/signup_screen.dart';
import 'package:pethhealth/screen/home/control_page.dart';

class LoginPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      // Sign in with email and password
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Navigate to the next screen or perform other actions upon successful login
      // For example, navigate to the home screen
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigationExample()));
    } catch (e) {
      // Handle login errors
      print('Error signing in: $e');
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: $e'),
        ),
      );
    }
  }

  Future<void> _resetPassword(BuildContext context, String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset email sent.'),
        ),
      );
    } catch (e) {
      print('Error sending password reset email: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String _email = '';
    String _password = '';
    bool isRtl = Directionality.of(context) == TextDirection.rtl;
    Alignment alignment = isRtl ? Alignment.topRight : Alignment.topLeft;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 50.0),
                // Logo
                Container(
                  height: 150.0,
                  child: Image.asset(
                    imageLogo,
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: alignment,
                  child: Text(
                    getLang(context, 'login'),
                    style: TextStyle(
                      fontSize: 25.0,
                      wordSpacing: 5,
                      fontWeight: FontWeight.w600,
                      color: mainColor,
                    ),
                  ),
                ),
                // Email Field
                Container(
                  height: 50,
                  child: TextField(
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
                      labelStyle: const TextStyle(color: Colors.black),
                    ),
                    onChanged: (value) => _email = value,
                  ),
                ),
                const SizedBox(height: 15.0),
                // Password Field
                Container(
                  height: 50,
                  child: TextField(
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
                      labelStyle: const TextStyle(color: Colors.black),
                    ),
                    obscureText: true,
                    onChanged: (value) => _password = value,
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      if (_email.isNotEmpty) {
                        _resetPassword(context, _email);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please enter your email to reset password.'),
                          ),
                        );
                      }
                    },
                    child: Text(
                      getLang(context, 'forget'),
                      style: TextStyle(color: mainColor, fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                // Login Button
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(mainColor),
                  ),
                  onPressed: () {
                    _signInWithEmailAndPassword(context, _email, _password);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.login,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        getLang(context, 'signin'),
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                        text: getLang(context, 'dont'),
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextSpan(
                        text: getLang(context, 'regster'),
                        style: TextStyle(color: mainColor),
                      ),
                    ])),
                  ),
                ),
                const SizedBox(height: 10.0),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: mainColor,
                          indent: 15,
                          endIndent: 10,
                        ),
                      ),
                      Text(
                        getLang(context, 'or'),
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                      Expanded(
                        child: Divider(
                          color: mainColor,
                          indent: 15,
                          endIndent: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                // Social login buttons
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 241, 123, 115)),
                  ),
                  onPressed: () {
                    // Implement Google Sign-In functionality here
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/google.png',
                        width: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        getLang(context, 'google'),
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 56, 115, 218)),
                  ),
                  onPressed: () {
                    // Implement Facebook Sign-In functionality here
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/facebook.png',
                        width: 25,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        getLang(context, 'facebook'),
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
