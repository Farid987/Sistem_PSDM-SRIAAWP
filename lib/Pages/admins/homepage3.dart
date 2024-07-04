import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/Pages/admins/Student/add_student.dart';
import 'package:login/Pages/admins/Student/delete_student.dart';
import 'package:login/Pages/admins/Student/edit_student.dart';

import '../loginpage.dart';
//import 'add_student.dart';
import 'Teacher/add_teacher.dart';
import 'Teacher/delete_profile.dart';
import 'Teacher/edit_profile.dart';
// import 'notification.dart';
//import 'notification.dart'; // Import
import 'self_assessment_admin.dart';
import 'validation.dart'; // Import the AddTeacherPage

class Admins extends StatefulWidget {
  final User? user;

  const Admins({Key? key, this.user}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<Admins> {
  bool showAddTeacher = false;
  bool showEditTeacher = false;
  bool showDeleteTeacher = false;
  bool showAddStudent = false;
  bool showEditStudent = false;
  bool showDeleteStudent = false;
  bool showValidation = false;
  bool showTeacherInfo = false;
  bool showStudentInfo = false;
  bool showSelfassessment = false;

  void toggleAddTeacher() {
    setState(() {
      showAddTeacher = !showAddTeacher;
      if (showAddTeacher) {
        showEditTeacher = false;
        showDeleteTeacher = false;
        showAddStudent = false;
        showEditStudent = false;
        showDeleteStudent = false;
        showValidation = false;
        showSelfassessment = false;
      }
    });
  }

  void toggleEditTeacher() {
    setState(() {
      showEditTeacher = !showEditTeacher;
      if (showEditTeacher) {
        showAddTeacher = false;
        showDeleteTeacher = false;
        showAddStudent = false;
        showEditStudent = false;
        showDeleteStudent = false;
        showValidation = false;
        showSelfassessment = false;
      }
    });
  }

  void toggleDeleteTeacher() {
    setState(() {
      showDeleteTeacher = !showDeleteTeacher;
      if (showDeleteTeacher) {
        showAddTeacher = false;
        showEditTeacher = false;
        showAddStudent = false;
        showEditStudent = false;
        showDeleteStudent = false;
        showValidation = false;
        showSelfassessment = false;
      }
    });
  }

  void toggleAddStudent() {
    setState(() {
      showAddStudent = !showAddStudent;
      if (showAddStudent) {
        showAddTeacher = false;
        showEditTeacher = false;
        showDeleteTeacher = false;
        showEditStudent = false;
        showDeleteStudent = false;
        showValidation = false;
        showSelfassessment = false;
      }
    });
  }

  void toggleEditStudent() {
    setState(() {
      showEditStudent = !showEditStudent;
      if (showEditStudent) {
        showAddTeacher = false;
        showEditTeacher = false;
        showDeleteTeacher = false;
        showAddStudent = false;
        showDeleteStudent = false;
        showValidation = false;
        showSelfassessment = false;
      }
    });
  }

  void toggleDeleteStudent() {
    setState(() {
      showDeleteStudent = !showDeleteStudent;
      if (showDeleteStudent) {
        showAddTeacher = false;
        showEditTeacher = false;
        showDeleteTeacher = false;
        showAddStudent = false;
        showEditStudent = false;
        showValidation = false;
        showSelfassessment = false;
      }
    });
  }

  void toggleValidation() {
    setState(() {
      showValidation = !showValidation;
      if (showValidation) {
        showAddTeacher = false;
        showEditTeacher = false;
        showDeleteTeacher = false;
        showAddStudent = false;
        showEditStudent = false;
        showDeleteStudent = false;
        showSelfassessment = false;
      }
    });
  }

  void toggleSelfAssessment() {
    setState(() {
      showSelfassessment = !showSelfassessment;
      if (showSelfassessment) {
        showAddTeacher = false;
        showEditTeacher = false;
        showDeleteTeacher = false;
        showAddStudent = false;
        showEditStudent = false;
        showDeleteStudent = false;
        showValidation = false;
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
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 1.0), // Add some padding for better appearance
              decoration: BoxDecoration(
                color: Colors.purple[900], // Fill color inside the container
                border: Border.all(color: Colors.white), // Border color
                borderRadius: BorderRadius.circular(
                    8.0), // Optional: make the border rounded
              ),
              child: Text(
                'Sistem Penilaian Sahsiah Diri Murid',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:
                        Colors.white), // Adjust font size and color as needed
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      drawer: MyDrawer(
        toggleAddTeacher: toggleAddTeacher,
        toggleEditTeacher: toggleEditTeacher,
        toggleDeleteTeacher: toggleDeleteTeacher,
        toggleAddStudent: toggleAddStudent,
        toggleEditStudent: toggleEditStudent,
        toggleDeleteStudent: toggleDeleteStudent,
        toggleValidation: toggleValidation,
        toggleSelfAssessment: toggleSelfAssessment,
      ),
      
      body: Stack(
        children: [
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
          //Main Content Area
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
                    if (showAddTeacher) ...[
                      AddTeacherWidget(),
                    ] else if (showEditTeacher) ...[
                      EditTeacherWidget(),
                    ] else if (showDeleteTeacher) ...[
                      DeleteTeacherWidget(),
                    ] else if (showAddStudent) ...[
                      AddStudentWidget(),
                    ] else if (showEditStudent) ...[
                      EditStudentWidget(),
                    ] else if (showDeleteStudent) ...[
                      DeleteStudentWidget(),
                    ] else if (showValidation) ...[
                      ValidationWidget(),
                    ] else if (showSelfassessment) ...[
                      SelfassessmentWidgets(),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  final VoidCallback toggleAddTeacher;
  final VoidCallback toggleEditTeacher;
  final VoidCallback toggleDeleteTeacher;
  final VoidCallback toggleAddStudent;
  final VoidCallback toggleEditStudent;
  final VoidCallback toggleDeleteStudent;
  final VoidCallback toggleValidation;
  final VoidCallback toggleSelfAssessment;

  MyDrawer({
    Key? key,
    required this.toggleAddTeacher,
    required this.toggleEditTeacher,
    required this.toggleDeleteTeacher,
    required this.toggleAddStudent,
    required this.toggleEditStudent,
    required this.toggleDeleteStudent,
    required this.toggleValidation,
    required this.toggleSelfAssessment,
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
          ExpansionTile(
            title: Text("Maklumat Guru"),
            leading: Icon(Icons.person),
            childrenPadding: const EdgeInsets.only(left: 60),
            children: [
              ListTile(
                title: Text("Tambah Maklumat Guru"),
                leading: Icon(Icons.person_add_alt_1),
                onTap: toggleAddTeacher,
              ),
              ListTile(
                title: Text("Mengubah Suai Maklumat Guru"),
                leading: Icon(Icons.person_remove_alt_1),
                onTap: toggleEditTeacher,
              ),
              ListTile(
                title: Text("Padam Maklumat Guru"),
                leading: Icon(Icons.person_off),
                onTap: toggleDeleteTeacher,
              )
            ],
          ),
          ExpansionTile(
            title: Text("Maklumat Murid"),
            leading: Icon(Icons.person_2_outlined),
            childrenPadding: const EdgeInsets.only(left: 60),
            children: [
              ListTile(
                title: Text("Tambah Maklumat Murid"),
                leading: Icon(Icons.person_add_alt_1),
                onTap: toggleAddStudent,
              ),
              ListTile(
                title: Text("Ubah Suai Maklumat Murid"),
                leading: Icon(Icons.person_remove_alt_1),
                onTap: toggleEditStudent,
              ),
              ListTile(
                title: Text("Padam Maklumat Murid"),
                leading: Icon(Icons.person_off),
                onTap: toggleDeleteStudent,
              )
            ],
          ),
          // plement navigation or functionality here

          ListTile(
            title: Text("Pengesahan Laporan"),
            leading: const Icon(Icons.domain_verification_outlined),
            onTap: toggleValidation,
          ),
          ListTile(
            title: Text("Borang Pengesahan Penilaian Diri"),
            leading: const Icon(Icons.domain_verification_outlined),
            onTap: toggleSelfAssessment,
          ),
          Spacer(),
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
                  Navigator.pushReplacement(
                    context,
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
