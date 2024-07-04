import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: FetchDataScreen(),
    ),
  ));
}

class FetchDataScreen extends StatefulWidget {
  @override
  FetchDataScreenstate createState() => FetchDataScreenstate();
}

class FetchDataScreenstate extends State<FetchDataScreen> {
  String userName = '';
  String staffID = '';
  Map<String, dynamic>? evaluationData;

  @override
  void initState() {
    super.initState();
    fetchStaffDetails();
  }

  void fetchStaffDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String email = user.email ?? '';
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Auth_teacher')
          .where('Email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String fetchedStaffID = querySnapshot.docs.first['StaffID'];
        String fetchedName = querySnapshot.docs.first['Name'];
        setState(() {
          staffID = fetchedStaffID;
          userName = fetchedName;
        });
        fetchEvaluationData();
      } else {
        print('No document found for email: $email');
      }
    } else {
      print('User is not authenticated');
    }
  }

  void fetchEvaluationData() async {
    try {
      if (staffID.isEmpty) {
        print('Staff ID is empty.');
        return;
      }

      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Teacher_evaluation')
          .doc('Approved')
          .collection('teacher_approved_history')
          .doc(staffID)
          .get();

      if (snapshot.exists) {
        setState(() {
          evaluationData = snapshot.data() as Map<String, dynamic>?;
        });
      } else {
        print('No evaluation data found for staffID: $staffID');
      }
    } catch (e) {
      print('Error fetching evaluation data: $e');
    }
  }

  // Function to classify Penilaian Akhir score
  String classifyScore(double score) {
    if (score >= 90) {
      return 'CEMERLANG';
    } else if (score >= 80) {
      return 'TINGGI';
    } else if (score >= 60) {
      return 'SEDERHANA';
    } else {
      return 'RENDAH';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Penilaian Prestasi Tahunan $userName ($staffID)',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            if (evaluationData != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Penilaian Prestasi:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Display Penilaian Awal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Penilaian Awal:',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      Text(
                        '${(evaluationData!['Penilaian_awal'] as num).toStringAsFixed(2)}%',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Display Penilaian Akhir
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Penilaian Akhir:',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      Text(
                        '${(evaluationData!['Penilaian_akhir'] as num).toStringAsFixed(2)}%',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Display Classification based on Penilaian Akhir
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Klasifikasi:',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      Text(
                        '${classifyScore(evaluationData!['Penilaian_akhir'] ?? 0)}',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            if (evaluationData == null)
              Center(
                child: Text(
                  'Tiada data penilaian tersedia.',
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
