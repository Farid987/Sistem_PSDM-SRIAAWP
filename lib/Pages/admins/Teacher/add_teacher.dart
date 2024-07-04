import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddTeacherWidget extends StatefulWidget {
  @override
  _AddTeacherWidgetState createState() => _AddTeacherWidgetState();
}

class _AddTeacherWidgetState extends State<AddTeacherWidget> {
  // Define TextEditingController instances
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController staffIDController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generateStaffID();
  }

  @override
  void dispose() {
    // Dispose of the controllers to avoid memory leaks
    nameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    staffIDController.dispose();
    super.dispose();
  }

  void _generateStaffID() {
    final random = Random();
    final randomNumber = random.nextInt(1000).toString().padLeft(3, '0');
    staffIDController.text = 'ST$randomNumber';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tambah Pengguna (Guru)',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            _buildTextField('Nama',
                hintText: 'Masukkan Nama', controller: nameController),
            SizedBox(height: 20),
            _buildTextField('E-mel',
                hintText: 'Masukkan E-mel', controller: emailController),
            SizedBox(height: 20),
            _buildTextField('Kata laluan',
                hintText: 'Masukkan Kata laluan',
                controller: passwordController),
            SizedBox(height: 20),
            _buildTextField('ID Guru',
                hintText: 'Generated Staff ID',
                controller: staffIDController,
                isReadOnly: true),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle submit button action
                  _handleSubmit();
                },
                child: Text(
                  'Hantar',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label,
      {String? hintText,
      required TextEditingController controller,
      bool isReadOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller, // Pass the controller here
          readOnly: isReadOnly,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
            ),
          ),
        ),
      ],
    );
  }

  void _handleSubmit() async {
    // Get the text entered in the text fields
    String name = nameController.text.trim();
    String password = passwordController.text.trim();
    String email = emailController.text.trim();
    String staffID = staffIDController.text.trim();

    // Prepare the data to be stored
    Map<String, dynamic> teacherData = {
      'Name': name,
      'Email': email,
      'Password': password,
      'StaffID': staffID,
    };

    // Save the data to Firestore and create user in Firebase Authentication
    try {
      // Create user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('User registered successfully: ${userCredential.user?.uid}');

      // Save the data to Firestore
      await FirebaseFirestore.instance
          .collection('Auth_teacher')
          .doc(email)
          .set(teacherData);
      print('Teacher data added successfully');

      // Clear text fields and generate a new StaffID after submission
      nameController.clear();
      emailController.clear();
      passwordController.clear();
      _generateStaffID();
    } catch (e) {
      print('Error adding teacher data or registering user: $e');
    }
  }
}