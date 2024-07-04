import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/Pages/admins/homepage3.dart';

import 'Parents/homepage2.dart';
import 'Teachers/homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _errorMessage;
  bool _isObscured = true;

  Future<void> _login() async {
    final BuildContext context = this.context; // Store context locally

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Check if the email exists in any of the collections
      DocumentSnapshot adminSnapshot = await _firestore
          .collection('Auth_Admin')
          .doc(_emailController.text)
          .get();

      DocumentSnapshot teacherSnapshot = await _firestore
          .collection('Auth_teacher')
          .doc(_emailController.text)
          .get();

      DocumentSnapshot parentSnapshot = await _firestore
          .collection('Auth_parent')
          .doc(_emailController.text)
          .get();

      if (adminSnapshot.exists) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Admins(user: userCredential.user),
          ),
        );
      } else if (teacherSnapshot.exists) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Teachers(user: userCredential.user),
          ),
        );
      } else if (parentSnapshot.exists) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Parents(user: userCredential.user),
          ),
        );
      } else {
        // No matching email found in any collection
        setState(() {
          _errorMessage = "Invalid email or password.";
        });
      }
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => HomePage4(user: userCredential.user),
      //   ),
      // );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _register(context); // Pass context to the method
      } else {
        setState(() {
          _errorMessage = e.message;
        });
      }
    }
  }

  Future<void> _register(BuildContext context) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Admins(user: userCredential.user),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    }
  }

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      setState(() {
        _errorMessage = "Sign-out successful.";
      });
    } catch (e) {
      setState(() {
        _errorMessage = "An error happened during sign-out.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
      title: const Text('Login Page'),
    ),*/
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'lib/assets/login.png'), // Replace with your image path
            fit: BoxFit.fill, // Adjust fit as needed
          ),
        ),
        //color: Colors.white, // Set background color to white
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Column for Logo and Description
              Column(
                children: [
                  // Logo Container
                  Container(
                    width: 175, // Fixed width
                    height: 175, // Fixed height
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'lib/assets/Logo.png'), // Replace with your image path
                        fit: BoxFit.contain, // Adjust fit as needed
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Spacing between logo and description
                  // Description Text
                  Text(
                    'Sekolah Rendah Islam Al-Amin',
                    style: TextStyle(
                      fontFamily:
                          'Serif', // Use a serif font or any other suitable aesthetic font
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(
                  height: 50), // Spacing between description and input fields
              // Center the Input Fields Container
              Center(
                child: Container(
                  width: 700.0, // Set the width of the container
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Color.fromARGB(255, 245, 239, 255),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Email TextField
                          Row(
                            children: [
                              Icon(Icons.email, color: Colors.blue.shade700),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    labelStyle: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          // Password TextField
                          Row(
                            children: [
                              Icon(Icons.lock, color: Colors.blue.shade700),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    labelStyle: TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontWeight: FontWeight.bold),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _isObscured
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.blue.shade700,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isObscured = !_isObscured;
                                        });
                                      },
                                    ),
                                  ),
                                  obscureText: _isObscured,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                ),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
