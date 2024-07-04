import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditTeacherWidget extends StatefulWidget {
  @override
  _EditTeacherWidgetState createState() => _EditTeacherWidgetState();
}

class _EditTeacherWidgetState extends State<EditTeacherWidget> {
  // Define TextEditingController instances
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? selectedStaffID;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _fetchStaffIDs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return buildUI(snapshot.data!);
        }
      },
    );
  }

  Widget buildUI(List<String> staffIDs) {
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
              'Ubah Suai (Guru)',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'ID Guru',
                border: OutlineInputBorder(),
              ),
              value: selectedStaffID,
              onChanged: (value) {
                setState(() {
                  selectedStaffID = value;
                  _fetchTeacherDetails(selectedStaffID!);
                });
              },
              items: staffIDs.map((staffID) {
                return DropdownMenuItem<String>(
                  value: staffID,
                  child: Text(staffID),
                );
              }).toList(),
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
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle submit button action
                  _handleSubmit();
                },
                child: Text(
                  'Ubah Suai',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 255, 202, 87),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label,
      {String? hintText, required TextEditingController controller}) {
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

  Future<List<String>> _fetchStaffIDs() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Auth_teacher').get();
    List<String> staffIDs = [];
    querySnapshot.docs.forEach((doc) {
      staffIDs.add(doc['StaffID']);
    });
    return staffIDs;
  }

  Future<void> _fetchTeacherDetails(String staffID) async {
    setState(() {
      isLoading = true;
    });
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('Auth_teacher')
          .where('StaffID', isEqualTo: staffID)
          .limit(1)
          .get()
          .then((value) => value.docs.first);
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        nameController.text = data['Name'];
        emailController.text = data['Email'];
        passwordController.text = data['Password'];
      } else {
        // Handle if no matching document is found
      }
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _handleSubmit() async {
    // Get the text entered in the text fields
    String name = nameController.text.trim();
    String password = passwordController.text.trim();
    String email = emailController.text.trim();
    String staffID = selectedStaffID ?? '';

    // Prepare the data to be updated
    Map<String, dynamic> teacherData = {
      'Name': name,
      'Email': email,
      'Password': password,
      'StaffID': staffID,
    };

    try {
      // Update the document in Firestore based on StaffID
      await FirebaseFirestore.instance
          .collection('Auth_teacher')
          .where('StaffID', isEqualTo: staffID)
          .limit(1)
          .get()
          .then((querySnapshot) {
        String docID = querySnapshot.docs.first.id;

        // Delete the old document
        FirebaseFirestore.instance
            .collection('Auth_teacher')
            .doc(docID)
            .delete()
            .then((_) {
          // Set a new document with the updated email as the ID
          FirebaseFirestore.instance
              .collection('Auth_teacher')
              .doc(email)
              .set(teacherData)
              .then((_) {
            print('Teacher data updated successfully');

            // Clear the text controllers
            nameController.clear();
            passwordController.clear();
            emailController.clear();
            // staffIDController.clear();
          });
        });
      });
    } catch (e) {
      print('Error updating teacher data: $e');
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: EditTeacherWidget(),
  ));
}
