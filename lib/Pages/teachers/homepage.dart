import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../loginpage.dart';
import 'good_deeds.dart';
import 'leaderboard_screen.dart';
import 'results_assessment.dart';
import 'self_assessment.dart';

class Teachers extends StatefulWidget {
  final User? user;

  const Teachers({Key? key, this.user}) : super(key: key);

  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<Teachers> {
  String staffID = '';
  String name = '';
  bool showLeaderboard = false;
  bool showGoodDeeds = false;
  bool showSelfAssessment = false;
  bool resultSelfAssessment = false;

  @override
  void initState() {
    super.initState();
    fetchStaffDetails();
  }

  void fetchStaffDetails() async {
    String email = widget.user?.email ?? '';
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Auth_teacher')
        .where('Email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String fetchedStaffID = querySnapshot.docs.first['StaffID'];
      String fetchedName = querySnapshot.docs.first['Name'];
      setState(() {
        staffID = fetchedStaffID;
        name = fetchedName;
      });
    } else {
      print('No document found for email: $email');
    }
  }

  void toggleLeaderboard() {
    setState(() {
      showLeaderboard = !showLeaderboard;
      if (showLeaderboard) {
        showGoodDeeds = false;
        showSelfAssessment = false;
        resultSelfAssessment = false;
      }
    });
  }

  void toggleGoodDeeds() {
    setState(() {
      showGoodDeeds = !showGoodDeeds;
      if (showGoodDeeds) {
        showLeaderboard = false;
        showSelfAssessment = false;
        resultSelfAssessment = false;
      }
    });
  }

  void toggleSelfAssessment() {
    setState(() {
      showSelfAssessment = !showSelfAssessment;
      if (showSelfAssessment) {
        showLeaderboard = false;
        showGoodDeeds = false;
        resultSelfAssessment = false;
      }
    });
  }

  void resultSelfassessment() {
    setState(() {
      resultSelfAssessment = !resultSelfAssessment;
      if (resultSelfAssessment) {
        showLeaderboard = false;
        showSelfAssessment = false;
        showGoodDeeds = false;
      }
    });
  }

  void logout() {
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[900],
        iconTheme: IconThemeData(
          color: Colors.white, // Change the drawer icon color
        ),
        title: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Selamat Datang $name ($staffID)',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
                // Add some padding for better appearance
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromARGB(
                          255, 255, 255, 255)), // Change color as needed
                  borderRadius: BorderRadius.circular(
                      8.0), // Optional: make the border rounded
                ),
                child: Text(
                  'Sistem Penilaian Sahsiah Diri Murid',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight:
                          FontWeight.bold), // Adjust the font size as needed
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: MyDrawer(
        toggleGoodDeeds: toggleGoodDeeds,
        toggleLeaderboard: toggleLeaderboard,
        toggleSelfAssessment: toggleSelfAssessment,
        resultSelfAssessment: resultSelfassessment,
      ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'lib/assets/Background.png'), // Replace with your image path
                fit: BoxFit.fill, // Adjust fit as needed
              ),
            ),
          ),
          // Main Content Area
          Positioned(
            left: MediaQuery.of(context).size.width * 0.2,
            top: 70,
            bottom: 45,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Container(
              color: Colors.transparent, // Make the container transparent
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showLeaderboard) ...[
                      LeaderboardWidget(),
                    ] else if (showGoodDeeds) ...[
                      GoodDeedsWidget(
                        staffID: staffID,
                        studentID: '',
                      ),
                    ] else if (showSelfAssessment) ...[
                      MonthlyEvaluationWidget(),
                    ] else if (resultSelfAssessment) ...[
                      FetchDataScreen(),
                    ],
                  ],
                ),
              ),
            ),
          ),
          // Welcome Text
        ],
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  final VoidCallback toggleGoodDeeds;
  final VoidCallback toggleLeaderboard;
  final VoidCallback toggleSelfAssessment;
  final VoidCallback resultSelfAssessment;

  MyDrawer({
    Key? key,
    required this.toggleGoodDeeds,
    required this.toggleLeaderboard,
    required this.toggleSelfAssessment,
    required this.resultSelfAssessment,
  }) : super(key: key);

  final TextStyle drawerTextStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/Logo.png'),
                fit: BoxFit.fitHeight,
              ),
            ),
            child: null,
          ),
          SizedBox(height: 24.0),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    leading: const Icon(Icons.leaderboard_outlined),
                    title: Center(
                      child: SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: toggleLeaderboard,
                          child: Text(
                            'Leaderboard',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Center(
                      child: SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: toggleGoodDeeds,
                          child: Text(
                            'Borang Amalan baik',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    leading: const Icon(Icons.folder_copy),
                    title: Center(
                      child: SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: toggleSelfAssessment,
                          child: Text(
                            'Borang Penilaian Diri Tahunan',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    leading: const Icon(Icons.folder_copy),
                    title: Center(
                      child: SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: resultSelfAssessment,
                          child: Text(
                            'Laporan Penilaian Diri',
                            style: TextStyle(fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: ListTile(
              leading: const Icon(Icons.logout),
              title: Center(
                child: Text(
                  'Log Keluar',
                  style: drawerTextStyle,
                ),
              ),
              onTap: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => LoginPage()),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
